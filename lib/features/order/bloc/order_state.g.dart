// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OrderSearchParams _$OrderSearchParamsFromJson(Map<String, dynamic> json) =>
    _OrderSearchParams(
      orderInfoId: json['orderInfoId'] as String?,
      thirdOrderNoId: json['thirdOrderNoId'] as String?,
      thirdOrderNo: json['thirdOrderNo'] as String?,
      packageOrderActivityId: json['packageOrderActivityId'] as String?,
      mainOrderInfoId: json['mainOrderInfoId'] as String?,
      ticketNo: json['ticketNo'] as String?,
      createBeginTime: json['createBeginTime'] as String?,
      createEndTime: json['createEndTime'] as String?,
      pageNum: (json['pageNum'] as num?)?.toInt() ?? 1,
      pageSize: (json['pageSize'] as num?)?.toInt() ?? 30,
    );

Map<String, dynamic> _$OrderSearchParamsToJson(_OrderSearchParams instance) =>
    <String, dynamic>{
      'orderInfoId': instance.orderInfoId,
      'thirdOrderNoId': instance.thirdOrderNoId,
      'thirdOrderNo': instance.thirdOrderNo,
      'packageOrderActivityId': instance.packageOrderActivityId,
      'mainOrderInfoId': instance.mainOrderInfoId,
      'ticketNo': instance.ticketNo,
      'createBeginTime': instance.createBeginTime,
      'createEndTime': instance.createEndTime,
      'pageNum': instance.pageNum,
      'pageSize': instance.pageSize,
    };
