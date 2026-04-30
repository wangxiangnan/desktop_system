import 'package:equatable/equatable.dart';
import 'package:desktop_system/domain/entities/order_entity.dart';

enum OrderListStatus { initial, loading, success, failure }

class OrderSearchParams extends Equatable {
  final String orderInfoId;
  final String thirdOrderNoId;
  final String packageOrderActivityId;
  final String mainOrderInfoId;
  final String ticketNo;
  final String createBeginTime;
  final String createEndTime;

  const OrderSearchParams({
    this.orderInfoId = '',
    this.thirdOrderNoId = '',
    this.packageOrderActivityId = '',
    this.mainOrderInfoId = '',
    this.ticketNo = '',
    this.createBeginTime = '',
    this.createEndTime = '',
  });

  OrderSearchParams copyWith({
    String? orderInfoId,
    String? thirdOrderNoId,
    String? packageOrderActivityId,
    String? mainOrderInfoId,
    String? ticketNo,
    String? createBeginTime,
    String? createEndTime,
  }) {
    return OrderSearchParams(
      orderInfoId: orderInfoId ?? this.orderInfoId,
      thirdOrderNoId: thirdOrderNoId ?? this.thirdOrderNoId,
      packageOrderActivityId: packageOrderActivityId ?? this.packageOrderActivityId,
      mainOrderInfoId: mainOrderInfoId ?? this.mainOrderInfoId,
      ticketNo: ticketNo ?? this.ticketNo,
      createBeginTime: createBeginTime ?? this.createBeginTime,
      createEndTime: createEndTime ?? this.createEndTime,
    );
  }

  @override
  List<Object?> get props => [
        orderInfoId,
        thirdOrderNoId,
        packageOrderActivityId,
        mainOrderInfoId,
        ticketNo,
        createBeginTime,
        createEndTime,
      ];
}

class OrderState extends Equatable {
  final OrderListStatus status;
  final OrderSearchParams searchParams;
  final List<Order> orders;
  final int pageNum;
  final int pageSize;
  final int total;
  final String? errorMessage;

  const OrderState({
    this.status = OrderListStatus.initial,
    this.searchParams = const OrderSearchParams(),
    this.orders = const [],
    this.pageNum = 1,
    this.pageSize = 10,
    this.total = 0,
    this.errorMessage,
  });

  OrderState copyWith({
    OrderListStatus? status,
    OrderSearchParams? searchParams,
    List<Order>? orders,
    int? pageNum,
    int? pageSize,
    int? total,
    String? errorMessage,
  }) {
    return OrderState(
      status: status ?? this.status,
      searchParams: searchParams ?? this.searchParams,
      orders: orders ?? this.orders,
      pageNum: pageNum ?? this.pageNum,
      pageSize: pageSize ?? this.pageSize,
      total: total ?? this.total,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        searchParams,
        orders,
        pageNum,
        pageSize,
        total,
        errorMessage,
      ];
}
