import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuanLyNgonNgu extends ChangeNotifier {
  String _ngonNgu = 'vi';

  String get ngonNgu => _ngonNgu;

  QuanLyNgonNgu() {
    _taiNgonNgu();
  }

  Future<void> _taiNgonNgu() async {
    final prefs = await SharedPreferences.getInstance();
    _ngonNgu = prefs.getString('appLanguage') ?? 'vi';
    notifyListeners();
  }

  Future<void> caiNgonNgu(String code) async {
    if (_ngonNgu == code) return;
    _ngonNgu = code;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('appLanguage', code);
    notifyListeners();
  }
}
