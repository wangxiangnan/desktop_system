import 'package:decimal/decimal.dart';

class MoneyCalculator {
  MoneyCalculator._();

  /// 元 → 分，四舍五入保留两位小数
  ///
  /// 使用 [Decimal] 确保金额转换无精度丢失
  /// ```dart
  /// MoneyCalculator.yuanToCents(12.5)     // → 1250
  /// MoneyCalculator.yuanToCents('12.50')  // → 1250
  /// MoneyCalculator.yuanToCents(12)       // → 1200
  /// ```
  static int yuanToCents(dynamic yuan) {
    final decimal = _toDecimal(yuan);
    return (decimal * Decimal.fromInt(100)).round().toBigInt().toInt();
  }

  /// 分 → 元（格式化显示），如 1250 → "12.50"
  static String centsToYuan(int cents) {
    final sign = cents.isNegative ? '-' : '';
    final abs = cents.abs();
    final yuan = abs ~/ 100;
    final fen = abs % 100;
    return '$sign$yuan.${fen.toString().padLeft(2, '0')}';
  }

  /// 分 → 元（数值），如 1250 → 12.5
  ///
  /// 仅用于图表计算、传参给后端等情况，
  /// 前端显示请用 [centsToYuan] 避免浮点显示问题。
  static double centsToYuanValue(int cents) => cents / 100;

  /// 加法（分）
  static int add(int a, int b) => a + b;

  /// 减法（分）
  static int subtract(int a, int b) => a - b;

  /// 乘法（分 × 倍数），四舍五入
  ///
  /// 使用 [Decimal] 确保倍数如 0.15 无精度丢失
  /// ```dart
  /// MoneyCalculator.multiply(1000, 0.15) // → 150 (15%)
  /// MoneyCalculator.multiply(1000, 3)    // → 3000
  /// ```
  static int multiply(int cents, num factor) {
    final result = Decimal.fromInt(cents) * _toDecimal(factor);
    return result.round().toBigInt().toInt();
  }

  /// 除法（分 ÷ 除数），四舍五入
  ///
  /// 使用 [Decimal] 确保无限小数场景精确截断
  /// ```dart
  /// MoneyCalculator.divide(100, 3) // → 33
  /// ```
  static int divide(int cents, num divisor) {
    if (divisor == 0) throw ArgumentError('Division by zero');
    final result = Decimal.fromInt(cents) / _toDecimal(divisor);
    return result
        .toDecimal(scaleOnInfinitePrecision: 10)
        .round()
        .toBigInt()
        .toInt();
  }

  static Decimal _toDecimal(dynamic value) {
    if (value is int) return Decimal.fromInt(value);
    if (value is double) return Decimal.parse(value.toStringAsFixed(10));
    if (value is String) {
      final d = Decimal.tryParse(value);
      if (d == null) throw ArgumentError('Invalid yuan format: $value');
      return d;
    }
    throw ArgumentError('Unsupported type: ${value.runtimeType}');
  }
}
