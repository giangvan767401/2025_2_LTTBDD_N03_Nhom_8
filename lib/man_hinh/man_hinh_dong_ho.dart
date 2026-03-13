import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart'; // Thêm import cho âm thanh
import 'package:vibration/vibration.dart'; // Thêm import cho rung

class ManHinhDongHo extends StatefulWidget {
  const ManHinhDongHo({super.key});

  @override
  State<ManHinhDongHo> createState() => _ManHinhDongHoState();
}

class _ManHinhDongHoState extends State<ManHinhDongHo> {
  int giayConLai = 25 * 60; // Ban đầu 25 phút
  int tongGiayBanDau = 25 * 60;
  bool dangChay = false;
  bool laPhienTapTrung = true;
  Timer? _timer;

  final AudioPlayer _audioPlayer = AudioPlayer(); // Khởi tạo player âm thanh

  final TextEditingController _gioController = TextEditingController(
    text: '00',
  );
  final TextEditingController _phutController = TextEditingController(
    text: '25',
  );
  final TextEditingController _giayController = TextEditingController(
    text: '00',
  );

  @override
  void dispose() {
    _timer?.cancel();
    _audioPlayer.dispose();
    _gioController.dispose();
    _phutController.dispose();
    _giayController.dispose();
    super.dispose();
  }

  String layChuoiThoiGian() {
    int tongGiay = giayConLai;
    int gio = tongGiay ~/ 3600;
    int phut = (tongGiay % 3600) ~/ 60;
    int giay = tongGiay % 60;
    return '${gio.toString().padLeft(2, '0')}:${phut.toString().padLeft(2, '0')}:${giay.toString().padLeft(2, '0')}';
  }

  double layGiaTriTienDo() {
    if (tongGiayBanDau == 0) return 0.0;
    return 1.0 - (giayConLai / tongGiayBanDau);
  }

  List<Color> layMauGradient() {
    if (dangChay) {
      return laPhienTapTrung
          ? [Colors.red[900]!, Colors.red[600]!]
          : [Colors.green[900]!, Colors.green[600]!];
    }
    return [Colors.blueGrey[900]!, Colors.blueGrey[700]!];
  }

  String layTrangThai() {
    if (dangChay) {
      return laPhienTapTrung ? 'Đang tập trung' : 'Đang nghỉ ngơi';
    }
    return 'Sẵn sàng bắt đầu';
  }

