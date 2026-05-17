// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OrderSearchParams implements DiagnosticableTreeMixin {

 String? get orderInfoId; String? get thirdOrderNoId; String? get thirdOrderNo; String? get packageOrderActivityId; String? get mainOrderInfoId; String? get ticketNo; String? get createBeginTime; String? get createEndTime; int get pageNum; int get pageSize;
/// Create a copy of OrderSearchParams
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderSearchParamsCopyWith<OrderSearchParams> get copyWith => _$OrderSearchParamsCopyWithImpl<OrderSearchParams>(this as OrderSearchParams, _$identity);

  /// Serializes this OrderSearchParams to a JSON map.
  Map<String, dynamic> toJson();

@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'OrderSearchParams'))
    ..add(DiagnosticsProperty('orderInfoId', orderInfoId))..add(DiagnosticsProperty('thirdOrderNoId', thirdOrderNoId))..add(DiagnosticsProperty('thirdOrderNo', thirdOrderNo))..add(DiagnosticsProperty('packageOrderActivityId', packageOrderActivityId))..add(DiagnosticsProperty('mainOrderInfoId', mainOrderInfoId))..add(DiagnosticsProperty('ticketNo', ticketNo))..add(DiagnosticsProperty('createBeginTime', createBeginTime))..add(DiagnosticsProperty('createEndTime', createEndTime))..add(DiagnosticsProperty('pageNum', pageNum))..add(DiagnosticsProperty('pageSize', pageSize));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderSearchParams&&(identical(other.orderInfoId, orderInfoId) || other.orderInfoId == orderInfoId)&&(identical(other.thirdOrderNoId, thirdOrderNoId) || other.thirdOrderNoId == thirdOrderNoId)&&(identical(other.thirdOrderNo, thirdOrderNo) || other.thirdOrderNo == thirdOrderNo)&&(identical(other.packageOrderActivityId, packageOrderActivityId) || other.packageOrderActivityId == packageOrderActivityId)&&(identical(other.mainOrderInfoId, mainOrderInfoId) || other.mainOrderInfoId == mainOrderInfoId)&&(identical(other.ticketNo, ticketNo) || other.ticketNo == ticketNo)&&(identical(other.createBeginTime, createBeginTime) || other.createBeginTime == createBeginTime)&&(identical(other.createEndTime, createEndTime) || other.createEndTime == createEndTime)&&(identical(other.pageNum, pageNum) || other.pageNum == pageNum)&&(identical(other.pageSize, pageSize) || other.pageSize == pageSize));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,orderInfoId,thirdOrderNoId,thirdOrderNo,packageOrderActivityId,mainOrderInfoId,ticketNo,createBeginTime,createEndTime,pageNum,pageSize);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'OrderSearchParams(orderInfoId: $orderInfoId, thirdOrderNoId: $thirdOrderNoId, thirdOrderNo: $thirdOrderNo, packageOrderActivityId: $packageOrderActivityId, mainOrderInfoId: $mainOrderInfoId, ticketNo: $ticketNo, createBeginTime: $createBeginTime, createEndTime: $createEndTime, pageNum: $pageNum, pageSize: $pageSize)';
}


}

