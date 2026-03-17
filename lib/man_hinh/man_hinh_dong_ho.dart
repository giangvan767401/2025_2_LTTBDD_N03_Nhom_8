import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:vibration/vibration.dart';
import '../models/phien_pomodoro.dart'; 
import 'man_hinh_thong_ke.dart';
import 'man_hinh_cai_dat.dart';
import 'man_hinh_bo_suu_tap_cay.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ManHinhDongHo extends StatefulWidget {
  const ManHinhDongHo({super.key});

  @override
  State<ManHinhDongHo> createState() => _ManHinhDongHoState();
}

class _ManHinhDongHoState extends State<ManHinhDongHo> {

  static const List<Map<String, dynamic>> dsNguongMoKhoa = [
    {'anh': 'assets/images/tree1.jpg', 'phutCanDat': 0},     
    {'anh': 'assets/images/tree2.jpg', 'phutCanDat': 25},    
    {'anh': 'assets/images/tree3.jpg', 'phutCanDat': 60},    
    {'anh': 'assets/images/tree4.jpg', 'phutCanDat': 120},   
    {'anh': 'assets/images/tree5.jpg', 'phutCanDat': 240},   
    {'anh': 'assets/images/tree6.jpg', 'phutCanDat': 480},   
    {'anh': 'assets/images/tree7.jpg', 'phutCanDat': 960},   
    {'anh': 'assets/images/tree8.jpg', 'phutCanDat': 1440},  
  ];
  int giayConLai = 25 * 60; 
  int tongGiayBanDau = 25 * 60;
  bool dangChay = false;
  bool laPhienTapTrung = true;
  Timer? _timer;

  List<PhienPomodoro> danhSachPhien = [];
  int soPhienDaHoc = 0;
  int tongPhutTichLuy = 0; 
  String _anhCayHienTai = 'assets/images/tree1.jpg'; 

  int _thoiGianTapTrungPhut = 25;
  int _thoiGianNghiNganPhut = 5;
  int _thoiGianNghiDaiPhut = 15;
  int _chuKyNghiDai = 4;

  final AudioPlayer _audioPlayer = AudioPlayer();

  final TextEditingController _gioController = TextEditingController(text: '00');
  final TextEditingController _phutController = TextEditingController(text: '25');
  final TextEditingController _giayController = TextEditingController(text: '00');

  @override
  void initState() {
    super.initState();
    _taiCaiDat().then((_) {
      _capNhatThoiGianHienTai();
    });
  }

  Future<void> _taiCaiDat() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _thoiGianTapTrungPhut = prefs.getInt('thoiGianTapTrungPhut') ?? 25;
      _thoiGianNghiNganPhut = prefs.getInt('thoiGianNghiNganPhut') ?? 5;
      _thoiGianNghiDaiPhut = prefs.getInt('thoiGianNghiDaiPhut') ?? 15;
      _chuKyNghiDai = prefs.getInt('chuKyNghiDai') ?? 4;
      
