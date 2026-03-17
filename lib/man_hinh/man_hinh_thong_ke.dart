import 'package:flutter/material.dart';
import 'man_hinh_dong_ho.dart'; 
import '../models/phien_pomodoro.dart'; 
import 'package:provider/provider.dart';
import '../quan_ly_ngon_ngu.dart';
import '../chuoi_van_ban.dart';

class ManHinhThongKe extends StatelessWidget {
  final List<PhienPomodoro> danhSachPhien;

  const ManHinhThongKe({super.key, required this.danhSachPhien});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<QuanLyNgonNgu>().ngonNgu;
    final strings = chuoiVanBan[lang]!;

    // Lọc phiên hôm nay
    final DateTime homNay = DateTime.now();
    final List<PhienPomodoro> phienHomNay = danhSachPhien.where((phien) {
      return phien.thoiGianHoanThanh.year == homNay.year &&
             phien.thoiGianHoanThanh.month == homNay.month &&
             phien.thoiGianHoanThanh.day == homNay.day;
    }).toList();

    int soPhienHomNay = phienHomNay.length;
    int tongPhutHomNay = phienHomNay.fold(0, (sum, phien) => sum + (phien.thoiLuongGiay ~/ 60));

    return Scaffold(
      appBar: AppBar(
        title: Text(strings['thongKe']!, style: const TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: const Color(0xFF120326),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF120326), Color(0xFF3C096C)],
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
                          strings['homNay']!,
                          style: const TextStyle(fontSize: 24, color: Colors.white70),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '$soPhienHomNay ${strings['phien']}',
                          style: const TextStyle(fontSize: 40, color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${strings['thoiGian']}: $tongPhutHomNay ${strings['phutDonVi']}',
                          style: const TextStyle(fontSize: 16, color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Card Tổng cộng
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  color: Colors.white.withOpacity(0.1),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    child: Column(
                      children: [
                        Text(
                          strings['tatCaThoiGian']!,
                          style: const TextStyle(fontSize: 18, color: Colors.white70),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${danhSachPhien.length} ${strings['phien']} | ${danhSachPhien.fold(0, (sum, p) => sum + (p.thoiLuongGiay ~/ 60))} ${strings['phutDonVi']}',
                          style: const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  strings['chucMung']!,
                  style: const TextStyle(
                    fontSize: 16,
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