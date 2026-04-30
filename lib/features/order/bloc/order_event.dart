import 'package:equatable/equatable.dart';
import 'order_state.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object?> get props => [];
}

class OrderSearchParamsChanged extends OrderEvent {
  final OrderSearchParams searchParams;

  const OrderSearchParamsChanged(this.searchParams);

  @override
  List<Object?> get props => [searchParams];
}

class OrderSearchSubmitted extends OrderEvent {
  const OrderSearchSubmitted();
}

class OrderPageChanged extends OrderEvent {
  final int pageNum;

  const OrderPageChanged(this.pageNum);

  @override
  List<Object?> get props => [pageNum];
}

class OrderReset extends OrderEvent {
  const OrderReset();
}
