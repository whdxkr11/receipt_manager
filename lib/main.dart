import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart'; // 경로 찾기용
import 'dart:io';

import 'db_helper.dart';
import 'calendar_page.dart';

void main() {
  runApp(const ReceiptApp());
}

class ReceiptApp extends StatelessWidget {
  const ReceiptApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '스마트 영수증',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  XFile? _imageFile;
  String _scannedText = "영수증을 찍으면 자동으로 금액을 찾습니다.";
  
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  // 1. 카메라 실행
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile;
        _scannedText = "분석 중...";
      });
      _recognizeText(pickedFile);
    }
  }

  // 2. OCR + 금액 자동 추출 로직
  Future<void> _recognizeText(XFile image) async {
    final inputImage = InputImage.fromFilePath(image.path);
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.korean);

    try {
      final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
      String fullText = recognizedText.text;

      // === 금액 자동 추출 알고리즘 ===
      String detectedAmount = "";
      
      // 줄 단위로 분석해서 '합계', '결제', 'Total' 같은 단어가 있는 줄을 찾음
      List<String> lines = fullText.split('\n');
      for (String line in lines) {
        if (line.contains('합계') || line.contains('결제') || line.contains('총액') || line.contains('Total')) {
          // 그 줄에서 숫자만 뽑아냄 (예: "합계 15,000원" -> "15000")
          String numbers = line.replaceAll(RegExp(r'[^0-9]'), '');
          if (numbers.isNotEmpty) {
            detectedAmount = numbers;
            break; // 찾으면 중단
          }
        }
      }
      
      // 만약 못 찾았으면 전체 텍스트에서 가장 큰 숫자를 찾거나 비워둠 (여기선 단순하게 처리)

      setState(() {
        _scannedText = fullText;
        _amountController.text = detectedAmount; // 찾은 금액 자동 입력!
        _titleController.text = ""; // 상점명은 비워둠 (사용자가 입력)
      });

      _showSaveDialog(image); // 저장 팝업 띄우기 (이미지 파일도 같이 넘김)

    } catch (e) {
      setState(() {
        _scannedText = "오류 발생: $e";
      });
    } finally {
      textRecognizer.close();
    }
  }

  // 3. 이미지 영구 저장 함수
  Future<String> _saveImagePermanently(XFile image) async {
    final directory = await getApplicationDocumentsDirectory();
    final String path = directory.path;
    final String fileName = 'receipt_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final File newImage = await File(image.path).copy('$path/$fileName');
    return newImage.path;
  }

  // 4. 저장 팝업
  void _showSaveDialog(XFile image) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("영수증 확인"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 썸네일 보여주기
              SizedBox(
                height: 100,
                child: Image.file(File(image.path)),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: "상점명", 
                  hintText: "예: 스타벅스"
                ),
              ),
              TextField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: "금액 (자동인식)",
                  hintText: "금액이 틀리면 수정하세요"
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("취소"),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_titleController.text.isNotEmpty && _amountController.text.isNotEmpty) {
                  final String title = _titleController.text;
                  final int amount = int.parse(_amountController.text.replaceAll(',', ''));
                  final String date = DateFormat('yyyy-MM-dd').format(DateTime.now());

                  // 1. 중복 체크 먼저 실행
                  bool isDuplicate = await DBHelper().checkDuplicate(title, amount, date);

                  if (isDuplicate) {
                    // 2. 중복이면 경고창 띄우기 (context가 살아있어야 해서 mounted 체크)
                    if (context.mounted) {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text("⚠️ 중복 경고"),
                          content: const Text("이 영수증은 오늘 이미 저장하신 것 같아요.\n그래도 또 저장할까요?"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx), // 경고창 닫기 (저장 안 함)
                              child: const Text("아니요 (취소)"),
                            ),
                            TextButton(
                              onPressed: () async {
                                Navigator.pop(ctx); // 경고창 닫고
                                await _saveProcess(image, title, amount, date); // 강제 저장 진행
                              },
                              child: const Text("네 (저장)"),
                            ),
                          ],
                        ),
                      );
                    }
                  } else {
                    // 3. 중복 아니면 바로 저장
                    await _saveProcess(image, title, amount, date);
                  }
                }
              },
              child: const Text("저장하기"),
            ),
          ],
        );
      },
    );
  }

  // 실제 저장 동작을 수행하는 함수 (중복 코드를 줄이기 위해 분리)
  Future<void> _saveProcess(XFile image, String title, int amount, String date) async {
    // 1. 이미지 영구 저장
    String savedPath = await _saveImagePermanently(image);

    // 2. DB 저장
    await DBHelper().insertReceipt(Receipt(
      title: title,
      amount: amount,
      date: date,
      imagePath: savedPath,
    ));

    // 3. 팝업 닫기 및 안내 메시지
    if (mounted) {
      Navigator.pop(context); // 입력창 닫기
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('저장 완료! 달력에서 확인하세요.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('스마트 영수증 V2')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.receipt_long, size: 100, color: Colors.blue),
            const SizedBox(height: 20),
            const Text("영수증을 찍으면 자동으로\n금액을 입력해 드려요!", textAlign: TextAlign.center),
            const SizedBox(height: 40),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.camera_alt),
                  label: const Text("영수증 찍기"),
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(15)),
                ),
                const SizedBox(width: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CalendarPage()),
                    );
                  },
                  icon: const Icon(Icons.calendar_month),
                  label: const Text("달력 보기"),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(15),
                    backgroundColor: Colors.green, 
                    foregroundColor: Colors.white
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}