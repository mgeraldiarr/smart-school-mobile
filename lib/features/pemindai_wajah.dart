import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

import 'teacher/models/teacher_schedule.dart';
import 'verifikasi_kehadiran.dart';

// HALAMAN PEMINDAI WAJAH
class PemindaiWajahPage extends StatefulWidget {
  final TeacherSchedule schedule;

  const PemindaiWajahPage({super.key, required this.schedule});

  @override
  State<PemindaiWajahPage> createState() => _PemindaiWajahPageState();
}

class _PemindaiWajahPageState extends State<PemindaiWajahPage> {
  CameraController? cameraController;

  // STATUS FLASH, PEMINDAIAN, DAN KAMERA
  bool flashAktif = false;
  bool sedangMemindai = false;
  bool kameraSiap = false;
  bool kameraDepan = false;

  // PESAN INFORMASI
  void tampilkanPesan(String pesan) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(pesan), behavior: SnackBarBehavior.floating),
    );
  }

  // MENGAKTIFKAN KAMERA HP
  Future<void> mulaiKamera() async {
    try {
      final cameras = await availableCameras();

      if (cameras.isEmpty) {
        tampilkanPesan('Kamera tidak ditemukan');
        return;
      }

      final kamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      await pasangKamera(kamera);
    } catch (e) {
      tampilkanPesan('Gagal membuka kamera: $e');
    }
  }

  // MEMASANG KAMERA KE CONTROLLER
  Future<void> pasangKamera(CameraDescription kamera) async {
    setState(() {
      kameraSiap = false;
    });

    await cameraController?.dispose();

    final controller = CameraController(
      kamera,
      ResolutionPreset.high,
      enableAudio: false,
    );

    cameraController = controller;

    try {
      await controller.initialize();

      if (!mounted) return;

      await controller.setFlashMode(FlashMode.off);

      setState(() {
        kameraSiap = true;
        kameraDepan = kamera.lensDirection == CameraLensDirection.front;
        flashAktif = false;
      });
    } catch (e) {
      tampilkanPesan('Kamera gagal diinisialisasi: $e');
    }
  }

  // MENGGANTI KAMERA DEPAN DAN BELAKANG
  Future<void> putarKamera() async {
    final cameras = await availableCameras();

    if (cameras.isEmpty) return;

    final tujuan = kameraDepan
        ? CameraLensDirection.back
        : CameraLensDirection.front;

    final kameraBaru = cameras.where(
      (camera) => camera.lensDirection == tujuan,
    );

    if (kameraBaru.isEmpty) {
      tampilkanPesan('Kamera tidak tersedia');
      return;
    }

    await pasangKamera(kameraBaru.first);
  }

  // MENGAKTIFKAN ATAU MEMATIKAN FLASH
  Future<void> ubahFlash() async {
    if (cameraController == null || !kameraSiap) return;

    try {
      final mode = flashAktif ? FlashMode.off : FlashMode.torch;

      await cameraController!.setFlashMode(mode);

      setState(() {
        flashAktif = !flashAktif;
      });
    } catch (e) {
      tampilkanPesan('Flash tidak tersedia pada kamera ini');
    }
  }

  // MENGAMBIL FOTO UNTUK PROSES PEMINDAIAN
  Future<void> pindaiWajah() async {
    if (!kameraSiap || cameraController == null || sedangMemindai) {
      return;
    }

    try {
      setState(() {
        sedangMemindai = true;
      });

      final foto = await cameraController!.takePicture();

      if (!mounted) return;

      tampilkanPesan('Foto berhasil diambil');

      // FOTO TERSIMPAN DI LOKASI SEMENTARA.
      // NAVIGASI KE HALAMAN VERIFIKASI.
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              VerifikasiKehadiranPage(schedule: widget.schedule),
        ),
      );

      // Variabel foto.path berisi lokasi file foto.
      debugPrint('Lokasi foto: ${foto.path}');
    } catch (e) {
      tampilkanPesan('Gagal mengambil foto: $e');
    } finally {
      if (mounted) {
        setState(() {
          sedangMemindai = false;
        });
      }
    }
  }

  // MENJALANKAN KAMERA SAAT HALAMAN DIBUKA
  @override
  void initState() {
    super.initState();
    mulaiKamera();
  }

  // MEMATIKAN KAMERA SAAT HALAMAN DITUTUP
  @override
  void dispose() {
    cameraController?.dispose();
    super.dispose();
  }

  // MEMBANGUN TAMPILAN HALAMAN
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF091B2B),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // PREVIEW KAMERA ASLI
          if (kameraSiap && cameraController != null)
            Center(child: CameraPreview(cameraController!))
          else
            Container(
              color: const Color(0xFF263C50),
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),

          // LAPISAN GELAP AGAR TEKS TERBACA
          Container(color: const Color(0x55101C30)),

          SafeArea(
            child: Column(
              children: [
                // HEADER HALAMAN
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 10,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                        ),
                      ),
                      const Expanded(
                        child: Column(
                          children: [
                            Text(
                              'Pemindai Wajah',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              '● Kamera aktif',
                              style: TextStyle(
                                color: Color(0xFF39DCA0),
                                fontSize: 9,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: ubahFlash,
                        icon: Icon(
                          flashAktif ? Icons.flash_on : Icons.bolt,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),

                // AREA BINGKAI WAJAH
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 230,
                          height: 280,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color(0xFF4ACBFF),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Center(
                            child: Container(
                              width: 165,
                              height: 235,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.white70,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(100),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          sedangMemindai
                              ? 'Mengambil gambar wajah...'
                              : 'Arahkan wajah siswa ke dalam area kamera',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Pastikan wajah terlihat jelas dan pencahayaan cukup',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white70, fontSize: 9),
                        ),
                      ],
                    ),
                  ),
                ),

                // PANEL INFORMASI BAWAH
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 25),
                  decoration: const BoxDecoration(
                    color: Color(0xFF091B2B),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(27),
                    ),
                  ),
                  child: Column(
                    children: [
                      // INFORMASI MATA PELAJARAN
                      const Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Mata Pelajaran',
                                  style: TextStyle(
                                    color: Colors.white54,
                                    fontSize: 8,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'Matematika',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Kelas',
                                  style: TextStyle(
                                    color: Colors.white54,
                                    fontSize: 8,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  '8A',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Guru',
                                  style: TextStyle(
                                    color: Colors.white54,
                                    fontSize: 8,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'Pak Ahmad',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 25),

                      // TOMBOL KONTROL KAMERA
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          TextButton.icon(
                            onPressed: putarKamera,
                            icon: const Icon(
                              Icons.refresh,
                              color: Colors.white70,
                            ),
                            label: const Text(
                              'Putar',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 10,
                              ),
                            ),
                          ),

                          // TOMBOL PEMINDAIAN
                          GestureDetector(
                            onTap: pindaiWajah,
                            child: Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFF4ACBFF),
                                  width: 2,
                                ),
                              ),
                              child: Icon(
                                sedangMemindai
                                    ? Icons.hourglass_top
                                    : Icons.face_retouching_natural,
                                color: const Color(0xFF1269C8),
                                size: 30,
                              ),
                            ),
                          ),

                          TextButton.icon(
                            onPressed: ubahFlash,
                            icon: Icon(
                              flashAktif ? Icons.flash_on : Icons.bolt,
                              color: Colors.white70,
                            ),
                            label: const Text(
                              'Flash',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // ABSENSI MANUAL
                      TextButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  VerifikasiKehadiranPage(
                                    schedule: widget.schedule,
                                  ),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.assignment_outlined,
                          color: Colors.white,
                        ),
                        label: const Text(
                          'Absensi Manual',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
