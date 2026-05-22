import 'package:flutter_test/flutter_test.dart';
import 'package:desktop_system/core/utils/money_calculator.dart';

void main() {
  group('yuanToCents', () {
    test('converts integer yuan', () {
      expect(MoneyCalculator.yuanToCents(12), 1200);
    });

    test('converts double yuan', () {
      expect(MoneyCalculator.yuanToCents(12.5), 1250);
    });

    test('converts string yuan', () {
      expect(MoneyCalculator.yuanToCents('12.50'), 1250);
    });

    test('rounds fractional cents', () {
      expect(MoneyCalculator.yuanToCents(12.345), 1235);
      expect(MoneyCalculator.yuanToCents(12.344), 1234);
    });

    test('handles zero', () {
      expect(MoneyCalculator.yuanToCents(0), 0);
      expect(MoneyCalculator.yuanToCents(0.0), 0);
      expect(MoneyCalculator.yuanToCents('0'), 0);
    });

    test('throws on invalid string', () {
      expect(() => MoneyCalculator.yuanToCents('abc'), throwsArgumentError);
    });

    test('throws on unsupported type', () {
      expect(() => MoneyCalculator.yuanToCents(true), throwsArgumentError);
    });
  });

  group('centsToYuan', () {
    test('formats positive cents', () {
      expect(MoneyCalculator.centsToYuan(1250), '12.50');
    });

    test('formats zero cents', () {
      expect(MoneyCalculator.centsToYuan(0), '0.00');
    });

    test('formats cents without fractional part', () {
      expect(MoneyCalculator.centsToYuan(1200), '12.00');
    });

    test('formats cents with single fractional digit', () {
      expect(MoneyCalculator.centsToYuan(1255), '12.55');
    });

    test('formats negative cents', () {
      expect(MoneyCalculator.centsToYuan(-1250), '-12.50');
    });

    test('formats values less than 1 yuan', () {
      expect(MoneyCalculator.centsToYuan(50), '0.50');
      expect(MoneyCalculator.centsToYuan(5), '0.05');
    });
  });

  group('centsToYuanValue', () {
    test('converts to double', () {
      expect(MoneyCalculator.centsToYuanValue(1250), 12.5);
    });

    test('handles zero', () {
      expect(MoneyCalculator.centsToYuanValue(0), 0.0);
    });

    test('handles values less than 1 yuan', () {
      expect(MoneyCalculator.centsToYuanValue(50), 0.5);
    });
  });

  group('precision (decimal vs double)', () {
    test('yuanToCents avoids floating point drift', () {
      // double(0.1 + 0.2) = 0.30000000000000004
      // naive (0.1 + 0.2) * 100 = 30.000000000000004 → round → 30 (lucky)
      // but for values like 12.345, double can drift

      // Using double naively: (0.29 * 100).round() might give wrong result
      // because 0.29 is not exactly representable in binary
      // Decimal handles this correctly
      expect(MoneyCalculator.yuanToCents(0.29), 29);
    });

    test('multiply with decimal factor avoids drift', () {
      // 0.15 = 3/20, not exactly representable in binary
      // With Decimal: exact
      expect(MoneyCalculator.multiply(1999, 0.15), 300);
    });
  });

  group('arithmetic', () {
    test('add', () {
      expect(MoneyCalculator.add(100, 200), 300);
    });

    test('subtract', () {
      expect(MoneyCalculator.subtract(200, 100), 100);
      expect(MoneyCalculator.subtract(100, 200), -100);
    });

    test('multiply integer factor', () {
      expect(MoneyCalculator.multiply(100, 3), 300);
    });

    test('multiply decimal factor', () {
      expect(MoneyCalculator.multiply(1000, 0.15), 150);
    });

    test('divide', () {
      expect(MoneyCalculator.divide(100, 3), 33);
    });

    test('divide by zero throws', () {
      expect(() => MoneyCalculator.divide(100, 0), throwsArgumentError);
    });
  });
}
