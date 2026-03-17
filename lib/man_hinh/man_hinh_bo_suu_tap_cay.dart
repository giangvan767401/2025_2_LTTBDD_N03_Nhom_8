import 'package:flutter/material.dart';

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
  final List<Map<String, dynamic>> dsNguongMoKhoa = [
    {'anh': 'assets/images/tree1.jpg', 'phutCanDat': 0, 'ten': 'Cây mầm'},
    {'anh': 'assets/images/tree2.jpg', 'phutCanDat': 25, 'ten': 'Cây xanh'},
    {'anh': 'assets/images/tree3.jpg', 'phutCanDat': 60, 'ten': 'Cây vươn'},
    {'anh': 'assets/images/tree4.jpg', 'phutCanDat': 120, 'ten': 'Cây lớn'},
    {'anh': 'assets/images/tree5.jpg', 'phutCanDat': 240, 'ten': 'Cây cổ thụ'},
    {'anh': 'assets/images/tree6.jpg', 'phutCanDat': 480, 'ten': 'Cây vũ trụ'},
    {'anh': 'assets/images/tree7.jpg', 'phutCanDat': 960, 'ten': 'Cây thần thoại'},
    {'anh': 'assets/images/tree8.jpg', 'phutCanDat': 1440, 'ten': 'Cây bất tử'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF120326),
      appBar: AppBar(
        title: const Text('Cửa hàng cây', style: TextStyle(color: Colors.white)),
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
                'Tổng thời gian: ${widget.tongPhutTichLuy} phút',
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
                itemCount: dsNguongMoKhoa.length,
                itemBuilder: (context, index) {
                  final item = dsNguongMoKhoa[index];
                  final bool isLocked = widget.tongPhutTichLuy < item['phutCanDat'];
                  final bool isUsing = widget.anhCayDangDung == item['anh'];

                  return GestureDetector(
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
                            isLocked ? 'Cần ${item['phutCanDat']}p' : 'Đã mở khóa',
                            style: TextStyle(
                              color: isLocked ? Colors.redAccent : const Color(0xFF80FF80),
                              fontSize: 12,
                            ),
                          ),
                          if (isUsing)
                            const Padding(
                              padding: EdgeInsets.only(top: 4),
                              child: Text(
                                'Đang dùng',
                                style: TextStyle(color: Color(0xFF80FF80), fontSize: 10),
                              ),
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