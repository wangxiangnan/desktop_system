import 'package:flutter/material.dart';

import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import 'package:desktop_system/domain/entities/order_entity.dart';
import 'package:desktop_system/core/constants/app_colors.dart';

class OrderTable extends StatefulWidget {
  final List<Order> orders;
  final int pageNum;
  final int pageSize;
  final int total;
  final double totalPages;
  final void Function(int pageNum, int pageSize) onPageChanged;

  const OrderTable({
    super.key,
    required this.orders,
    required this.pageNum,
    required this.pageSize,
    required this.total,
    required this.totalPages,
    required this.onPageChanged,
  });

  @override
  State<StatefulWidget> createState() => _OrderTableState();
}

class _OrderTableState extends State<OrderTable> {

  late OrderDataSource _orderDataSource;
  static const double _dataPagerHeight = 60;

  @override
  void initState() {
    super.initState();
    _orderDataSource = OrderDataSource(widget.orders);
  }

  @override
  void didUpdateWidget(OrderTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    _orderDataSource.updateOrders(widget.orders);
  }

  Widget _buildDataGrid() {
    return SfDataGrid(
      source: _orderDataSource,
      columnWidthMode: ColumnWidthMode.auto,
      defaultColumnWidth: 120,
      headerRowHeight: 40,
      rowsPerPage: widget.pageSize,
      columns: [
        GridColumn(label: Center(child: Text('订单ID')), columnName: 'id'),
        GridColumn(label: Center(child: Text('渠道类型')), columnName: 'channelType'),
        GridColumn(label: Center(child: Text('金额')), columnName: 'amount'),
        GridColumn(label: Center(child: Text('数量')), columnName: 'num'),
        GridColumn(label: Center(child: Text('核销数量')), columnName: 'checkUpNum'),
        GridColumn(label: Center(child: Text('支付方式')), columnName: 'paymentType'),
        GridColumn(label: Center(child: Text('支付状态')), columnName: 'paymentStatus'),
        GridColumn(label: Center(child: Text('退款状态')), columnName: 'refundStatus'),
        GridColumn(label: Center(child: Text('出票类型')), columnName: 'drawOutType'),
        GridColumn(label: Center(child: Text('出票状态')), columnName: 'drawOutStatus'),
        GridColumn(label: Center(child: Text('发票状态')), columnName: 'invoiceStatus'),
        GridColumn(label: Center(child: Text('客户名称')), columnName: 'customerName'),
        GridColumn(label: Center(child: Text('客户电话')), columnName: 'customerPhone'),
        GridColumn(label: Center(child: Text('邀请函code')), columnName: 'mainOrderInfoId'),
        GridColumn(label: Center(child: Text('主办方')), columnName: 'organizerName'),
        GridColumn(label: Center(child: Text('套票活动ID')), columnName: 'packageOrderActivityId'),
        GridColumn(label: Center(child: Text('售票点')), columnName: 'ticketOutletName'),
        GridColumn(label: Center(child: Text('创建时间')), columnName: 'createTime'),
        GridColumn(label: Center(child: Text('支付时间')), columnName: 'paymentTime'),
        GridColumn(label: Center(child: Text('演出ID')), columnName: 'performanceId'),
        GridColumn(label: Center(child: Text('演出名称')), columnName: 'performanceName'),
        GridColumn(label: Center(child: Text('场次名称')), columnName: 'showName'),
        GridColumn(label: Center(child: Text('优惠策略')), columnName: 'discountPolicyName'),
        GridColumn(label: Center(child: Text('出票控制')), columnName: 'drawOutControl'),
      ]
    );
  }

  Widget _buildDataPager() {
    return SfDataPagerTheme(
      data: SfDataPagerThemeData(selectedItemColor: AppColors.primary),
      child: SfDataPager(
        initialPageIndex: widget.pageNum - 1,
        delegate: _orderDataSource,
        availableRowsPerPage: const <int>[30, 50, 100],
        pageCount: widget.totalPages,
        onPageNavigationEnd: (pageIndex) {
          final targetPageNum = pageIndex + 1;
          if (targetPageNum != widget.pageNum) {
            widget.onPageChanged(targetPageNum, widget.pageSize);
          }
        },
        onRowsPerPageChanged: (int? rowsPerPage) {
          if (rowsPerPage != widget.pageSize) {
            widget.onPageChanged(1, rowsPerPage!);
          }
        },
      ),
    );
  }

  Widget _buildLayoutBuilder() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            SizedBox(
              width: constraints.maxWidth,
              height: widget.total > 0 ? constraints.maxHeight - _dataPagerHeight : constraints.maxHeight,
              child: _buildDataGrid(),
            ),
            if (widget.total > 0)
              SizedBox(
                width: constraints.maxWidth,
                height: _dataPagerHeight,
                child: _buildDataPager(),
              )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildLayoutBuilder();
  }
}
class OrderDataSource extends DataGridSource {
  OrderDataSource (List<Order> orders) {
    updateOrders(orders);
  }

  List<DataGridRow> _orders = [];

  void updateOrders(List<Order> orders) {
    _orders = orders
      .map<DataGridRow>((e) =>
        DataGridRow(
          cells: [
            DataGridCell(columnName: 'id', value: e.id),
            DataGridCell(columnName: 'channelType', value: e.channelType),
            DataGridCell(columnName: 'amount', value: e.amount.toStringAsFixed(2)),
            DataGridCell(columnName: 'num', value: e.num.toString()),
            DataGridCell(columnName: 'checkUpNum', value: e.checkUpNum.toString()),
            DataGridCell(columnName: 'paymentType', value: e.paymentType),
            DataGridCell(columnName: 'paymentStatus', value: e.paymentStatus),
            DataGridCell(columnName: 'refundStatus', value: e.refundStatus),
            DataGridCell(columnName: 'drawOutType', value: e.drawOutType),
            DataGridCell(columnName: 'drawOutStatus', value: e.drawOutStatus),
            DataGridCell(columnName: 'invoiceStatus', value: e.invoiceStatus),
            DataGridCell(columnName: 'customerName', value: e.customerName),
            DataGridCell(columnName: 'customerPhone', value: e.customerPhone),
            DataGridCell(columnName: 'mainOrderInfoId', value: e.mainOrderInfoId),
            DataGridCell(columnName: 'organizerName', value: e.organizerName),
            DataGridCell(columnName: 'packageOrderActivityId', value: e.packageOrderActivityId),
            DataGridCell(columnName: 'ticketOutletName', value: e.ticketOutletName),
            DataGridCell(columnName: 'createTime', value: e.createTime),
            DataGridCell(columnName: 'paymentTime', value: e.paymentTime),
            DataGridCell(columnName: 'performanceId', value: e.performanceId),
            DataGridCell(columnName: 'performanceName', value: e.performanceName),
            DataGridCell(columnName: 'showName', value: e.showName),
            DataGridCell(columnName: 'discountPolicyName', value: e.discountPolicyName),
            DataGridCell(columnName: 'drawOutControl', value: e.drawOutControl ? '是' : '否'),
        ]))
      .toList();
    // notifyListeners();
  }

  @override
  List<DataGridRow> get rows => _orders;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map((dataGridCell) {
        return Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(6.0),
          child: Text(dataGridCell.value?.toString() ?? ''),
        );
      }).toList(),
    );
  }
}