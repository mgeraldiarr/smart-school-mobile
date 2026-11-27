import 'dart:typed_data';

import 'package:tflite_flutter/tflite_flutter.dart';

import 'face_math.dart';

/// Menjalankan model MobileFaceNet: wajah 112×112 menjadi embedding.
///
/// Ukuran input dan panjang embedding dibaca dari model, bukan ditulis tetap,
/// supaya penggantian model langsung terlihat di hasil prototipe.
class FaceEmbedder {
  static const modelAsset = 'assets/models/mobilefacenet.tflite';

  final Interpreter _interpreter;
  final int inputSize;
  final int embeddingLength;

  FaceEmbedder._(this._interpreter, this.inputSize, this.embeddingLength);

  static Future<FaceEmbedder> load({int threads = 2}) async {
    final interpreter = await Interpreter.fromAsset(
      modelAsset,
      options: InterpreterOptions()..threads = threads,
    );
    final input = interpreter.getInputTensor(0).shape; // [1, 112, 112, 3]
    final output = interpreter.getOutputTensor(0).shape; // [1, panjang]
    if (input.length != 4 || input.first != 1 || output.length != 2) {
      interpreter.close();
      throw StateError(
        'Bentuk model tidak didukung: input $input, output $output.',
      );
    }
    return FaceEmbedder._(interpreter, input[1], output[1]);
  }

  /// Embedding yang sudah dinormalisasi (panjang vektor = 1).
  List<double> embed(Float32List input) {
    final output = [List<double>.filled(embeddingLength, 0)];
    _interpreter.run(input.reshape([1, inputSize, inputSize, 3]), output);
    return l2Normalize(output.first);
  }

  void close() => _interpreter.close();
}
