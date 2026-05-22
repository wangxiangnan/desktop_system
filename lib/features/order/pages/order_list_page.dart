import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:desktop_system/core/di/setup_dependencies.dart';
import 'package:desktop_system/core/widgets/dict_builder.dart';
import 'package:desktop_system/domain/usecases/order_usecase.dart';
import '../bloc/order_bloc.dart';
import '../bloc/order_event.dart';
import '../bloc/order_state.dart';
import '../widgets/widgets.dart';

class OrderListPage extends StatelessWidget {
  const OrderListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OrderBloc(orderUsecase: getIt<OrderUsecase>()),
      child: const _OrderListView(),
    );
  }
}

class _OrderListView extends StatefulWidget {
  const _OrderListView();

  @override
  State<_OrderListView> createState() => _OrderListViewState();
}

class _OrderListViewState extends State<_OrderListView> {
  final _controllers = <String, TextEditingController>{};
  List<int>? _calendarValue;
  int _calendarKey = 0;

  TextEditingController _controller(String field) {
    return _controllers.putIfAbsent(field, () => TextEditingController());
  }

  void _onSearch() {
    context.read<OrderBloc>().add(const OrderSearchSubmitted());
  }

  OrderSearchParams _buildSearchParams() {
    final orderInfoId = _controller('orderInfoId').text;
    final thirdOrderNoId = _controller('thirdOrderNoId').text;
    final thirdOrderNo = _controller('thirdOrderNo').text;
    final packageOrderActivityId = _controller('packageOrderActivityId').text;
    final mainOrderInfoId = _controller('mainOrderInfoId').text;
    final ticketNo = _controller('ticketNo').text;
    final createBeginTime = _controller('createBeginTime').text;
    final createEndTime = _controller('createEndTime').text;
    return OrderSearchParams(
      orderInfoId: orderInfoId.isNotEmpty ? orderInfoId : null,
      thirdOrderNoId: thirdOrderNoId.isNotEmpty ? thirdOrderNoId : null,
      thirdOrderNo: thirdOrderNo.isNotEmpty ? thirdOrderNo : null,
      packageOrderActivityId: packageOrderActivityId.isNotEmpty ? packageOrderActivityId : null,
      mainOrderInfoId: mainOrderInfoId.isNotEmpty ? mainOrderInfoId : null,
      ticketNo: ticketNo.isNotEmpty ? ticketNo : null,
      createBeginTime: createBeginTime.isNotEmpty ? createBeginTime : null,
      createEndTime: createEndTime.isNotEmpty ? createEndTime : null,
    );
  }

  void _onUpdateParams() {
    final params = _buildSearchParams();
    context.read<OrderBloc>().add(OrderSearchParamsChanged(params));
  }

  void _onReset() {
    for (final c in _controllers.values) {
      c.clear();
    }
    setState(() {
      _calendarValue = null;
    });
    _calendarKey++;
    context.read<OrderBloc>().add(const OrderReset());
  }

  void _onCalendarConfirm(List<int> value) {
    setState(() {
      _calendarValue = value;
    });
    if (value.length == 2) {
      _controller('createBeginTime').text =
          DateTime.fromMillisecondsSinceEpoch(value[0]).toString().substring(0, 19);
      _controller('createEndTime').text =
          DateTime.fromMillisecondsSinceEpoch(value[1]).toString().substring(0, 19);
    }
    _onUpdateParams();
  }

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    final begin = DateTime.now().subtract(Duration(days: 20));
    final end = DateTime(now.year, now.month, now.day, 23, 59, 59);
    _calendarValue = [begin.millisecondsSinceEpoch, end.millisecondsSinceEpoch];
    _controller('createBeginTime').text = begin.toString().substring(0, 19);
    _controller('createEndTime').text = end.toString().substring(0, 19);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _onUpdateParams();
    });
  }

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DictBuilder(
      dictIds: ['ctms_channel_type', 'ctms_payment_type', 'payment_status', 'ctms_refund_status', 'ctms_print_type', 'ctms_draw_out_status', 'invoice_status'],
      builder: (context, dicts, state) {
        return Scaffold(
          // appBar: AppBar(title: const Text('订单列表')),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                SearchForm(
                  key: ValueKey(_calendarKey),
                  onSearch: _onSearch,
                  onReset: _onReset,
                  onUpdateParams: _onUpdateParams,
                  controller: _controller,
                  calendarValue: _calendarValue,
                  onCalendarConfirm: _onCalendarConfirm,
                ),
                Expanded(child: _buildTable(dicts)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTable(Map<String, Map<String, String>> dicts) {
    return BlocBuilder<OrderBloc, OrderState>(
      builder: (context, state) {
        return Stack(
          children: [
            OrderTable(
              orders: state.orders,
              total: state.total,
              pageSize: state.searchParams.pageSize ?? 30,
              pageNum: state.searchParams.pageNum ?? 1,
              totalPages: state.totalPages,
              dicts: dicts,
              onPageChanged: (pageNum, pageSize) {
                context.read<OrderBloc>().add(OrderPageChanged(pageNum, pageSize));
              },
            ),
            if (state.status == OrderListStatus.loading)
              const Center(child: CircularProgressIndicator()),
            if (state.status == OrderListStatus.failure)
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      state.errorMessage ?? '加载失败',
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(onPressed: _onSearch, child: const Text('重试')),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}
