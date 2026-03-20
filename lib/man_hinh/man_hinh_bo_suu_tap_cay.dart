import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../quan_ly_ngon_ngu.dart';
import '../chuoi_van_ban.dart';

class ManHinhBoSuuTapCay extends StatefulWidget {
  final int tongPhutTichLuy;
  final String anhCayDangDung;

  const ManHinhBoSuuTapCay({
    super.key,
    required this.tongPhutTichLuy,
    required this.anhCayDangDung,
  });

  @override
  State<ManHinhBoSuuTapCay> createState() => _ManHinhBoSuuTapCayState();
}

class _ManHinhBoSuuTapCayState extends State<ManHinhBoSuuTapCay> {
  // No longer hardcoded as we need to localize names based on state

  Future<void> _chonAnh(String path, bool isLocked, String lockedMessage) async {
    if (isLocked) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(lockedMessage)),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('anhCayHienTai', path);
    if (mounted) {
      Navigator.pop(context, path);
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<QuanLyNgonNgu>().ngonNgu;
    final strings = chuoiVanBan[lang]!;

    // Tree names localization
    final List<Map<String, dynamic>> localizedTrees = [
      {'anh': 'assets/images/tree1.jpg', 'phutCanDat': 0, 'ten': lang == 'vi' ? 'Cây mầm' : 'Sprout'},
      {'anh': 'assets/images/tree2.jpg', 'phutCanDat': 5, 'ten': lang == 'vi' ? 'Cây xanh' : 'Green Tree'},
      {'anh': 'assets/images/tree3.jpg', 'phutCanDat': 60, 'ten': lang == 'vi' ? 'Cây vươn' : 'Reach Tree'},
      {'anh': 'assets/images/tree4.jpg', 'phutCanDat': 120, 'ten': lang == 'vi' ? 'Cây lớn' : 'Big Tree'},
      {'anh': 'assets/images/tree5.jpg', 'phutCanDat': 240, 'ten': lang == 'vi' ? 'Cây cổ thụ' : 'Ancient Tree'},
      {'anh': 'assets/images/tree6.jpg', 'phutCanDat': 480, 'ten': lang == 'vi' ? 'Cây vũ trụ' : 'Cosmic Tree'},
      {'anh': 'assets/images/tree7.jpg', 'phutCanDat': 960, 'ten': lang == 'vi' ? 'Cây thần thoại' : 'Mythic Tree'},
      {'anh': 'assets/images/tree8.jpg', 'phutCanDat': 1440, 'ten': lang == 'vi' ? 'Cây bất tử' : 'Immortal Tree'},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF120326),
      appBar: AppBar(
        title: Text(strings['cuaHangCay']!, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                '${strings['tongThoiGian']}: ${widget.tongPhutTichLuy} ${strings['phutDonVi']}',
                style: const TextStyle(color: Colors.white70, fontSize: 16),
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.8,
                ),
                itemCount: localizedTrees.length,
                itemBuilder: (context, index) {
                  final item = localizedTrees[index];
                  final bool isLocked = widget.tongPhutTichLuy < item['phutCanDat'];
                  final bool isUsing = widget.anhCayDangDung == item['anh'];

                  return GestureDetector(
                    onTap: () => _chonAnh(item['anh'], isLocked, strings['chuaMoKhoa']!),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isUsing ? const Color(0xFF80FF80) : Colors.white10,
                          width: isUsing ? 2 : 1,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Opacity(
                                opacity: isLocked ? 0.3 : 1.0,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Image.asset(
                                    item['anh'],
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              if (isLocked)
                                const Icon(Icons.lock, color: Colors.white54, size: 30),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            item['ten'],
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            isLocked ? '${strings['canPhut']} ${item['phutCanDat']}p' : strings['daMoKhoa']!,
                            style: TextStyle(
                              color: isLocked ? Colors.redAccent : const Color(0xFF80FF80),
                              fontSize: 12,
                            ),
                          ),
                          if (isUsing)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(strings['dangDung']!, style: const TextStyle(color: Color(0xFF80FF80), fontSize: 10)),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
