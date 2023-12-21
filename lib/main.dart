import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'main_screen.dart';

void main() {
  runApp(const MyGalleryApp());
}

class MyGalleryApp extends StatefulWidget {
  const MyGalleryApp({super.key});

  @override
  State<MyGalleryApp> createState() => _MyGalleryAppState();
}

class _MyGalleryAppState extends State<MyGalleryApp> {
  final ImagePicker _picker = ImagePicker();
  List<XFile>? images;

  @override
  void initState() {
    super.initState();
    loadImages();
  }

  Future<void> loadImages() async {
    // 여러장 가져오는 메소드
    images = await _picker.pickMultiImage();

    setState(() {
      //
    });

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '전자액자',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}
