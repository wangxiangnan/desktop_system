import 'package:equatable/equatable.dart';

class Order extends Equatable {
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

  final String performanceId;
  final String performanceName;
  final String showName;
  final String discountPolicyName;
  final bool drawOutControl;
  final DateTime date;
  final String location;
  final double price;

  const Order({
    required this.id,
    required this.channelType,
    required this.amount,
    required this.num,
    required this.checkUpNum,
    required this.paymentType,
    required this.paymentStatus,
    required this.discountPolicyName,
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
    required this.performanceId,
    required this.performanceName,
    required this.showName,
    required this.drawOutControl,
    required this.date,
    required this.location,
    required this.price,
  });

  @override
  List<Object?> get props => [
    id,
    channelType,
    amount,
    num,
    checkUpNum,
    paymentType,
    paymentStatus,
    discountPolicyName,
    refundStatus,
    drawOutStatus,
    invoiceStatus,
    customerName,
    customerPhone,
    mainOrderInfoId,
    packageOrderActivityId,
    ticketOutletName,
    createTime,
    paymentTime,
    performanceId,
    performanceName,
    showName,
    drawOutControl,
    date,
    location,
    price,
  ];
}
