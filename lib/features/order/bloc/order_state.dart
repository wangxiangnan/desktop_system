import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:desktop_system/domain/entities/order_entity.dart';
import 'package:flutter/foundation.dart';

part 'order_state.freezed.dart';
part 'order_state.g.dart';

enum OrderListStatus { initial, loading, success, failure }

@freezed
abstract class OrderSearchParams with _$OrderSearchParams {
  const factory OrderSearchParams({
    String? orderInfoId,
    String? thirdOrderNoId,
    String? thirdOrderNo,
    String? packageOrderActivityId,
    String? mainOrderInfoId,
    String? ticketNo,
    String? createBeginTime,
    String? createEndTime,
    required int pageNum,
    required int pageSize,
  }) = _OrderSearchParams;

  const OrderSearchParams._();

  factory OrderSearchParams.fromJson(Map<String, Object?> json) => _$OrderSearchParamsFromJson(json);

}

@freezed
abstract class OrderState with _$OrderState {
  const factory OrderState({
    @Default(OrderListStatus.initial) OrderListStatus status,
    @Default(OrderSearchParams(pageSize: 30, pageNum: 1)) OrderSearchParams searchParams,
    @Default([]) List<Order> orders,
    @Default(1) int pageNum,
    @Default(10) int pageSize,
    @Default(0) int total,
    String? errorMessage,
  }) = _OrderState;
}
