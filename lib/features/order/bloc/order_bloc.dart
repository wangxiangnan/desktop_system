import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:desktop_system/core/result/result.dart';
import 'package:desktop_system/domain/usecases/order_usecase.dart';
import 'order_event.dart';
import 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderUsecase _orderUsecase;

  OrderBloc({required OrderUsecase orderUsecase})
      : _orderUsecase = orderUsecase,
        super(const OrderState()) {
    on<OrderSearchParamsChanged>(_onSearchParamsChanged);
    on<OrderSearchSubmitted>(_onSearchSubmitted);
    on<OrderPageChanged>(_onPageChanged);
    on<OrderReset>(_onReset);
  }

  void _onSearchParamsChanged(
    OrderSearchParamsChanged event,
    Emitter<OrderState> emit,
  ) {
    emit(state.copyWith(
      searchParams: state.searchParams.copyWith(
        orderInfoId: event.searchParams.orderInfoId,
        thirdOrderNoId: event.searchParams.thirdOrderNoId,
        thirdOrderNo: event.searchParams.thirdOrderNo,
        packageOrderActivityId: event.searchParams.packageOrderActivityId,
        mainOrderInfoId: event.searchParams.mainOrderInfoId,
        ticketNo: event.searchParams.ticketNo,
        createBeginTime: event.searchParams.createBeginTime,
        createEndTime: event.searchParams.createEndTime,
      ),
    ));
  }

  Future<void> _onSearchSubmitted(
    OrderSearchSubmitted event,
    Emitter<OrderState> emit,
  ) async {
    final params = state.searchParams.copyWith(pageNum: 1);
    await _fetchOrders(params, emit);
  }

  Future<void> _onPageChanged(
    OrderPageChanged event,
    Emitter<OrderState> emit,
  ) async {
    final params = state.searchParams.copyWith(
      pageNum: event.pageNum,
      pageSize: event.pageSize,
    );
    await _fetchOrders(params, emit);
  }

  Future<void> _fetchOrders(
    OrderSearchParams params,
    Emitter<OrderState> emit,
  ) async {
    emit(state.copyWith(
      status: OrderListStatus.loading,
      searchParams: params,
    ));

    try {
      final result = await _orderUsecase.getOrders(params.toJson());
      emit(state.copyWith(
        status: OrderListStatus.success,
        orders: result.rows,
        total: result.total,
        totalPages: result.totalPages,
        searchParams: params.copyWith(
          pageNum: result.pageNum,
          pageSize: result.pageSize,
        ),
      ));
    } on AppError catch (e) {
      emit(state.copyWith(
        status: OrderListStatus.failure,
        errorMessage: e.message,
      ));
    }
  }

  void _onReset(
    OrderReset event,
    Emitter<OrderState> emit,
  ) {
    emit(const OrderState());
  }
}
