import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ImagePicker _picker = ImagePicker(); // ImagePicker 객체
  List<Uint8List> _imageList = []; // 이미지 목록을 저장하는 리스트
  int _currentPage = 0; // 현재 페이지 인덱스
  Timer? _timer; // 이미지를 자동으로 슬라이드하기 위한 타이머

  final pageController = PageController(); // 페이지 컨트롤러

  @override
  void initState() {
    super.initState();
    loadImages(); // 이미지 로드 함수 호출
  }

  @override
  void dispose() {
    _timer?.cancel(); // _timer가 null이 아닌 경우에만 취소
    super.dispose();
  }

  /// 이미지를 로드하는 메서드
  Future<void> loadImages() async {
    try {
      // 갤러리에서 이미지 선택
      List<XFile>? pickedFiles = await _picker.pickMultiImage();

      if (pickedFiles != null) {
        // 파일을 바이트 배열로 변환
        List<Uint8List> imageBytesList = await _convertFilesToBytes(pickedFiles);

        // 메서드를 호출하여 상태를 업데이트
        setState(() {
          _imageList = imageBytesList;
          _currentPage = 0;
        });

        // 이미지를 자동으로 슬라이드하기 위한 타이머를 시작
        startTimer();
      }
    } catch (e) {
      // 이미지 로드 중 오류 발생
      print('이미지 로드 중 오류가 발생: $e');
    }
  }

  /// 파일들을 바이트 배열로 변환하는 메서드
  Future<List<Uint8List>> _convertFilesToBytes(List<XFile> files) async {
    List<Uint8List> imageBytesList = [];
    for (XFile file in files) {
      try {
        // 파일을 바이트 배열로 읽어옴
        final bytes = await file.readAsBytes();
        imageBytesList.add(bytes);
      } catch (e) {
        // 예외 처리: 파일을 읽어오는 중 오류 발생
        print('파일을 읽어오는 중 오류가 발생: $e');
      }
    }
    return imageBytesList;
  }


  /// 슬라이드 타이머 설정
  void startTimer() {
    // 3초마다 타이머가 실행되도록 설정
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      _currentPage = (_currentPage + 1) %
          _imageList.length; // 현재 페이지 인덱스를 증가하고, 범위를 체크하여 처음으로 돌아감

      // 페이지 전환 애니메이션 및  소요 시간 설정
      pageController.animateToPage(_currentPage,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeIn); // 페이지 컨트롤러를 사용하여 페이지 전환 애니메이션 수행
    });
  }


  /// 이미지가 있는 경우
  Widget imageWithPhotoWidget() {
    return PageView(
      controller: pageController,
      children: _imageList
          .map((image) => Image.memory(image, width: double.infinity))
          .toList(), // 이미지 목록을 이용하여 페이지뷰의 자식 위젯들 생성
    );
  }

  /// 이미지가 없는 경우
  Widget imageWithoutPhotoWidget() {
    return const Center(
      child: Text(
        '이미지가 없습니다.',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // 디버그 레이블 제거
      home: Scaffold(
        appBar: AppBar(title: const Text("전자액자")),
        body: _imageList.isNotEmpty
            ? imageWithPhotoWidget() // 이미지가 있는 경우 이미지 목록을 표시하는 위젯 호출
            : imageWithoutPhotoWidget(), // 이미지가 없는 경우 이미지 없음을 표시하는 위젯 호출
      ),
    );
  }
}