/// @nodoc
abstract mixin class $OrderSearchParamsCopyWith<$Res>  {
  factory $OrderSearchParamsCopyWith(OrderSearchParams value, $Res Function(OrderSearchParams) _then) = _$OrderSearchParamsCopyWithImpl;
@useResult
$Res call({
 String? orderInfoId, String? thirdOrderNoId, String? thirdOrderNo, String? packageOrderActivityId, String? mainOrderInfoId, String? ticketNo, String? createBeginTime, String? createEndTime, int pageNum, int pageSize
});




}
/// @nodoc
class _$OrderSearchParamsCopyWithImpl<$Res>
    implements $OrderSearchParamsCopyWith<$Res> {
  _$OrderSearchParamsCopyWithImpl(this._self, this._then);

  final OrderSearchParams _self;
  final $Res Function(OrderSearchParams) _then;

/// Create a copy of OrderSearchParams
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? orderInfoId = freezed,Object? thirdOrderNoId = freezed,Object? thirdOrderNo = freezed,Object? packageOrderActivityId = freezed,Object? mainOrderInfoId = freezed,Object? ticketNo = freezed,Object? createBeginTime = freezed,Object? createEndTime = freezed,Object? pageNum = null,Object? pageSize = null,}) {
  return _then(_self.copyWith(
orderInfoId: freezed == orderInfoId ? _self.orderInfoId : orderInfoId // ignore: cast_nullable_to_non_nullable
as String?,thirdOrderNoId: freezed == thirdOrderNoId ? _self.thirdOrderNoId : thirdOrderNoId // ignore: cast_nullable_to_non_nullable
as String?,thirdOrderNo: freezed == thirdOrderNo ? _self.thirdOrderNo : thirdOrderNo // ignore: cast_nullable_to_non_nullable
as String?,packageOrderActivityId: freezed == packageOrderActivityId ? _self.packageOrderActivityId : packageOrderActivityId // ignore: cast_nullable_to_non_nullable
as String?,mainOrderInfoId: freezed == mainOrderInfoId ? _self.mainOrderInfoId : mainOrderInfoId // ignore: cast_nullable_to_non_nullable
as String?,ticketNo: freezed == ticketNo ? _self.ticketNo : ticketNo // ignore: cast_nullable_to_non_nullable
as String?,createBeginTime: freezed == createBeginTime ? _self.createBeginTime : createBeginTime // ignore: cast_nullable_to_non_nullable
as String?,createEndTime: freezed == createEndTime ? _self.createEndTime : createEndTime // ignore: cast_nullable_to_non_nullable
as String?,pageNum: null == pageNum ? _self.pageNum : pageNum // ignore: cast_nullable_to_non_nullable
as int,pageSize: null == pageSize ? _self.pageSize : pageSize // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [OrderSearchParams].
extension OrderSearchParamsPatterns on OrderSearchParams {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrderSearchParams value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrderSearchParams() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrderSearchParams value)  $default,){
final _that = this;
switch (_that) {
case _OrderSearchParams():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrderSearchParams value)?  $default,){
final _that = this;
switch (_that) {
case _OrderSearchParams() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? orderInfoId,  String? thirdOrderNoId,  String? thirdOrderNo,  String? packageOrderActivityId,  String? mainOrderInfoId,  String? ticketNo,  String? createBeginTime,  String? createEndTime,  int pageNum,  int pageSize)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrderSearchParams() when $default != null:
return $default(_that.orderInfoId,_that.thirdOrderNoId,_that.thirdOrderNo,_that.packageOrderActivityId,_that.mainOrderInfoId,_that.ticketNo,_that.createBeginTime,_that.createEndTime,_that.pageNum,_that.pageSize);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? orderInfoId,  String? thirdOrderNoId,  String? thirdOrderNo,  String? packageOrderActivityId,  String? mainOrderInfoId,  String? ticketNo,  String? createBeginTime,  String? createEndTime,  int pageNum,  int pageSize)  $default,) {final _that = this;
switch (_that) {
case _OrderSearchParams():
return $default(_that.orderInfoId,_that.thirdOrderNoId,_that.thirdOrderNo,_that.packageOrderActivityId,_that.mainOrderInfoId,_that.ticketNo,_that.createBeginTime,_that.createEndTime,_that.pageNum,_that.pageSize);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? orderInfoId,  String? thirdOrderNoId,  String? thirdOrderNo,  String? packageOrderActivityId,  String? mainOrderInfoId,  String? ticketNo,  String? createBeginTime,  String? createEndTime,  int pageNum,  int pageSize)?  $default,) {final _that = this;
switch (_that) {
case _OrderSearchParams() when $default != null:
return $default(_that.orderInfoId,_that.thirdOrderNoId,_that.thirdOrderNo,_that.packageOrderActivityId,_that.mainOrderInfoId,_that.ticketNo,_that.createBeginTime,_that.createEndTime,_that.pageNum,_that.pageSize);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OrderSearchParams extends OrderSearchParams with DiagnosticableTreeMixin {
  const _OrderSearchParams({this.orderInfoId, this.thirdOrderNoId, this.thirdOrderNo, this.packageOrderActivityId, this.mainOrderInfoId, this.ticketNo, this.createBeginTime, this.createEndTime, required this.pageNum, required this.pageSize}): super._();
  factory _OrderSearchParams.fromJson(Map<String, dynamic> json) => _$OrderSearchParamsFromJson(json);

@override final  String? orderInfoId;
@override final  String? thirdOrderNoId;
@override final  String? thirdOrderNo;
@override final  String? packageOrderActivityId;
@override final  String? mainOrderInfoId;
@override final  String? ticketNo;
@override final  String? createBeginTime;
@override final  String? createEndTime;
@override final  int pageNum;
@override final  int pageSize;

/// Create a copy of OrderSearchParams
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderSearchParamsCopyWith<_OrderSearchParams> get copyWith => __$OrderSearchParamsCopyWithImpl<_OrderSearchParams>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OrderSearchParamsToJson(this, );
}
@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'OrderSearchParams'))
    ..add(DiagnosticsProperty('orderInfoId', orderInfoId))..add(DiagnosticsProperty('thirdOrderNoId', thirdOrderNoId))..add(DiagnosticsProperty('thirdOrderNo', thirdOrderNo))..add(DiagnosticsProperty('packageOrderActivityId', packageOrderActivityId))..add(DiagnosticsProperty('mainOrderInfoId', mainOrderInfoId))..add(DiagnosticsProperty('ticketNo', ticketNo))..add(DiagnosticsProperty('createBeginTime', createBeginTime))..add(DiagnosticsProperty('createEndTime', createEndTime))..add(DiagnosticsProperty('pageNum', pageNum))..add(DiagnosticsProperty('pageSize', pageSize));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderSearchParams&&(identical(other.orderInfoId, orderInfoId) || other.orderInfoId == orderInfoId)&&(identical(other.thirdOrderNoId, thirdOrderNoId) || other.thirdOrderNoId == thirdOrderNoId)&&(identical(other.thirdOrderNo, thirdOrderNo) || other.thirdOrderNo == thirdOrderNo)&&(identical(other.packageOrderActivityId, packageOrderActivityId) || other.packageOrderActivityId == packageOrderActivityId)&&(identical(other.mainOrderInfoId, mainOrderInfoId) || other.mainOrderInfoId == mainOrderInfoId)&&(identical(other.ticketNo, ticketNo) || other.ticketNo == ticketNo)&&(identical(other.createBeginTime, createBeginTime) || other.createBeginTime == createBeginTime)&&(identical(other.createEndTime, createEndTime) || other.createEndTime == createEndTime)&&(identical(other.pageNum, pageNum) || other.pageNum == pageNum)&&(identical(other.pageSize, pageSize) || other.pageSize == pageSize));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,orderInfoId,thirdOrderNoId,thirdOrderNo,packageOrderActivityId,mainOrderInfoId,ticketNo,createBeginTime,createEndTime,pageNum,pageSize);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'OrderSearchParams(orderInfoId: $orderInfoId, thirdOrderNoId: $thirdOrderNoId, thirdOrderNo: $thirdOrderNo, packageOrderActivityId: $packageOrderActivityId, mainOrderInfoId: $mainOrderInfoId, ticketNo: $ticketNo, createBeginTime: $createBeginTime, createEndTime: $createEndTime, pageNum: $pageNum, pageSize: $pageSize)';
}


}

