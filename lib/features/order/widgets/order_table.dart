import 'package:flutter/material.dart';

import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import 'package:desktop_system/domain/entities/order_entity.dart';
import 'package:desktop_system/core/constants/app_colors.dart';
import 'package:desktop_system/core/utils/money_calculator.dart';

class OrderTable extends StatefulWidget {
  final List<Order> orders;
  final int pageNum;
  final int pageSize;
  final int total;
  final double totalPages;
  final void Function(int pageNum, int pageSize) onPageChanged;
  final Map<String, Map<String, String>> dicts;

  const OrderTable({
    super.key,
    required this.orders,
    required this.pageNum,
    required this.pageSize,
    required this.total,
    required this.totalPages,
    required this.onPageChanged,
    this.dicts = const {},
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
    _orderDataSource = OrderDataSource(widget.orders, widget.dicts);
  }

  @override
  void didUpdateWidget(OrderTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    _orderDataSource.updateOrders(widget.orders, widget.dicts);
  }

  Widget _buildDataGrid() {
    return SfDataGrid(
      source: _orderDataSource,
      columnWidthMode: ColumnWidthMode.auto,
      defaultColumnWidth: 120,
      headerRowHeight: 50,
      rowsPerPage: widget.pageSize,
      columns: [
        GridColumn(label: Center(child: Text('订单ID')), columnName: 'id'),
        GridColumn(label: Center(child: Text('项目ID')), columnName: 'performanceId'),
        GridColumn(label: Center(child: Text('项目名称')), columnName: 'performanceName'),
        GridColumn(label: Center(child: Text('场次名称')), columnName: 'showName'),
        GridColumn(label: Center(child: Text('订单来源')), columnName: 'channelType'),
        GridColumn(label: Center(child: Text('订单金额')), columnName: 'amount'),
        GridColumn(label: Center(child: Text('支付方式')), columnName: 'paymentType'),
        GridColumn(label: Center(child: Text('支付状态')), columnName: 'paymentStatus'),
        GridColumn(label: Center(child: Text('销售政策')), columnName: 'discountPolicyName'),
        GridColumn(label: Center(child: Text('退款状态')), columnName: 'refundStatus'),
        GridColumn(label: Center(child: Text('购票数量')), columnName: 'num'),
        GridColumn(label: Center(child: Text('出票方式')), columnName: 'drawOutType'),
        GridColumn(label: Center(child: Text('出票状态')), columnName: 'drawOutStatus'),
        GridColumn(label: Center(child: Text('检票数')), columnName: 'checkUpNum'),
        GridColumn(label: Center(child: Text('开发票')), columnName: 'invoiceStatus'),
        GridColumn(label: Center(child: Text('购票人姓名')), columnName: 'customerName'),
        GridColumn(label: Center(child: Text('购票人手机号')), columnName: 'customerPhone'),
        GridColumn(label: Center(child: Text('邀请函code/套票关联ID')), columnName: 'mainOrderInfoId'),
        GridColumn(label: Center(child: Text('套票活动ID')), columnName: 'packageOrderActivityId'),
        GridColumn(label: Center(child: Text('售票网点机构')), columnName: 'ticketOutletName'),
        GridColumn(label: Center(child: Text('主办方')), columnName: 'organizerName'),
        GridColumn(label: Center(child: Text('订单创建时间')), columnName: 'createTime'),
        GridColumn(label: Center(child: Text('支付完成时间')), columnName: 'paymentTime'),
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
  OrderDataSource (List<Order> orders, [Map<String, Map<String, String>> dicts = const {}]) {
    updateOrders(orders, dicts);
  }

  List<DataGridRow> _orders = [];

  void updateOrders(List<Order> orders, [Map<String, Map<String, String>> dicts = const {}]) {
    _orders = orders
      .map<DataGridRow>((e) =>
        DataGridRow(
          cells: [
            DataGridCell(columnName: 'id', value: e.id),
            DataGridCell(columnName: 'performanceId', value: e.performanceId),
            DataGridCell(columnName: 'performanceName', value: e.performanceName),
            DataGridCell(columnName: 'showName', value: e.showName),
            DataGridCell(columnName: 'channelType', value: _label(dicts, 'ctms_channel_type', e.channelType)),
            DataGridCell(columnName: 'amount', value: MoneyCalculator.centsToYuan(e.amount)),
            DataGridCell(columnName: 'paymentType', value: _label(dicts, 'ctms_payment_type', e.paymentType)),
            DataGridCell(columnName: 'paymentStatus', value: _label(dicts, 'payment_status', e.paymentStatus)),
            DataGridCell(columnName: 'discountPolicyName', value: e.discountPolicyName),
            DataGridCell(columnName: 'refundStatus', value: _label(dicts, 'ctms_refund_status', e.refundStatus)),
            DataGridCell(columnName: 'num', value: e.num.toString()),
            DataGridCell(columnName: 'drawOutType', value: _label(dicts, 'ctms_print_type', e.drawOutType)),
            DataGridCell(columnName: 'drawOutStatus', value: _label(dicts, 'ctms_draw_out_status', e.drawOutStatus)),
            DataGridCell(columnName: 'checkUpNum', value: e.checkUpNum.toString()),
            DataGridCell(columnName: 'invoiceStatus', value: _label(dicts, 'invoice_status', e.invoiceStatus)),
            DataGridCell(columnName: 'customerName', value: e.customerName),
            DataGridCell(columnName: 'customerPhone', value: e.customerPhone),
            DataGridCell(columnName: 'mainOrderInfoId', value: e.mainOrderInfoId),
            DataGridCell(columnName: 'packageOrderActivityId', value: e.packageOrderActivityId),
            DataGridCell(columnName: 'ticketOutletName', value: e.ticketOutletName),
            DataGridCell(columnName: 'organizerName', value: e.organizerName),
            DataGridCell(columnName: 'createTime', value: e.createTime),
            DataGridCell(columnName: 'paymentTime', value: e.paymentTime),
            DataGridCell(columnName: 'drawOutControl', value: e.drawOutControl ? '是' : '否'),
        ]))
      .toList();
  }

  String _label(Map<String, Map<String, String>> dicts, String dictId, String value) {
    return dicts[dictId]?[value] ?? value;
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
