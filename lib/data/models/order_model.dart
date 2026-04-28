import 'package:desktop_system/domain/entities/order_entity.dart';

class OrderModel {
  final String id;
  final String channelType;
  final double amount;
  final double num;
  final double checkUpNum;
  final String paymentType;
  final String paymentStatus;
  final String refundStatus;
  final String drawOutType;
  final String drawOutStatus;
  final String invoiceStatus;
  final String customerName;
  final String customerPhone;
  final String mainOrderInfoId;
  final String organizerName;
  final String packageOrderActivityId;
  final String ticketOutletName;
  final String createTime;
  final String paymentTime;
  final PerformanceDetailModel performanceDetailModel;

  const OrderModel({
    required this.id,
    required this.channelType,
    required this.amount,
    required this.num,
    required this.checkUpNum,
    required this.paymentType,
    required this.paymentStatus,
    required this.refundStatus,
    required this.drawOutType,
    required this.drawOutStatus,
    required this.invoiceStatus,
    required this.customerName,
    required this.customerPhone,
    required this.mainOrderInfoId,
    required this.organizerName,
    required this.packageOrderActivityId,
    required this.ticketOutletName,
    required this.createTime,
    required this.paymentTime,
    required this.performanceDetailModel,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as String? ?? '',
      channelType: json['channelType'] as String? ?? '',
      amount: (json['amount'] as double?)?.toDouble() ?? 0.0,
      num: (json['num'] as double?)?.toDouble() ?? 0.0,
      checkUpNum: (json['checkUpNum'] as double?)?.toDouble() ?? 0.0,
      paymentType: json['paymentType'] as String? ?? '',
      paymentStatus: json['paymentStatus'] as String? ?? '',
      refundStatus: json['refundStatus'] as String? ?? '',
      drawOutType: json['drawOutType'] as String? ?? '',
      drawOutStatus: json['drawOutStatus'] as String? ?? '',
      invoiceStatus: json['invoiceStatus'] as String? ?? '',
      customerName: json['customerName'] as String? ?? '',
      customerPhone: json['customerPhone'] as String? ?? '',
      mainOrderInfoId: json['mainOrderInfoId'] as String? ?? '',
      organizerName: json['organizerName'] as String? ?? '',
      packageOrderActivityId: json['packageOrderActivityId'] as String? ?? '',
      ticketOutletName: json['ticketOutletName'] as String? ?? '',
      createTime: json['createTime'] as String? ?? '',
      paymentTime: json['paymentTime'] as String? ?? '',

      performanceDetailModel: PerformanceDetailModel.fromJson(json['performanceDetailModel'] as Map<String, dynamic>? ?? {}),
    );
  }

  Order toEntity() {
    return Order(
      id: id,
      channelType: channelType,
      amount: amount,
      num: num,
      checkUpNum: checkUpNum,
      paymentType: paymentType,
      paymentStatus: paymentStatus,
      refundStatus: refundStatus,
      drawOutType: drawOutType,
      drawOutStatus: drawOutStatus,
      invoiceStatus: invoiceStatus,
      customerName: customerName,
      customerPhone: customerPhone,
      mainOrderInfoId: mainOrderInfoId,
      organizerName: organizerName,
      packageOrderActivityId: packageOrderActivityId,
      ticketOutletName: ticketOutletName,
      createTime: createTime,
      paymentTime: paymentTime,

      performanceId: performanceDetailModel.performanceId,
      performanceName: performanceDetailModel.performanceName,
      showName: performanceDetailModel.name,
      discountPolicyName: performanceDetailModel.discountPolicyName,
      drawOutControl: performanceDetailModel.drawOutControl,
      date: performanceDetailModel.date,
      location: performanceDetailModel.location,
      price: performanceDetailModel.price,
    );
  }
}

class PerformanceDetailModel {
  final String performanceId;
  final String performanceName;
  final String name;
  final String discountPolicyName;
  final bool drawOutControl;
  final DateTime date;
  final String location;
  final double price;

  const PerformanceDetailModel({
    required this.performanceId,
    required this.performanceName,
    required this.name,
    required this.discountPolicyName,
    required this.drawOutControl,
    required this.date,
    required this.location,
    required this.price,
  });

  factory PerformanceDetailModel.fromJson(Map<String, dynamic> json) {
    return PerformanceDetailModel(
      performanceId: json['performanceId'] as String? ?? '',
      performanceName: json['performanceName'] as String? ?? '',
      name: json['name'] as String? ?? '',
      discountPolicyName: json['discountPolicyName'] as String? ?? '',
      drawOutControl: json['drawOutControl'] as bool? ?? false,
      date: DateTime.tryParse(json['date'] as String? ?? '') ?? DateTime.now(),
      location: json['location'] as String? ?? '',
      price: (json['price'] as double?)?.toDouble() ?? 0.0,
    );
  }
}