/// @nodoc
abstract mixin class _$OrderSearchParamsCopyWith<$Res> implements $OrderSearchParamsCopyWith<$Res> {
  factory _$OrderSearchParamsCopyWith(_OrderSearchParams value, $Res Function(_OrderSearchParams) _then) = __$OrderSearchParamsCopyWithImpl;
@override @useResult
$Res call({
 String? orderInfoId, String? thirdOrderNoId, String? thirdOrderNo, String? packageOrderActivityId, String? mainOrderInfoId, String? ticketNo, String? createBeginTime, String? createEndTime, int pageNum, int pageSize
});




}
/// @nodoc
class __$OrderSearchParamsCopyWithImpl<$Res>
    implements _$OrderSearchParamsCopyWith<$Res> {
  __$OrderSearchParamsCopyWithImpl(this._self, this._then);

  final _OrderSearchParams _self;
  final $Res Function(_OrderSearchParams) _then;

/// Create a copy of OrderSearchParams
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? orderInfoId = freezed,Object? thirdOrderNoId = freezed,Object? thirdOrderNo = freezed,Object? packageOrderActivityId = freezed,Object? mainOrderInfoId = freezed,Object? ticketNo = freezed,Object? createBeginTime = freezed,Object? createEndTime = freezed,Object? pageNum = null,Object? pageSize = null,}) {
  return _then(_OrderSearchParams(
orderInfoId: freezed == orderInfoId ? _self.orderInfoId : orderInfoId // ignore: cast_nullable_to_non_nullable
as String?,thirdOrderNoId: freezed == thirdOrderNoId ? _self.thirdOrderNoId : thirdOrderNoId // ignore: cast_nullable_to_non_nullable
as String?,thirdOrderNo: freezed == thirdOrderNo ? _self.thirdOrderNo : thirdOrderNo // ignore: cast_nullable_to_non_nullable
as String?,packageOrderActivityId: freezed == packageOrderActivityId ? _self.packageOrderActivityId : packageOrderActivityId // ignore: cast_nullable_to_non_nullable
as String?,mainOrderInfoId: freezed == mainOrderInfoId ? _self.mainOrderInfoId : mainOrderInfoId // ignore: cast_nullable_to_non_nullable
as String?,ticketNo: freezed == ticketNo ? _self.ticketNo : ticketNo // ignore: cast_nullable_to_non_nullable
as String?,createBeginTime: freezed == createBeginTime ? _self.createBeginTime : createBeginTime // ignore: cast_nullable_to_non_nullable
as String?,createEndTime: freezed == createEndTime ? _self.createEndTime : createEndTime // ignore: cast_nullable_to_non_nullable
as String?,pageNum: null == pageNum ? _self.pageNum : pageNum // ignore: cast_nullable_to_non_nullable
as int,pageSize: null == pageSize ? _self.pageSize : pageSize // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$OrderState implements DiagnosticableTreeMixin {

 OrderListStatus get status; OrderSearchParams get searchParams; List<Order> get orders; int get pageNum; int get pageSize; int get total; String? get errorMessage;
/// Create a copy of OrderState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderStateCopyWith<OrderState> get copyWith => _$OrderStateCopyWithImpl<OrderState>(this as OrderState, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'OrderState'))
    ..add(DiagnosticsProperty('status', status))..add(DiagnosticsProperty('searchParams', searchParams))..add(DiagnosticsProperty('orders', orders))..add(DiagnosticsProperty('pageNum', pageNum))..add(DiagnosticsProperty('pageSize', pageSize))..add(DiagnosticsProperty('total', total))..add(DiagnosticsProperty('errorMessage', errorMessage));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderState&&(identical(other.status, status) || other.status == status)&&(identical(other.searchParams, searchParams) || other.searchParams == searchParams)&&const DeepCollectionEquality().equals(other.orders, orders)&&(identical(other.pageNum, pageNum) || other.pageNum == pageNum)&&(identical(other.pageSize, pageSize) || other.pageSize == pageSize)&&(identical(other.total, total) || other.total == total)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,status,searchParams,const DeepCollectionEquality().hash(orders),pageNum,pageSize,total,errorMessage);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'OrderState(status: $status, searchParams: $searchParams, orders: $orders, pageNum: $pageNum, pageSize: $pageSize, total: $total, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $OrderStateCopyWith<$Res>  {
  factory $OrderStateCopyWith(OrderState value, $Res Function(OrderState) _then) = _$OrderStateCopyWithImpl;
@useResult
$Res call({
 OrderListStatus status, OrderSearchParams searchParams, List<Order> orders, int pageNum, int pageSize, int total, String? errorMessage
});


$OrderSearchParamsCopyWith<$Res> get searchParams;

}
/// @nodoc
class _$OrderStateCopyWithImpl<$Res>
    implements $OrderStateCopyWith<$Res> {
  _$OrderStateCopyWithImpl(this._self, this._then);

  final OrderState _self;
  final $Res Function(OrderState) _then;

/// Create a copy of OrderState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? searchParams = null,Object? orders = null,Object? pageNum = null,Object? pageSize = null,Object? total = null,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as OrderListStatus,searchParams: null == searchParams ? _self.searchParams : searchParams // ignore: cast_nullable_to_non_nullable
as OrderSearchParams,orders: null == orders ? _self.orders : orders // ignore: cast_nullable_to_non_nullable
as List<Order>,pageNum: null == pageNum ? _self.pageNum : pageNum // ignore: cast_nullable_to_non_nullable
as int,pageSize: null == pageSize ? _self.pageSize : pageSize // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of OrderState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrderSearchParamsCopyWith<$Res> get searchParams {
  
  return $OrderSearchParamsCopyWith<$Res>(_self.searchParams, (value) {
    return _then(_self.copyWith(searchParams: value));
  });
}
}


