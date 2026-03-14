import 'package:flutter/material.dart';
import 'man_hinh_dong_ho.dart'; 
import '../models/phien_pomodoro.dart'; 

class ManHinhThongKe extends StatelessWidget {
  final List<PhienPomodoro> danhSachPhien;

  const ManHinhThongKe({super.key, required this.danhSachPhien});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thống kê'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'Màn hình thống kê Pomodoro',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}