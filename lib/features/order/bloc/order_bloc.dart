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
    emit(state.copyWith(searchParams: event.searchParams));
  }

  Future<void> _onSearchSubmitted(
    OrderSearchSubmitted event,
    Emitter<OrderState> emit,
  ) async {
    emit(state.copyWith(status: OrderListStatus.loading, pageNum: 1));

    try {
      final result = await _orderUsecase.getOrders(
        pageNum: 1,
        pageSize: state.pageSize,
      );
      emit(state.copyWith(
        status: OrderListStatus.success,
        orders: result.rows,
        total: result.total,
        pageNum: result.pageNum,
      ));
    } on AppError catch (e) {
      emit(state.copyWith(
        status: OrderListStatus.failure,
        errorMessage: e.message,
      ));
    }
  }

  Future<void> _onPageChanged(
    OrderPageChanged event,
    Emitter<OrderState> emit,
  ) async {
    emit(state.copyWith(status: OrderListStatus.loading));

    try {
      final result = await _orderUsecase.getOrders(
        pageNum: event.pageNum,
        pageSize: state.pageSize,
      );
      emit(state.copyWith(
        status: OrderListStatus.success,
        orders: result.rows,
        total: result.total,
        pageNum: result.pageNum,
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