  void batDauHoacTamDung() {
    setState(() {
      dangChay = !dangChay;
    });

    if (dangChay) {
      tongGiayBanDau = giayConLai;

      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          if (giayConLai > 0) {
            giayConLai--;
          } else {
            timer.cancel();
            dangChay = false;
            laPhienTapTrung = !laPhienTapTrung;

            // Phát âm thanh + rung khi hết giờ
            _phatAmThanhVaRung();

            // Tùy chọn: tự động set thời gian mới (bỏ comment nếu muốn)
            // giayConLai = laPhienTapTrung ? 25 * 60 : 5 * 60;
            // tongGiayBanDau = giayConLai;
          }
        });
      });
    } else {
      _timer?.cancel();
    }
  }

  Future<void> _phatAmThanhVaRung() async {
    try {
      // Phát âm thanh từ assets (đường dẫn phải khớp với pubspec.yaml)
      await _audioPlayer.play(AssetSource('sounds/notification.mp3'));

      // Rung điện thoại nếu thiết bị hỗ trợ
      if (await Vibration.hasVibrator() ?? false) {
        Vibration.vibrate(
          pattern: [0, 500, 200, 500], // rung 500ms - nghỉ 200ms - rung 500ms
          intensities: [128, 0, 128], // độ mạnh rung (0-255)
        );
      }
    } catch (e) {
      debugPrint('Lỗi phát âm thanh hoặc rung: $e');
    }
  }

  void _moHopThoaiNhapThoiGian() {
    int gioHienTai = giayConLai ~/ 3600;
    int phutHienTai = (giayConLai % 3600) ~/ 60;
    int giayHienTai = giayConLai % 60;

    _gioController.text = gioHienTai.toString().padLeft(2, '0');
    _phutController.text = phutHienTai.toString().padLeft(2, '0');
    _giayController.text = giayHienTai.toString().padLeft(2, '0');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Nhập thời gian mong muốn'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 60,
                    child: TextField(
                      controller: _gioController,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 2,
                      decoration: const InputDecoration(
                        hintText: 'Giờ',
                        counterText: '',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const Text(':', style: TextStyle(fontSize: 24)),
                  SizedBox(
                    width: 60,
                    child: TextField(
                      controller: _phutController,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 2,
                      decoration: const InputDecoration(
                        hintText: 'Phút',
                        counterText: '',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const Text(':', style: TextStyle(fontSize: 24)),
                  SizedBox(
                    width: 60,
                    child: TextField(
                      controller: _giayController,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 2,
                      decoration: const InputDecoration(
                        hintText: 'Giây',
                        counterText: '',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                int gio = int.tryParse(_gioController.text) ?? 0;
                int phut = int.tryParse(_phutController.text) ?? 0;
                int giay = int.tryParse(_giayController.text) ?? 0;

                if (gio > 9) gio = 9;
                if (phut > 59) phut = 59;
                if (giay > 59) giay = 59;

                int tongGiayMoi = gio * 3600 + phut * 60 + giay;

                setState(() {
                  giayConLai = tongGiayMoi > 0 ? tongGiayMoi : 60;
                  dangChay = false;
                  tongGiayBanDau = giayConLai;
                });

                _timer?.cancel();
                Navigator.pop(context);
              },
              child: const Text('Xác nhận'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: layMauGradient(),
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  laPhienTapTrung
                      ? Icons.center_focus_strong_rounded
                      : Icons.coffee_rounded,
                  size: 50,
                  color: Colors.white.withOpacity(0.85),
                ),
                const SizedBox(height: 16),

                GestureDetector(
                  onTap: _moHopThoaiNhapThoiGian,
                  child: SizedBox(
                    width: 320,
                    height: 320,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 300,
                          height: 300,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.35),
                                blurRadius: 25,
                                offset: const Offset(8, 8),
                              ),
                              BoxShadow(
                                color: Colors.white.withOpacity(0.12),
                                blurRadius: 25,
                                offset: const Offset(-8, -8),
                              ),
                            ],
                          ),
                        ),
                        CircularProgressIndicator(
                          value: layGiaTriTienDo(),
                          strokeWidth: 28,
                          backgroundColor: Colors.white.withOpacity(0.18),
                          color: Colors.white,
                        ),
                        Text(
                          layChuoiThoiGian(),
                          style: const TextStyle(
                            fontSize: 64,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: 3,
                            shadows: [
                              Shadow(
                                blurRadius: 12,
                                color: Colors.black54,
                                offset: Offset(3, 3),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 48),

                AnimatedOpacity(
                  opacity: 1.0,
                  duration: const Duration(milliseconds: 600),
                  child: Text(
                    layTrangThai(),
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.white.withOpacity(0.92),
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),

                const SizedBox(height: 80),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: batDauHoacTamDung,
                      icon: Icon(
                        dangChay
                            ? Icons.pause_rounded
                            : Icons.play_arrow_rounded,
                        size: 40,
                      ),
                      label: Text(
                        dangChay ? 'Tạm dừng' : 'Bắt đầu',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 50,
                          vertical: 22,
                        ),
                        backgroundColor: Colors.white,
                        foregroundColor: dangChay
                            ? Colors.red[700]
                            : Colors.green[700],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        elevation: 10,
                        shadowColor: dangChay
                            ? Colors.red.withOpacity(0.5)
                            : Colors.green.withOpacity(0.5),
                      ),
                    ),
                    const SizedBox(width: 32),
                    OutlinedButton.icon(
                      onPressed: () {
                        setState(() {
                          giayConLai = 0;
                          dangChay = false;
                          laPhienTapTrung = true;
                          tongGiayBanDau = 0;
                        });
                        _timer?.cancel();
                      },
                      icon: const Icon(Icons.refresh_rounded, size: 36),
                      label: const Text(
                        'Đặt lại',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 22,
                        ),
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white, width: 2.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black.withOpacity(0.4),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        selectedFontSize: 14,
        unselectedFontSize: 12,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.timer), label: 'Đồng hồ'),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Thống kê',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'Thông tin nhóm',
          ),
        ],
        currentIndex: 0,
        onTap: (index) {},
      ),
    );
  }
}