      soPhienDaHoc = prefs.getInt('soPhienDaHoc') ?? 0;
      tongPhutTichLuy = prefs.getInt('tongPhutTichLuy') ?? 0;
      _anhCayHienTai = prefs.getString('anhCayHienTai') ?? 'assets/images/tree1.jpg';
    });
  }
  
  void _capNhatThoiGianHienTai() {
    if (!dangChay) {
        setState(() {
           if (laPhienTapTrung) {
             giayConLai = _thoiGianTapTrungPhut * 60;
           } else {
             if (soPhienDaHoc > 0 && soPhienDaHoc % _chuKyNghiDai == 0) {
               giayConLai = _thoiGianNghiDaiPhut * 60;
             } else {
               giayConLai = _thoiGianNghiNganPhut * 60;
             }
           }
           tongGiayBanDau = giayConLai;
        });
    }
  }

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
          ? [const Color(0xFF120326), const Color(0xFF3C096C)] 
          : [const Color(0xFF0A0118), const Color(0xFF1B0B3B)]; 
    }
    return [const Color(0xFF05010D), const Color(0xFF0D0221)]; 
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

              if (laPhienTapTrung) {
                soPhienDaHoc++;
                int phutHoanThanh = tongGiayBanDau ~/ 60;
                tongPhutTichLuy += phutHoanThanh;
                
                danhSachPhien.add(PhienPomodoro(
                  thoiGianHoanThanh: DateTime.now(),
                  thoiLuongPhut: phutHoanThanh, 
                ));

                _luuTienDoTichLuy();
              }

              laPhienTapTrung = !laPhienTapTrung;
              _capNhatThoiGianHienTai();

              _phatAmThanhVaRung();
          }
        });
      });
    } else {
      _timer?.cancel();
    }
  }

  // Hàm lưu dữ liệu tích lũy vào máy
  Future<void> _luuTienDoTichLuy() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('soPhienDaHoc', soPhienDaHoc);
    await prefs.setInt('tongPhutTichLuy', tongPhutTichLuy);
  }

  Future<void> _phatAmThanhVaRung() async {
    try {
      await _audioPlayer.play(AssetSource('sounds/notification.mp3'));

      if (await Vibration.hasVibrator() ?? false) {
        Vibration.vibrate(
          pattern: [0, 500, 200, 500],
          intensities: [128, 0, 128],
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
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: layMauGradient(),
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16, top: 8),
                    child: TextButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ManHinhBoSuuTapCay(
                              tongPhutTichLuy: tongPhutTichLuy,
                              anhCayDangDung: _anhCayHienTai,
                            ),
                          ),
                        ).then((newPath) {
                          if (newPath != null) {
                            setState(() {
                              _anhCayHienTai = newPath;
                            });
                          }
                        });
                      },
                      icon: const Icon(Icons.park_rounded, color: Color(0xFF80FF80)),
                      label: const Text('Cây', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.1),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 20), 

                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: _moHopThoaiNhapThoiGian,
                      child: SizedBox(
                        width: 260,
                        height: 260,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 260,
                              height: 260,
                              child: CircularProgressIndicator(
                                value: 1.0 - layGiaTriTienDo(),
                                strokeWidth: 7,
                                backgroundColor: Colors.green.withOpacity(0.15),
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  Color(0xFF80FF80), 
                                ),
                                strokeCap: StrokeCap.round,
                              ),
                            ),
                            Container(
                              width: 236,
                              height: 236,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.purple.withOpacity(0.5),
                                    blurRadius: 30,
                                    spreadRadius: 8,
                                  ),
                                ],
                              ),
                              child: ClipOval(
                                child: Image.asset(
                                  _anhCayHienTai,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    Text(
                      layChuoiThoiGian(),
                      style: const TextStyle(
                        fontSize: 72,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 2,
                      ),
                    ),

                    Text(
                      layTrangThai(),
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.purple[100],
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 56),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: batDauHoacTamDung,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF9D50FF),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 18),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                elevation: 8,
                              ),
                              child: Text(
                                dangChay ? 'Tạm dừng' : 'Bắt đầu',
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: () {
                                setState(() {
                                  dangChay = false;
                                  laPhienTapTrung = true;
                                  _capNhatThoiGianHienTai();
                                });
                                _timer?.cancel();
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white,
                                side: BorderSide(color: Colors.white.withOpacity(0.35), width: 1.5),
                                padding: const EdgeInsets.symmetric(vertical: 18),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                backgroundColor: Colors.white.withOpacity(0.06),
                              ),
                              child: const Text(
                                'Đặt lại',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40), 
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        selectedFontSize: 14,
        unselectedFontSize: 12,
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ManHinhThongKe(danhSachPhien: danhSachPhien),
              ),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ManHinhCaiDat()),
            ).then((_) {
              _taiCaiDat().then((_) {
                _capNhatThoiGianHienTai();
              });
            });
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.timer), label: 'Đồng hồ'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Thống kê'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Cài đặt'),
        ],
      ),
    );
  }
}