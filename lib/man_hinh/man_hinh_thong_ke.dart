import 'package:flutter/material.dart';
import 'man_hinh_dong_ho.dart'; 
import '../models/phien_pomodoro.dart'; 
import 'package:provider/provider.dart';
import '../quan_ly_ngon_ngu.dart';
import '../chuoi_van_ban.dart';


Map<int, int> layDuLieu7Ngay(List<PhienPomodoro> danhSachPhien) {
  final DateTime homNay = DateTime.now();
  final DateTime dauTuan = homNay.subtract(Duration(days: homNay.weekday - 1));

  final Map<int, int> ketQua = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0, 6: 0, 7: 0};

  for (final phien in danhSachPhien) {
    final ngay = phien.thoiGianHoanThanh;
    if (ngay.isAfter(dauTuan.subtract(const Duration(seconds: 1))) &&
        ngay.isBefore(dauTuan.add(const Duration(days: 7)))) {
      final thu = ngay.weekday; // 1=T2, 7=CN
      ketQua[thu] = (ketQua[thu] ?? 0) + 1;
    }
  }
  return ketQua;
}


class BieuDoThanh extends StatefulWidget {
  final Map<int, int> duLieu7Ngay;

  const BieuDoThanh({super.key, required this.duLieu7Ngay});

  @override
  State<BieuDoThanh> createState() => _BieuDoThanhState();
}

class _BieuDoThanhState extends State<BieuDoThanh>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  static const List<String> _tenThu = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final int maxPhien = widget.duLieu7Ngay.values.fold(0, (a, b) => a > b ? a : b);
    final int hienThi = maxPhien < 1 ? 1 : maxPhien;
    final int thuHomNay = DateTime.now().weekday;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        return SizedBox(
          height: 180,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(7, (i) {
              final int thu = i + 1;
              final int soPhien = widget.duLieu7Ngay[thu] ?? 0;
              final double tyLe = (soPhien / hienThi) * _animation.value;
              final bool laHomNay = thu == thuHomNay;

              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (soPhien > 0)
                        Text(
                          '$soPhien',
                          style: TextStyle(
                            fontSize: 11,
                            color: laHomNay ? const Color(0xFF80FF80) : Colors.white70,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      const SizedBox(height: 2),
                      Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          Container(
                            height: 140,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          Container(
                            height: 140 * tyLe.clamp(0.0, 1.0),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: laHomNay
                                    ? [const Color(0xFF80FF80), const Color(0xFF00BFFF)]
                                    : [const Color(0xFF9D50FF), const Color(0xFFE040FB)],
                              ),
                              borderRadius: BorderRadius.circular(6),
                              boxShadow: laHomNay
                                  ? [BoxShadow(color: const Color(0xFF80FF80).withOpacity(0.4), blurRadius: 8)]
                                  : [],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _tenThu[i],
                        style: TextStyle(
                          fontSize: 11,
                          color: laHomNay ? const Color(0xFF80FF80) : Colors.white54,
                          fontWeight: laHomNay ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }
}


class ManHinhThongKe extends StatelessWidget {
  final List<PhienPomodoro> danhSachPhien;

  const ManHinhThongKe({super.key, required this.danhSachPhien});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<QuanLyNgonNgu>().ngonNgu;
    final strings = chuoiVanBan[lang]!;

    final DateTime homNay = DateTime.now();
    final List<PhienPomodoro> phienHomNay = danhSachPhien.where((phien) {
      return phien.thoiGianHoanThanh.year == homNay.year &&
             phien.thoiGianHoanThanh.month == homNay.month &&
             phien.thoiGianHoanThanh.day == homNay.day;
    }).toList();

    final int soPhienHomNay = phienHomNay.length;
    final int tongPhutHomNay = phienHomNay.fold(0, (sum, p) => sum + (p.thoiLuongGiay ~/ 60));
    final int tongPhutTatCa = danhSachPhien.fold(0, (sum, p) => sum + (p.thoiLuongGiay ~/ 60));

    final Map<int, int> duLieu7Ngay = layDuLieu7Ngay(danhSachPhien);

    return Scaffold(
      backgroundColor: Colors.transparent, 
      appBar: AppBar(
        title: Text(strings['thongKe']!, style: const TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: const Color(0xFF120326),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SizedBox.expand(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF120326), Color(0xFF3C096C)],
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.12)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.bar_chart_rounded, color: Color(0xFF80FF80), size: 20),
                            const SizedBox(width: 8),
                            const Text(
                              'Tuần này',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              '${duLieu7Ngay.values.fold(0, (a, b) => a + b)} phiên',
                              style: const TextStyle(fontSize: 13, color: Colors.white54),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        BieuDoThanh(duLieu7Ngay: duLieu7Ngay),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFF80FF80).withOpacity(0.3)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Hôm nay', style: TextStyle(fontSize: 13, color: Colors.white60)),
                              const SizedBox(height: 6),
                              Text(
                                '$soPhienHomNay',
                                style: const TextStyle(fontSize: 36, color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '${strings['phien']}',
                                style: const TextStyle(fontSize: 13, color: Colors.white60),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '$tongPhutHomNay phút',
                                style: const TextStyle(fontSize: 13, color: Color(0xFF80FF80)),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFE040FB).withOpacity(0.3)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Tất cả', style: TextStyle(fontSize: 13, color: Colors.white60)),
                              const SizedBox(height: 6),
                              Text(
                                '${danhSachPhien.length}',
                                style: const TextStyle(fontSize: 36, color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '${strings['phien']}',
                                style: const TextStyle(fontSize: 13, color: Colors.white60),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '$tongPhutTatCa phút',
                                style: const TextStyle(fontSize: 13, color: Color(0xFFE040FB)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  Center(
                    child: Text(
                      strings['chucMung']!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white54,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

