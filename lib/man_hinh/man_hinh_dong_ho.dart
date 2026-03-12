import 'package:flutter/material.dart';

class ManHinhDongHo extends StatefulWidget {
  const ManHinhDongHo({super.key});

  @override
  State<ManHinhDongHo> createState() => _ManHinhDongHoState();
}

class _ManHinhDongHoState extends State<ManHinhDongHo> {
  int giayConLai = 25 * 60;
  bool dangChay = false;
  bool laPhienTapTrung = true;

  String layChuoiThoiGian() {
    int phut = giayConLai ~/ 60;
    int giay = giayConLai % 60;
    return '${phut.toString().padLeft(2, '0')}:${giay.toString().padLeft(2, '0')}';
  }

  Color layMauNen() {
    if (dangChay) {
      return laPhienTapTrung ? Colors.red[800]! : Colors.green[800]!;
    }
    return Colors.blueGrey[900]!;
  }

  String layTrangThai() {
    if (dangChay) {
      return laPhienTapTrung ? 'Đang tập trung' : 'Đang nghỉ ngơi';
    }
    return 'Sẵn sàng bắt đầu';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: layMauNen(),
      appBar: AppBar(
        title: const Text('Đồng hồ Pomodoro'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 280,
                height: 280,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: 0.0,
                      strokeWidth: 24,
                      backgroundColor: Colors.white.withOpacity(0.2),
                      color: Colors.white,
                    ),
                    Text(
                      layChuoiThoiGian(),
                      style: const TextStyle(
                        fontSize: 72,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 4,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              Text(
                layTrangThai(),
                style: TextStyle(
                  fontSize: 28,
                  color: Colors.white.withOpacity(0.9),
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 80),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        dangChay = !dangChay;
                      });
                    },
                    icon: Icon(
                      dangChay ? Icons.pause_rounded : Icons.play_arrow_rounded,
                      size: 32,
                    ),
                    label: Text(
                      dangChay ? 'Tạm dừng' : 'Bắt đầu',
                      style: const TextStyle(fontSize: 20),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 18,
                      ),
                      backgroundColor: Colors.white,
                      foregroundColor: dangChay
                          ? Colors.red[800]
                          : Colors.green[800],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 6,
                    ),
                  ),

                  const SizedBox(width: 24),

                  OutlinedButton.icon(
                    onPressed: () {
                      setState(() {
                        giayConLai = 25 * 60;
                        dangChay = false;
                        laPhienTapTrung = true;
                      });
                    },
                    icon: const Icon(Icons.refresh_rounded, size: 28),
                    label: const Text(
                      'Đặt lại',
                      style: TextStyle(fontSize: 18),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 18,
                      ),
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white, width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
