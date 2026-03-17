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
                itemCount: 0, // sẽ cập nhật sau
                itemBuilder: (context, index) => const SizedBox(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}