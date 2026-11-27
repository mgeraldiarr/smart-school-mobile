import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image/image.dart' as img;

import '../face_embedder.dart';
import '../face_evaluation.dart';
import '../face_math.dart';
import '../face_preprocessor.dart';

/// Layar uji teknis pengenalan wajah (bukan fitur untuk pengguna).
///
/// Menjawab: berapa lama tiap tahap berjalan di HP, berapa kemiripan orang
/// yang sama vs berbeda, dan berapa panjang embedding model. Semua data wajah
/// hanya ada di memori dan hilang saat aplikasi ditutup.
class FacePrototypeScreen extends StatefulWidget {
  const FacePrototypeScreen({super.key});

  @override
  State<FacePrototypeScreen> createState() => _FacePrototypeScreenState();
}

class _Analysis {
  final List<double> embedding;
  final Float32List input;
  final Uint8List cropPng;
  final Face face;
  final int faceCount;
  final int detectMs, prepareMs, modelMs;

  const _Analysis({
    required this.embedding,
    required this.input,
    required this.cropPng,
    required this.face,
    required this.faceCount,
    required this.detectMs,
    required this.prepareMs,
    required this.modelMs,
  });
}

class _FacePrototypeScreenState extends State<FacePrototypeScreen> {
  static const _maxSamples = 5;

  CameraController? _camera;
  FaceEmbedder? _embedder;
  FacePreprocessor? _preprocessor;
  final _detector = FaceDetector(
    options: FaceDetectorOptions(
      performanceMode: FaceDetectorMode.accurate,
      enableClassification: true, // Peluang mata terbuka, untuk cek kedip.
    ),
  );

  final Map<String, List<List<double>>> _gallery = {
    'Orang A': [],
    'Orang B': [],
  };
  String _selected = 'Orang A';
  double _threshold = 0.75;
  bool _busy = false;
  String? _error;
  _Analysis? _last;
  List<FaceMatch> _lastRanking = const [];
  final List<String> _log = [];

  /// Jawaban benar untuk percobaan "Cocokkan" berikutnya.
  static const _unregistered = 'Tidak terdaftar';
  String _actual = 'Orang A';
  final List<MatchTrial> _trials = [];

  @override
  void initState() {
    super.initState();
    _setUp();
  }

  @override
  void dispose() {
    _camera?.dispose();
    _detector.close();
    _embedder?.close();
    super.dispose();
  }

