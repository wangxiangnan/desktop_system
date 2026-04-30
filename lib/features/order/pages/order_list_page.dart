import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:desktop_system/core/di/setup_dependencies.dart';
import 'package:desktop_system/domain/entities/order_entity.dart';
import 'package:desktop_system/domain/usecases/order_usecase.dart';
import '../bloc/order_bloc.dart';
import '../bloc/order_event.dart';
import '../bloc/order_state.dart';

class OrderDataSource extends DataTableSource {
  final List<Order> orders;

  OrderDataSource(this.orders);

  @override
  DataRow? getRow(int index) {
    if (index >= orders.length) return null;
    final order = orders[index];
    return DataRow(cells: [
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
    ]);
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
  final _formKey = GlobalKey<FormState>();
  final _controllers = <String, TextEditingController>{};

  TextEditingController _controller(String key) {
    return _controllers.putIfAbsent(key, () => TextEditingController());
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
    );
  }

  void _onSearch() {
    final params = _buildSearchParams();
    context.read<OrderBloc>().add(OrderSearchParamsChanged(params));
    context.read<OrderBloc>().add(const OrderSearchSubmitted());
  }

  void _onReset() {
    for (final c in _controllers.values) {
      c.clear();
    }
    context.read<OrderBloc>().add(const OrderReset());
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
            _buildSearchForm(context),
            const SizedBox(height: 16),
            Expanded(child: _buildTable(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchForm(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 16,
                runSpacing: 12,
                children: [
                  SizedBox(
                    width: 200,
                    child: TextFormField(
                      controller: _controller('orderInfoId'),
                      decoration: const InputDecoration(
                        labelText: '订单ID',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 200,
                    child: TextFormField(
                      controller: _controller('thirdOrderNoId'),
                      decoration: const InputDecoration(
                        labelText: '项目ID',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 200,
                    child: TextFormField(
                      controller: _controller('packageOrderActivityId'),
                      decoration: const InputDecoration(
                        labelText: '套票活动ID',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 200,
                    child: TextFormField(
                      controller: _controller('mainOrderInfoId'),
                      decoration: const InputDecoration(
                        labelText: '邀请函code',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 200,
                    child: TextFormField(
                      controller: _controller('ticketNo'),
                      decoration: const InputDecoration(
                        labelText: '票号',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 200,
                    child: TextFormField(
                      controller: _controller('createBeginTime'),
                      decoration: const InputDecoration(
                        labelText: '创建开始时间',
                        hintText: 'YYYY-MM-DD',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 200,
                    child: TextFormField(
                      controller: _controller('createEndTime'),
                      decoration: const InputDecoration(
                        labelText: '创建结束时间',
                        hintText: 'YYYY-MM-DD',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: _onSearch,
                    child: const Text('查询'),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton(
                    onPressed: _onReset,
                    child: const Text('重置'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTable(BuildContext context) {
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
                Text(state.errorMessage ?? '加载失败',
                    style: const TextStyle(color: Colors.red)),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: _onSearch,
                  child: const Text('重试'),
                ),
              ],
            ),
          );
        }

        return Card(
          child: PaginatedDataTable(
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
            ),
        );
      },
    );
  }
}
