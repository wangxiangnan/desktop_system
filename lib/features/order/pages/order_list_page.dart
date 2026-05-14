import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:desktop_system/core/di/setup_dependencies.dart';
import 'package:desktop_system/domain/entities/order_entity.dart';
import 'package:desktop_system/domain/usecases/order_usecase.dart';
import '../bloc/order_bloc.dart';
import '../bloc/order_event.dart';
import '../bloc/order_state.dart';
import '../widgets/widgets.dart';

class OrderDataSource extends DataTableSource {
  final List<Order> orders;

  OrderDataSource(this.orders);

  @override
  DataRow? getRow(int index) {
    if (index >= orders.length) return null;
    final order = orders[index];
    return DataRow(
      cells: [
        DataCell(Text(order.id)),
        DataCell(Text(order.channelType)),
        DataCell(Text(order.amount.toStringAsFixed(2))),
        DataCell(Text(order.num.toString())),
        DataCell(Text(order.checkUpNum.toString())),
        DataCell(Text(order.paymentType)),
        DataCell(Text(order.paymentStatus)),
        DataCell(Text(order.refundStatus)),
        DataCell(Text(order.drawOutType)),
        DataCell(Text(order.drawOutStatus)),
        DataCell(Text(order.invoiceStatus)),
        DataCell(Text(order.customerName)),
        DataCell(Text(order.customerPhone)),
        DataCell(Text(order.mainOrderInfoId)),
        DataCell(Text(order.organizerName)),
        DataCell(Text(order.packageOrderActivityId)),
        DataCell(Text(order.ticketOutletName)),
        DataCell(Text(order.createTime)),
        DataCell(Text(order.paymentTime)),
        DataCell(Text(order.performanceId)),
        DataCell(Text(order.performanceName)),
        DataCell(Text(order.showName)),
        DataCell(Text(order.discountPolicyName)),
        DataCell(Text(order.drawOutControl ? '是' : '否')),
        DataCell(Text(order.date.toString().substring(0, 10))),
        DataCell(Text(order.location)),
        DataCell(Text(order.price.toStringAsFixed(2))),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => orders.length;

  @override
  int get selectedRowCount => 0;
}

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
    return OrderSearchParams(
      orderInfoId: _controller('orderInfoId').text,
      thirdOrderNoId: _controller('thirdOrderNoId').text,
      packageOrderActivityId: _controller('packageOrderActivityId').text,
      mainOrderInfoId: _controller('mainOrderInfoId').text,
      ticketNo: _controller('ticketNo').text,
      createBeginTime: _controller('createBeginTime').text,
      createEndTime: _controller('createEndTime').text,
      pageSize: 30,
      pageNum: 1
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
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('订单列表')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
            const SizedBox(height: 16),
            Expanded(child: _buildTable()),
          ],
        ),
      ),
    );
  }

  Widget _buildTable() {
    return BlocBuilder<OrderBloc, OrderState>(
      builder: (context, state) {
        if (state.status == OrderListStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.status == OrderListStatus.failure) {
          return Center(
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
          );
        }

        return OrderTable(
          orders: state.orders,
        );
        
        
        /* PaginatedDataTable(
            header: Text('共 ${state.total} 条记录'),
            columns: const [
              DataColumn(label: Text('订单ID')),
              DataColumn(label: Text('渠道类型')),
              DataColumn(label: Text('金额')),
              DataColumn(label: Text('数量')),
              DataColumn(label: Text('核销数量')),
              DataColumn(label: Text('支付方式')),
              DataColumn(label: Text('支付状态')),
              DataColumn(label: Text('退款状态')),
              DataColumn(label: Text('出票类型')),
              DataColumn(label: Text('出票状态')),
              DataColumn(label: Text('发票状态')),
              DataColumn(label: Text('客户名称')),
              DataColumn(label: Text('客户电话')),
              DataColumn(label: Text('邀请函code')),
              DataColumn(label: Text('主办方')),
              DataColumn(label: Text('套票活动ID')),
              DataColumn(label: Text('售票点')),
              DataColumn(label: Text('创建时间')),
              DataColumn(label: Text('支付时间')),
              DataColumn(label: Text('演出ID')),
              DataColumn(label: Text('演出名称')),
              DataColumn(label: Text('场次名称')),
              DataColumn(label: Text('优惠策略')),
              DataColumn(label: Text('出票控制')),
              DataColumn(label: Text('日期')),
              DataColumn(label: Text('地点')),
              DataColumn(label: Text('票价')),
            ],
            source: OrderDataSource(state.orders),
            rowsPerPage: state.pageSize,
            onPageChanged: (page) {
              context.read<OrderBloc>().add(OrderPageChanged(page + 1));
            },
            showEmptyRows: false,
          ); */
      },
    );
  }
}
