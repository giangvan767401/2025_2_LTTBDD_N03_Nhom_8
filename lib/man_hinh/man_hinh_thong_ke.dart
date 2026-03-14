import 'package:flutter/material.dart';
import 'man_hinh_dong_ho.dart'; 
import '../models/phien_pomodoro.dart'; 

class ManHinhThongKe extends StatelessWidget {
  final List<PhienPomodoro> danhSachPhien;

  const ManHinhThongKe({super.key, required this.danhSachPhien});

  @override
  Widget build(BuildContext context) {
    // Lọc phiên hôm nay
    final DateTime homNay = DateTime.now();
    final List<PhienPomodoro> phienHomNay = danhSachPhien.where((phien) {
      return phien.thoiGianHoanThanh.year == homNay.year &&
             phien.thoiGianHoanThanh.month == homNay.month &&
             phien.thoiGianHoanThanh.day == homNay.day;
    }).toList();

    int soPhienHomNay = phienHomNay.length;
    int tongPhutHomNay = phienHomNay.fold(0, (sum, phien) => sum + phien.thoiLuongPhut);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Thống kê'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blueGrey, Colors.blueGrey.shade700],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.bar_chart_rounded,
                  size: 100,
                  color: Colors.white70,
                ),
                const SizedBox(height: 32),
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  color: Colors.white.withOpacity(0.15),
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      children: [
                        Text(
                          'Hôm nay',
                          style: TextStyle(
                            fontSize: 36,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          '$soPhienHomNay phiên',
                          style: const TextStyle(
                            fontSize: 48,
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Tổng thời gian: $tongPhutHomNay phút',
                          style: const TextStyle(
                            fontSize: 24,
color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 48),
                Text(
                  'Chúc mừng bạn đã tập trung hôm nay!',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white70,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}