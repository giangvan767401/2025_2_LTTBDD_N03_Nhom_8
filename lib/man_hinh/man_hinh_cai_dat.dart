import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ManHinhCaiDat extends StatefulWidget {
  const ManHinhCaiDat({super.key});

  @override
  State<ManHinhCaiDat> createState() => _ManHinhCaiDatState();
}

class _ManHinhCaiDatState extends State<ManHinhCaiDat> {
  final _tapTrungController = TextEditingController();
  final _nghiNganController = TextEditingController();
  final _nghiDaiController = TextEditingController();
  final _chuKyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _taiCaiDat();
  }

  Future<void> _taiCaiDat() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _tapTrungController.text = (prefs.getInt('thoiGianTapTrungPhut') ?? 25)
          .toString();
      _nghiNganController.text = (prefs.getInt('thoiGianNghiNganPhut') ?? 5)
          .toString();
      _nghiDaiController.text = (prefs.getInt('thoiGianNghiDaiPhut') ?? 15)
          .toString();
      _chuKyController.text = (prefs.getInt('chuKyNghiDai') ?? 4).toString();
    });
  }

  Future<void> _luuCaiDat() async {
    final prefs = await SharedPreferences.getInstance();

    int tapTrung = int.tryParse(_tapTrungController.text) ?? 25;
    int nghiNgan = int.tryParse(_nghiNganController.text) ?? 5;
    int nghiDai = int.tryParse(_nghiDaiController.text) ?? 15;
    int chuKy = int.tryParse(_chuKyController.text) ?? 4;

    await prefs.setInt('thoiGianTapTrungPhut', tapTrung);
    await prefs.setInt('thoiGianNghiNganPhut', nghiNgan);
    await prefs.setInt('thoiGianNghiDaiPhut', nghiDai);
    await prefs.setInt('chuKyNghiDai', chuKy);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã lưu cấu hình thành công!')),
      );
    }
  }

  @override
  void dispose() {
    _tapTrungController.dispose();
    _nghiNganController.dispose();
    _nghiDaiController.dispose();
    _chuKyController.dispose();
    super.dispose();
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70),
          prefixIcon: Icon(icon, color: Colors.white70),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.white30),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF9D50FF), width: 2),
          ),
          filled: true,
          fillColor: Colors.white.withOpacity(0.1),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3C096C),
      appBar: AppBar(
        title: const Text('Cài đặt Pomodoro', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF120326),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF120326), Color(0xFF3C096C)],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Cấu hình thời gian (Phút)',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 16),
              _buildTextField('Thời gian tập trung', _tapTrungController, Icons.center_focus_strong),
              _buildTextField('Thời gian nghỉ ngắn', _nghiNganController, Icons.local_cafe),
              _buildTextField('Thời gian nghỉ dài', _nghiDaiController, Icons.weekend),
              const Divider(height: 32, color: Colors.white30),
              const Text(
                'Chu kỳ',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 16),
              _buildTextField('Số phiên để nghỉ dài', _chuKyController, Icons.loop),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _luuCaiDat,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: const Color(0xFF9D50FF),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Lưu cài đặt',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
