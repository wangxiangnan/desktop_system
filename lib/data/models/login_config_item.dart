class LoginConfigItem {
  final String keyNum;
  final String keyValue;

  const LoginConfigItem({required this.keyNum, required this.keyValue});

  factory LoginConfigItem.fromJson(Map<String, dynamic> json) {
    return LoginConfigItem(
      keyNum: json['keyNum'] as String? ?? '',
      keyValue: json['keyValue'] as String? ?? '',
    );
  }
}
