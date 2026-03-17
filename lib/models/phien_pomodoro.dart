class PhienPomodoro {
  final DateTime thoiGianHoanThanh;
  final int thoiLuongGiay; 

  PhienPomodoro({
    required this.thoiGianHoanThanh,
    required this.thoiLuongGiay,
  });

  Map<String, dynamic> toJson() {
    return {
      'thoiGianHoanThanh': thoiGianHoanThanh.toIso8601String(),
      'thoiLuongGiay': thoiLuongGiay,
    };
  }

  factory PhienPomodoro.fromJson(Map<String, dynamic> json) {
    return PhienPomodoro(
      thoiGianHoanThanh: DateTime.parse(json['thoiGianHoanThanh']),
      thoiLuongGiay: json['thoiLuongGiay'] ?? 0,
    );
  }
}