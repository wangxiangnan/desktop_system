import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:desktop_system/domain/entities/order_entity.dart';


class OrderTable extends StatelessWidget {
  final List<Order> orders;
  final int pageNum;
  final int pageSize;
  final int total;

  const OrderTable({
    super.key,
    required this.orders,
    required this.pageNum,
    required this.pageSize,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return PaginatedDataTable2(
      columns: const [
        DataColumn2(label: Text('订单ID'), minWidth: 120),
        DataColumn2(label: Text('渠道类型'), minWidth: 120),
        DataColumn2(label: Text('金额'), minWidth: 120),
        DataColumn2(label: Text('数量'), minWidth: 120),
        DataColumn2(label: Text('核销数量'), minWidth: 120),
        DataColumn2(label: Text('支付方式'), minWidth: 120),
        DataColumn2(label: Text('支付状态'), minWidth: 120),
        DataColumn2(label: Text('退款状态'), minWidth: 120),
        DataColumn2(label: Text('出票类型'), minWidth: 120),
        DataColumn2(label: Text('出票状态'), minWidth: 120),
        DataColumn2(label: Text('发票状态'), minWidth: 120),
        DataColumn2(label: Text('客户名称'), minWidth: 120),
        DataColumn2(label: Text('客户电话'), minWidth: 120),
        DataColumn2(label: Text('邀请函code'), minWidth: 120),
        DataColumn2(label: Text('主办方'), minWidth: 120),
        DataColumn2(label: Text('套票活动ID'), minWidth: 120),
        DataColumn2(label: Text('售票点'), minWidth: 120),
        DataColumn2(label: Text('创建时间'), minWidth: 120),
        DataColumn2(label: Text('支付时间'), minWidth: 120),
        DataColumn2(label: Text('演出ID'), minWidth: 120),
        DataColumn2(label: Text('演出名称'), minWidth: 180),
        DataColumn2(label: Text('场次名称'), minWidth: 220),
        DataColumn2(label: Text('优惠策略'), minWidth: 120),
        DataColumn2(label: Text('出票控制'), minWidth: 120),
        DataColumn2(label: Text('日期'), minWidth: 180),
        DataColumn2(label: Text('地点'), minWidth: 120),
        DataColumn2(label: Text('票价'), minWidth: 120),
      ],
      source: OrderDataSource(orders, total),
      rowsPerPage: pageSize,
      onPageChanged: (page) {
        // context.read<OrderBloc>().add(OrderPageChanged(page + 1));
      },
    );
    
  }
}

class OrderDataSource extends DataTableSource {
  final List<Order> orders;
  final int total;

  OrderDataSource(this.orders, this.total);

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
  int get rowCount => total;

  @override
  int get selectedRowCount => 0;
}