import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../quan_ly_ngon_ngu.dart';
import '../chuoi_van_ban.dart';

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
      final lang = context.read<QuanLyNgonNgu>().ngonNgu;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(chuoiVanBan[lang]!['daLuu']!)),
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
    final languageProvider = context.watch<QuanLyNgonNgu>();
    final lang = languageProvider.ngonNgu;
    final strings = chuoiVanBan[lang]!;

    return Scaffold(
      backgroundColor: const Color(0xFF3C096C),
      appBar: AppBar(
        title: Text(strings['caiDat']!, style: const TextStyle(color: Colors.white)),
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
              Text(
                strings['cauHinhThoiGian']!,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 16),
              _buildTextField(strings['thoiGianTapTrung']!, _tapTrungController, Icons.center_focus_strong),
              _buildTextField(strings['thoiGianNghiNgan']!, _nghiNganController, Icons.local_cafe),
              _buildTextField(strings['thoiGianNghiDai']!, _nghiDaiController, Icons.weekend),
              const Divider(height: 32, color: Colors.white30),
              Text(
                strings['chuKy']!,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 16),
              _buildTextField(strings['soPhienNghiDai']!, _chuKyController, Icons.loop),
              const Divider(height: 32, color: Colors.white30),
              Text(
                strings['ngonNgu']!,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildOptionNgonNgu(
                      strings['tiengViet']!,
                      'vi',
                      lang == 'vi',
                      languageProvider,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildOptionNgonNgu(
                      strings['tiengAnh']!,
                      'en',
                      lang == 'en',
                      languageProvider,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
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
                child: Text(
                  strings['luuCaiDat']!,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionNgonNgu(String label, String code, bool isSelected, QuanLyNgonNgu provider) {
    return GestureDetector(
      onTap: () => provider.caiNgonNgu(code),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF9D50FF) : Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.white : Colors.white24,
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
