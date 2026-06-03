import 'package:desktop_system/data/models/order_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('OrderModel.toEntity', () {
    final sampleJson = <String, dynamic>{
      'id': 'order-001',
      'channelType': 'online',
      'amount': 12.5,
      'num': 2,
      'checkUpNum': 1,
      'paymentType': 'wechat',
      'paymentStatus': 'paid',
      'refundStatus': 'none',
      'drawOutType': 1,
      'drawOutStatus': 0,
      'invoiceStatus': 'not_invoiced',
      'customerName': '张三',
      'customerPhone': '13800138000',
      'mainOrderInfoId': 'main-001',
      'organizerName': 'Test Org',
      'packageOrderActivityId': 'pkg-001',
      'ticketOutletName': 'Online',
      'createTime': '2025-01-01 10:00:00',
      'paymentTime': '2025-01-01 10:05:00',
      'performanceDetailModel': {
        'performanceId': 'perf-001',
        'performanceName': 'Test Performance',
        'name': 'Show A',
        'discountPolicyName': 'Early Bird',
        'drawOutControl': false,
        'date': '2025-06-01',
        'location': 'Venue A',
        'price': 100.0,
      },
    };

    test('maps all fields correctly', () {
      final model = OrderModel.fromJson(sampleJson);
      final entity = model.toEntity();

      expect(entity.id, 'order-001');
      expect(entity.channelType, 'online');
      expect(entity.num, 2);
      expect(entity.checkUpNum, 1);
      expect(entity.paymentType, 'wechat');
      expect(entity.paymentStatus, 'paid');
      expect(entity.refundStatus, 'none');
      expect(entity.customerName, '张三');
      expect(entity.customerPhone, '13800138000');
    });

    test('converts amount using yuanToCents (not toInt)', () {
      final model = OrderModel.fromJson(sampleJson);
      final entity = model.toEntity();

      // 12.5 yuan = 1250 cents
      expect(entity.amount, 1250);
    });

    test('handles amount that would fail with toInt truncation', () {
      final json = Map<String, dynamic>.from(sampleJson)..['amount'] = 12.999;
      final model = OrderModel.fromJson(json);
      final entity = model.toEntity();

      // With the bug (toInt), this would be 12 → 1200 cents
      // With the fix (yuanToCents), this is 13 → 1300 cents
      expect(entity.amount, 1300);
    });

    test('handles empty JSON gracefully', () {
      final model = OrderModel.fromJson({});
      final entity = model.toEntity();

      expect(entity.id, '');
      expect(entity.amount, 0);
    });
  });
}