  Future<void> _setUp() async {
    if (defaultTargetPlatform != TargetPlatform.android &&
        defaultTargetPlatform != TargetPlatform.iOS) {
      setState(() => _error = 'Prototipe hanya berjalan di Android/iOS.');
      return;
    }
    try {
      final embedder = await FaceEmbedder.load();
      final cameras = await availableCameras();
      final front = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );
      final camera = CameraController(
        front,
        ResolutionPreset.medium,
        enableAudio: false,
      );
      await camera.initialize();
      if (!mounted) return;
      setState(() {
        _embedder = embedder;
        _preprocessor = FacePreprocessor(inputSize: embedder.inputSize);
        _camera = camera;
      });
      _addLog(
        'Model siap: input ${embedder.inputSize}x${embedder.inputSize}, '
        'embedding ${embedder.embeddingLength} angka.',
      );
    } catch (e) {
      if (mounted) setState(() => _error = 'Gagal menyiapkan: $e');
    }
  }

  /// Foto → deteksi → potong → embedding, dengan waktu tiap tahap.
  Future<_Analysis?> _analyze() async {
    final camera = _camera, embedder = _embedder, prep = _preprocessor;
    if (camera == null || embedder == null || prep == null) return null;

    final photo = await camera.takePicture();

    final detectWatch = Stopwatch()..start();
    final faces = await _detector.processImage(
      InputImage.fromFilePath(photo.path),
    );
    detectWatch.stop();
    if (faces.isEmpty) {
      _toast('Wajah tidak terdeteksi. Coba lagi dengan cahaya lebih terang.');
      return null;
    }
    // Wajah terbesar = orang yang paling dekat ke kamera.
    final face = faces.reduce(
      (a, b) =>
          a.boundingBox.width * a.boundingBox.height >=
              b.boundingBox.width * b.boundingBox.height
          ? a
          : b,
    );

    final prepareWatch = Stopwatch()..start();
    final decoded = img.decodeImage(await photo.readAsBytes());
    if (decoded == null) {
      _toast('Foto tidak bisa dibaca.');
      return null;
    }
    // Putar sesuai EXIF agar sejajar dengan koordinat dari ML Kit.
    final upright = img.bakeOrientation(decoded);
    final box = face.boundingBox;
    final crop = prep.cropFace(
      upright,
      FaceBox(box.left, box.top, box.width, box.height),
    );
    final input = prep.toInput(crop);
    prepareWatch.stop();

    final modelWatch = Stopwatch()..start();
    final embedding = embedder.embed(input);
    modelWatch.stop();

    return _Analysis(
      embedding: embedding,
      input: input,
      cropPng: img.encodePng(crop),
      face: face,
      faceCount: faces.length,
      detectMs: detectWatch.elapsedMilliseconds,
      prepareMs: prepareWatch.elapsedMilliseconds,
      modelMs: modelWatch.elapsedMilliseconds,
    );
  }

  Future<void> _run(Future<void> Function() task) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await task();
    } catch (e) {
      _toast('Gagal: $e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _enroll() => _run(() async {
    final samples = _gallery[_selected]!;
    if (samples.length >= _maxSamples) {
      _toast('$_selected sudah punya $_maxSamples sampel.');
      return;
    }
    final result = await _analyze();
    if (result == null) return;
    setState(() {
      samples.add(result.embedding);
      _last = result;
      _lastRanking = const [];
    });
    _addLog(
      'DAFTAR $_selected sampel ${samples.length} | ${_timings(result)}'
      '${result.faceCount > 1 ? ' | ${result.faceCount} wajah, dipakai yang terbesar' : ''}',
    );
  });

  Future<void> _match() => _run(() async {
    if (_gallery.values.every((s) => s.isEmpty)) {
      _toast('Daftarkan minimal satu orang dulu.');
      return;
    }
    final result = await _analyze();
    if (result == null) return;
    final ranking = FaceMatcher(threshold: _threshold)
        .rank(result.embedding, _gallery);
    setState(() {
      _last = result;
      _lastRanking = ranking;
    });
    final best = ranking.first;
    final verdict = best.similarity >= _threshold
        ? 'COCOK ${best.personId}'
        : 'TIDAK DIKENAL';
    _trials.add(
      MatchTrial(
        actualPersonId: _actual == _unregistered ? null : _actual,
        ranking: ranking,
      ),
    );
    _addLog(
      'COCOKKAN (asli: $_actual) -> $verdict | '
      '${ranking.map((m) => '${m.personId} ${m.similarity.toStringAsFixed(3)}').join(', ')}'
      ' | batas ${_threshold.toStringAsFixed(2)} | ${_timings(result)}',
    );
  });

  Future<void> _benchmark() => _run(() async {
    final input = _last?.input;
    if (input == null) {
      _toast('Ambil satu foto dulu (daftar atau cocokkan).');
      return;
    }
    const rounds = 20;
    final watch = Stopwatch()..start();
    for (var i = 0; i < rounds; i++) {
      _embedder!.embed(input);
    }
    watch.stop();
    _addLog(
      'KECEPATAN model rata-rata '
      '${(watch.elapsedMilliseconds / rounds).toStringAsFixed(1)} ms ($rounds kali)',
    );
  });

  /// Ringkasan akurasi semua percobaan "Cocokkan" sejak data dihapus.
  void _summarize() {
    if (_trials.isEmpty) {
      _toast('Lakukan beberapa kali "Cocokkan" dulu.');
      return;
    }
    final report = ThresholdReport.evaluate(_trials, _threshold);
    String stats(List<double> s) {
      if (s.isEmpty) return '-';
      final sorted = [...s]..sort();
      final avg = s.reduce((a, b) => a + b) / s.length;
      return 'min ${sorted.first.toStringAsFixed(3)}, '
          'rata ${avg.toStringAsFixed(3)}, '
          'maks ${sorted.last.toStringAsFixed(3)} (${s.length})';
    }

    final suggestion = report.suggestedThreshold;
    _addLog(
      'RINGKASAN ${report.total} percobaan | '
      'benar ${report.correct}/${report.total} pada batas ${_threshold.toStringAsFixed(2)} | '
      'orang sama: ${stats(report.genuineScores)} | '
      'orang beda: ${stats(report.impostorScores)} | '
      'saran batas: ${suggestion == null ? 'tidak bisa (nilai tumpang tindih)' : suggestion.toStringAsFixed(2)}',
    );
  }

  String _timings(_Analysis a) =>
      'deteksi ${a.detectMs} ms, olah ${a.prepareMs} ms, model ${a.modelMs} ms';

  void _addLog(String line) {
    final now = TimeOfDay.now().format(context);
    setState(() => _log.insert(0, '[$now] $line'));
  }

  void _toast(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  void _addPerson() {
    final name = 'Orang ${String.fromCharCode(65 + _gallery.length)}';
    setState(() {
      _gallery[name] = [];
      _selected = name;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prototipe Pengenalan Wajah'),
        actions: [
          IconButton(
            tooltip: 'Salin log',
            icon: const Icon(Icons.copy_all_rounded),
            onPressed: _log.isEmpty
                ? null
                : () async {
                    await Clipboard.setData(
                      ClipboardData(text: _log.reversed.join('\n')),
                    );
                    _toast('Log disalin.');
                  },
          ),
        ],
      ),
      body: _error != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(_error!, textAlign: TextAlign.center),
              ),
            )
          : _camera == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildPreview(),
                const SizedBox(height: 12),
                _buildPeople(),
                const SizedBox(height: 8),
                _buildActualPerson(),
                const SizedBox(height: 8),
                _buildActions(),
                const SizedBox(height: 8),
                _buildThreshold(),
                if (_last != null) _buildLastResult(_last!),
                const Divider(height: 32),
                Text('Log', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                for (final line in _log)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: SelectableText(
                      line,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            ),
    );
  }

  Widget _buildPreview() {
    // previewSize dilaporkan dalam posisi landscape (lebar > tinggi), jadi
    // ditukar untuk HP yang tegak. FittedBox.cover memotong pinggir gambar
    // tanpa menarik/menggepengkan wajah.
    final size = _camera!.value.previewSize!;
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: AspectRatio(
        aspectRatio: 3 / 4,
        child: Stack(
          fit: StackFit.expand,
          children: [
            FittedBox(
              fit: BoxFit.cover,
              clipBehavior: Clip.hardEdge,
              child: SizedBox(
                width: size.height,
                height: size.width,
                child: CameraPreview(_camera!),
              ),
            ),
            if (_busy)
              const ColoredBox(
                color: Colors.black38,
                child: Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPeople() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final entry in _gallery.entries)
          ChoiceChip(
            label: Text('${entry.key} (${entry.value.length}/$_maxSamples)'),
            selected: _selected == entry.key,
            onSelected: (_) => setState(() => _selected = entry.key),
          ),
        ActionChip(
          avatar: const Icon(Icons.add, size: 18),
          label: const Text('Orang'),
          onPressed: _gallery.length >= 6 ? null : _addPerson,
        ),
        ActionChip(
          avatar: const Icon(Icons.restart_alt, size: 18),
          label: const Text('Hapus semua'),
          onPressed: () => setState(() {
            for (final samples in _gallery.values) {
              samples.clear();
            }
            _last = null;
            _lastRanking = const [];
            _trials.clear();
          }),
        ),
      ],
    );
  }

  /// Dipilih sebelum menekan "Cocokkan", supaya hasilnya bisa dinilai benar/salah.
  Widget _buildActualPerson() {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        const Text('Yang dipindai:'),
        for (final name in [..._gallery.keys, _unregistered])
          ChoiceChip(
            label: Text(name),
            selected: _actual == name,
            onSelected: (_) => setState(() => _actual = name),
          ),
      ],
    );
  }

  Widget _buildActions() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        FilledButton.icon(
          onPressed: _busy ? null : _enroll,
          icon: const Icon(Icons.person_add_alt_1),
          label: Text('Daftarkan ke $_selected'),
        ),
        FilledButton.tonalIcon(
          onPressed: _busy ? null : _match,
          icon: const Icon(Icons.face_retouching_natural),
          label: const Text('Cocokkan'),
        ),
        OutlinedButton.icon(
          onPressed: _busy ? null : _benchmark,
          icon: const Icon(Icons.speed),
          label: const Text('Uji kecepatan'),
        ),
        OutlinedButton.icon(
          onPressed: _busy ? null : _summarize,
          icon: const Icon(Icons.analytics_outlined),
          label: Text('Ringkasan (${_trials.length})'),
        ),
      ],
    );
  }

  Widget _buildThreshold() {
    return Row(
      children: [
        const Text('Batas cocok'),
        Expanded(
          child: Slider(
            value: _threshold,
            min: 0.30,
            max: 0.95,
            divisions: 65,
            label: _threshold.toStringAsFixed(2),
            onChanged: (v) => setState(() => _threshold = v),
          ),
        ),
        Text(_threshold.toStringAsFixed(2)),
      ],
    );
  }

  Widget _buildLastResult(_Analysis a) {
    String percent(double? p) =>
        p == null ? '-' : '${(p * 100).toStringAsFixed(0)}%';
    final f = a.face;

    return Card(
      margin: const EdgeInsets.only(top: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Periksa: potongan harus berisi wajah utuh. Kalau meleset,
            // berarti orientasi foto dan koordinat ML Kit tidak sejajar.
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.memory(a.cropPng, width: 96, height: 96),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_timings(a)),
                  const SizedBox(height: 4),
                  Text(
                    'Mata kiri ${percent(f.leftEyeOpenProbability)}, '
                    'kanan ${percent(f.rightEyeOpenProbability)}',
                  ),
                  Text(
                    'Toleh ${f.headEulerAngleY?.toStringAsFixed(0) ?? '-'}°, '
                    'miring ${f.headEulerAngleZ?.toStringAsFixed(0) ?? '-'}°',
                  ),
                  for (final m in _lastRanking)
                    Text(
                      '${m.personId}: ${m.similarity.toStringAsFixed(3)}'
                      '${m.similarity >= _threshold ? '  ✓' : ''}',
                      style: TextStyle(
                        fontWeight: m == _lastRanking.first
                            ? FontWeight.w700
                            : FontWeight.normal,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