/// Adds pattern-matching-related methods to [OrderState].
extension OrderStatePatterns on OrderState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrderState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrderState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrderState value)  $default,){
final _that = this;
switch (_that) {
case _OrderState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrderState value)?  $default,){
final _that = this;
switch (_that) {
case _OrderState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( OrderListStatus status,  OrderSearchParams searchParams,  List<Order> orders,  int pageNum,  int pageSize,  int total,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrderState() when $default != null:
return $default(_that.status,_that.searchParams,_that.orders,_that.pageNum,_that.pageSize,_that.total,_that.errorMessage);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( OrderListStatus status,  OrderSearchParams searchParams,  List<Order> orders,  int pageNum,  int pageSize,  int total,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _OrderState():
return $default(_that.status,_that.searchParams,_that.orders,_that.pageNum,_that.pageSize,_that.total,_that.errorMessage);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( OrderListStatus status,  OrderSearchParams searchParams,  List<Order> orders,  int pageNum,  int pageSize,  int total,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _OrderState() when $default != null:
return $default(_that.status,_that.searchParams,_that.orders,_that.pageNum,_that.pageSize,_that.total,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _OrderState with DiagnosticableTreeMixin implements OrderState {
  const _OrderState({this.status = OrderListStatus.initial, this.searchParams = const OrderSearchParams(pageSize: 30, pageNum: 1), final  List<Order> orders = const [], this.pageNum = 1, this.pageSize = 10, this.total = 0, this.errorMessage}): _orders = orders;
  

@override@JsonKey() final  OrderListStatus status;
@override@JsonKey() final  OrderSearchParams searchParams;
 final  List<Order> _orders;
@override@JsonKey() List<Order> get orders {
  if (_orders is EqualUnmodifiableListView) return _orders;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_orders);
}

@override@JsonKey() final  int pageNum;
@override@JsonKey() final  int pageSize;
@override@JsonKey() final  int total;
@override final  String? errorMessage;

/// Create a copy of OrderState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderStateCopyWith<_OrderState> get copyWith => __$OrderStateCopyWithImpl<_OrderState>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'OrderState'))
    ..add(DiagnosticsProperty('status', status))..add(DiagnosticsProperty('searchParams', searchParams))..add(DiagnosticsProperty('orders', orders))..add(DiagnosticsProperty('pageNum', pageNum))..add(DiagnosticsProperty('pageSize', pageSize))..add(DiagnosticsProperty('total', total))..add(DiagnosticsProperty('errorMessage', errorMessage));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderState&&(identical(other.status, status) || other.status == status)&&(identical(other.searchParams, searchParams) || other.searchParams == searchParams)&&const DeepCollectionEquality().equals(other._orders, _orders)&&(identical(other.pageNum, pageNum) || other.pageNum == pageNum)&&(identical(other.pageSize, pageSize) || other.pageSize == pageSize)&&(identical(other.total, total) || other.total == total)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,status,searchParams,const DeepCollectionEquality().hash(_orders),pageNum,pageSize,total,errorMessage);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'OrderState(status: $status, searchParams: $searchParams, orders: $orders, pageNum: $pageNum, pageSize: $pageSize, total: $total, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$OrderStateCopyWith<$Res> implements $OrderStateCopyWith<$Res> {
  factory _$OrderStateCopyWith(_OrderState value, $Res Function(_OrderState) _then) = __$OrderStateCopyWithImpl;
@override @useResult
$Res call({
 OrderListStatus status, OrderSearchParams searchParams, List<Order> orders, int pageNum, int pageSize, int total, String? errorMessage
});


@override $OrderSearchParamsCopyWith<$Res> get searchParams;

}
/// @nodoc
class __$OrderStateCopyWithImpl<$Res>
    implements _$OrderStateCopyWith<$Res> {
  __$OrderStateCopyWithImpl(this._self, this._then);

  final _OrderState _self;
  final $Res Function(_OrderState) _then;

/// Create a copy of OrderState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? searchParams = null,Object? orders = null,Object? pageNum = null,Object? pageSize = null,Object? total = null,Object? errorMessage = freezed,}) {
  return _then(_OrderState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as OrderListStatus,searchParams: null == searchParams ? _self.searchParams : searchParams // ignore: cast_nullable_to_non_nullable
as OrderSearchParams,orders: null == orders ? _self._orders : orders // ignore: cast_nullable_to_non_nullable
as List<Order>,pageNum: null == pageNum ? _self.pageNum : pageNum // ignore: cast_nullable_to_non_nullable
as int,pageSize: null == pageSize ? _self.pageSize : pageSize // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of OrderState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrderSearchParamsCopyWith<$Res> get searchParams {
  
  return $OrderSearchParamsCopyWith<$Res>(_self.searchParams, (value) {
    return _then(_self.copyWith(searchParams: value));
  });
}
}

// dart format on
