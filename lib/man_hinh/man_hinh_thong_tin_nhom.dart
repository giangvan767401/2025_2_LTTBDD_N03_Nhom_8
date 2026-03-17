import 'package:flutter/material.dart';

class ManHinhThongTinNhom extends StatelessWidget {
  const ManHinhThongTinNhom({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, 
      appBar: AppBar(
        title: const Text('Thông tin nhóm', style: TextStyle(color: Colors.white)),
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
        child: const SafeArea(
          child: Center(
            child: Text(
              'Trang Thông tin nhóm (Đang xây dựng)',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
