import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../quan_ly_ngon_ngu.dart';
import '../chuoi_van_ban.dart';

class ManHinhThongTinNhom extends StatelessWidget {
  const ManHinhThongTinNhom({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<QuanLyNgonNgu>().ngonNgu;
    final strings = chuoiVanBan[lang]!;

    return Scaffold(
      extendBodyBehindAppBar: true, 
      appBar: AppBar(
        title: Text(strings['thongTinNhom']!, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF05010D), Color(0xFF0D0221)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  strings['tenNhom']!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  strings['thanhVien']!,
                  style: const TextStyle(
                    color: Color(0xFF80FF80),
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                _buildMemberItem('23010536', 'Phạm Văn Giang', 'assets/images/giang.jpg', strings['mssv']!),
                const SizedBox(height: 12),
                _buildMemberItem('23010052', 'Nguyễn Hữu Tình', 'assets/images/tinh.jpg', strings['mssv']!),

              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMemberItem(String id, String name, String imagePath, String mssvLabel) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: const Color(0xFF9D50FF),
            backgroundImage: AssetImage(imagePath),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$mssvLabel: $id',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
