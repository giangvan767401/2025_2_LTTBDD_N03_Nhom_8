import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'quan_ly_ngon_ngu.dart';
import 'man_hinh/man_hinh_dong_ho.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => QuanLyNgonNgu(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Đồng hồ Pomodoro',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const ManHinhDongHo(),
    );
  }
}
