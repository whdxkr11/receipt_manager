import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'dart:io'; // 파일 이미지 보여주기용
import 'db_helper.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<String, List<Receipt>> _events = {};

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _loadAllData();
  }

  Future<void> _loadAllData() async {
    final data = await DBHelper().getAllReceipts();
    Map<String, List<Receipt>> newEvents = {};
    for (var receipt in data) {
      if (newEvents[receipt.date] == null) newEvents[receipt.date] = [];
      newEvents[receipt.date]!.add(receipt);
    }
    setState(() {
      _events = newEvents;
    });
  }

  List<Receipt> _getReceiptsForDay(DateTime day) {
    String dateStr = DateFormat('yyyy-MM-dd').format(day);
    return _events[dateStr] ?? [];
  }

  int _getTotalAmountForDay(DateTime day) {
    var list = _getReceiptsForDay(day);
    int total = 0;
    for (var r in list) total += r.amount;
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('가계부 달력')),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, events) {
                int total = _getTotalAmountForDay(date);
                if (total == 0) return null;
                return Positioned(
                  bottom: 1,
                  child: Text(
                    NumberFormat('#,###').format(total),
                    style: const TextStyle(fontSize: 10, color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                );
              },
            ),
          ),
          const Divider(thickness: 2),
          Expanded(
            child: _selectedDay == null
                ? const Center(child: Text("날짜를 선택해주세요"))
                : ListView.builder(
                    itemCount: _getReceiptsForDay(_selectedDay!).length,
                    itemBuilder: (context, index) {
                      final receipt = _getReceiptsForDay(_selectedDay!)[index];
                      return ListTile(
                        leading: receipt.imagePath != null
                            ? Image.file(File(receipt.imagePath!), width: 50, height: 50, fit: BoxFit.cover)
                            : const Icon(Icons.receipt),
                        title: Text(receipt.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                        trailing: Text("${NumberFormat('#,###').format(receipt.amount)}원"),
                        
                        // 클릭하면 상세 화면으로 이동
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ReceiptDetailPage(receipt: receipt),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// === 상세 보기 화면 (이미지 크게 보기) ===
class ReceiptDetailPage extends StatelessWidget {
  final Receipt receipt;

  const ReceiptDetailPage({super.key, required this.receipt});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("영수증 상세")),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (receipt.imagePath != null)
              Image.file(File(receipt.imagePath!), fit: BoxFit.contain)
            else
              const SizedBox(height: 200, child: Center(child: Text("이미지 없음"))),
            
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Text(receipt.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text("${NumberFormat('#,###').format(receipt.amount)}원", style: const TextStyle(fontSize: 20, color: Colors.red)),
                  const SizedBox(height: 10),
                  Text("날짜: ${receipt.date}", style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}