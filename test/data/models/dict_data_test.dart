import 'package:flutter_test/flutter_test.dart';
import 'package:desktop_system/data/models/dict_data.dart';

void main() {
  group('DictData', () {
    test('fromJson creates valid DictData', () {
      final json = {'dictLabel': '支付宝', 'dictValue': 'alipay'};
      final data = DictData.fromJson(json);

      expect(data.dictLabel, '支付宝');
      expect(data.dictValue, 'alipay');
    });

    test('fromJson handles missing fields with defaults', () {
      final json = <String, dynamic>{};
      final data = DictData.fromJson(json);

      expect(data.dictLabel, '');
      expect(data.dictValue, '');
    });

    test('fromJson handles null fields with defaults', () {
      final json = {'dictLabel': null, 'dictValue': null};
      final data = DictData.fromJson(json);

      expect(data.dictLabel, '');
      expect(data.dictValue, '');
    });
  });
}
