import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:smart_school_mobile/features/face_recognition/face_math.dart';
import 'package:smart_school_mobile/features/face_recognition/face_preprocessor.dart';

void main() {
  group('face_math', () {
    test('l2Normalize membuat panjang vektor = 1', () {
      final v = l2Normalize([3, 4]);
      expect(v[0], closeTo(0.6, 1e-9));
      expect(v[1], closeTo(0.8, 1e-9));
      expect(l2Normalize([0, 0]), [0, 0]);
    });

    test('kemiripan cosinus: sama = 1, tegak lurus = 0, berlawanan = -1', () {
      expect(cosineSimilarity([1, 2, 3], [2, 4, 6]), closeTo(1, 1e-9));
      expect(cosineSimilarity([1, 0], [0, 1]), closeTo(0, 1e-9));
      expect(cosineSimilarity([1, 0], [-1, 0]), closeTo(-1, 1e-9));
    });

    test('panjang embedding berbeda dianggap model berbeda', () {
      expect(() => cosineSimilarity([1, 2], [1, 2, 3]), throwsArgumentError);
    });

    test('matcher memakai sampel termirip dan menghormati batas', () {
      final gallery = {
        'Ahmad': [
          [1.0, 0.0],
          [0.9, 0.1],
        ],
        'Dinda': [
          [0.0, 1.0],
        ],
        'Kosong': <List<double>>[],
      };
      const matcher = FaceMatcher(threshold: 0.9);

      final ranked = matcher.rank([1.0, 0.05], gallery);
      expect(ranked.map((m) => m.personId), ['Ahmad', 'Dinda']);
      expect(matcher.bestMatch([1.0, 0.05], gallery)?.personId, 'Ahmad');

      // Di tengah-tengah kedua orang: tidak ada yang melewati batas 0.9.
      expect(matcher.bestMatch([1.0, 1.0], gallery), isNull);
    });
  });

  group('FacePreprocessor', () {
    const prep = FacePreprocessor(inputSize: 112, margin: 0.1);

    test('potongan wajah selalu berukuran input model', () {
      final photo = img.Image(width: 480, height: 640);
      final face = prep.cropFace(photo, const FaceBox(100, 150, 200, 240));
      expect(face.width, 112);
      expect(face.height, 112);
    });

    test('kotak wajah di tepi foto tidak keluar batas gambar', () {
      final photo = img.Image(width: 480, height: 640);
      final face = prep.cropFace(photo, const FaceBox(400, 580, 120, 120));
      expect(face.width, 112);
      expect(face.height, 112);
    });

    test('piksel dinormalisasi ke sekitar -1..1 dengan urutan RGB', () {
      final face = img.Image(width: 112, height: 112)
        ..clear(img.ColorRgb8(255, 0, 128));
      final input = prep.toInput(face);
      expect(input.length, 112 * 112 * 3);
      expect(input[0], closeTo((255 - 127.5) / 128, 1e-6)); // R
      expect(input[1], closeTo((0 - 127.5) / 128, 1e-6)); // G
      expect(input[2], closeTo((128 - 127.5) / 128, 1e-6)); // B
    });
  });
}
