import 'dart:math' as math;
import 'dart:typed_data';

import 'package:image/image.dart' as img;

/// Kotak wajah dalam koordinat piksel gambar (tegak, sesudah rotasi EXIF).
class FaceBox {
  final double left, top, width, height;

  const FaceBox(this.left, this.top, this.width, this.height);
}

/// Menyiapkan gambar wajah untuk model: potong, ubah ukuran, normalisasi.
class FacePreprocessor {
  /// Ukuran sisi input model (MobileFaceNet: 112).
  final int inputSize;

  /// Ruang tambahan di sekitar kotak wajah, relatif terhadap ukuran kotak.
  /// Model dilatih dengan wajah yang sedikit lebih longgar dari kotak deteksi.
  final double margin;

  const FacePreprocessor({required this.inputSize, this.margin = 0.1});

  /// Potong wajah (persegi, dibatasi tepi gambar) lalu ubah ke [inputSize].
  img.Image cropFace(img.Image image, FaceBox box) {
    final side = math.max(box.width, box.height) * (1 + margin * 2);
    final centerX = box.left + box.width / 2;
    final centerY = box.top + box.height / 2;

    final x = (centerX - side / 2).round().clamp(0, image.width - 1);
    final y = (centerY - side / 2).round().clamp(0, image.height - 1);
    final w = side.round().clamp(1, image.width - x);
    final h = side.round().clamp(1, image.height - y);

    final face = img.copyCrop(image, x: x, y: y, width: w, height: h);
    return img.copyResize(
      face,
      width: inputSize,
      height: inputSize,
      interpolation: img.Interpolation.linear,
    );
  }

  /// Piksel RGB 0–255 menjadi float sekitar -1..1, urutan [baris][kolom][RGB].
  Float32List toInput(img.Image face) {
    final out = Float32List(inputSize * inputSize * 3);
    var i = 0;
    for (var y = 0; y < inputSize; y++) {
      for (var x = 0; x < inputSize; x++) {
        final p = face.getPixel(x, y);
        out[i++] = (p.r - 127.5) / 128;
        out[i++] = (p.g - 127.5) / 128;
        out[i++] = (p.b - 127.5) / 128;
      }
    }
    return out;
  }
}
