/// Dictionary data item from system dict API.
class DictData {
  final String dictLabel;
  final String dictValue;

  const DictData({required this.dictLabel, required this.dictValue});

  factory DictData.fromJson(Map<String, dynamic> json) {
    return DictData(
      dictLabel: json['dictLabel'] as String? ?? '',
      dictValue: json['dictValue'] as String? ?? '',
    );
  }
}
