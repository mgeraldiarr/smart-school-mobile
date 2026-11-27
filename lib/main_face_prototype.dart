import 'package:flutter/material.dart';

import 'features/face_recognition/prototype/face_prototype_screen.dart';

/// Entry point khusus uji teknis pengenalan wajah, terpisah dari aplikasi utama.
///
///   flutter run -t lib/main_face_prototype.dart
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const MaterialApp(
      title: 'Prototipe Wajah',
      debugShowCheckedModeBanner: false,
      home: FacePrototypeScreen(),
    ),
  );
}
