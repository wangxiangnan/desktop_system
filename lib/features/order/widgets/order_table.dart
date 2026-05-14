import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:desktop_system/domain/entities/order_entity.dart';

class OrderTable extends StatelessWidget {
  final List<Order> orders;

  const OrderTable({
    super.key,
    required this.orders,
  });

  List<Map<String, String>> _buildDisplayData() {
    return orders.map((order) {
      return {
        'id': order.id,
        'channelType': order.channelType,
        'amount': '¥${order.amount.toStringAsFixed(2)}',
        'num': order.num.toString(),
        'checkUpNum': order.checkUpNum.toString(),
        'paymentType': order.paymentType,
        'paymentStatus': order.paymentStatus,
        'refundStatus': order.refundStatus,
        'drawOutType': order.drawOutType,
        'drawOutStatus': order.drawOutStatus,
        'invoiceStatus': order.invoiceStatus,
        'customerName': order.customerName,
        'customerPhone': order.customerPhone,
        'mainOrderInfoId': order.mainOrderInfoId,
        'organizerName': order.organizerName,
        'packageOrderActivityId': order.packageOrderActivityId,
        'ticketOutletName': order.ticketOutletName,
        'createTime': order.createTime,
        'paymentTime': order.paymentTime,
        'performanceId': order.performanceId,
        'performanceName': order.performanceName,
        'showName': order.showName,
        'discountPolicyName': order.discountPolicyName,
        'drawOutControl': order.drawOutControl ? '是' : '否',
        'date': order.date.toString().substring(0, 10),
        'location': order.location,
        'price': '¥${order.price.toStringAsFixed(2)}',
      };
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return TDTable(
          bordered: true,
          width: constraints.maxWidth,
          height: constraints.maxHeight - 40,
          columns: [
            TDTableCol(title: '订单ID', width: 160, colKey: 'id'),
            TDTableCol(title: '渠道类型', width: 100, colKey: 'channelType'),
            TDTableCol(title: '金额', width: 120, colKey: 'amount'),
            TDTableCol(title: '数量', width: 80, colKey: 'num'),
            TDTableCol(title: '核销数量', width: 100, colKey: 'checkUpNum'),
            TDTableCol(title: '支付方式', width: 100, colKey: 'paymentType'),
            TDTableCol(title: '支付状态', width: 100, colKey: 'paymentStatus'),
            TDTableCol(title: '退款状态', width: 100, colKey: 'refundStatus'),
            TDTableCol(title: '出票类型', width: 100, colKey: 'drawOutType'),
            TDTableCol(title: '出票状态', width: 100, colKey: 'drawOutStatus'),
            TDTableCol(title: '发票状态', width: 100, colKey: 'invoiceStatus'),
            TDTableCol(title: '客户名称', width: 120, colKey: 'customerName'),
            TDTableCol(title: '客户电话', width: 120, colKey: 'customerPhone'),
            TDTableCol(title: '邀请函code', width: 180, colKey: 'mainOrderInfoId'),
            TDTableCol(title: '主办方', width: 120, colKey: 'organizerName'),
            TDTableCol(title: '套票活动ID', width: 160, colKey: 'packageOrderActivityId'),
            TDTableCol(title: '售票点', width: 120, colKey: 'ticketOutletName'),
            TDTableCol(title: '创建时间', width: 160, colKey: 'createTime'),
            TDTableCol(title: '支付时间', width: 160, colKey: 'paymentTime'),
            TDTableCol(title: '演出ID', width: 160, colKey: 'performanceId'),
            TDTableCol(title: '演出名称', width: 160, colKey: 'performanceName'),
            TDTableCol(title: '场次名称', width: 160, colKey: 'showName'),
            TDTableCol(title: '优惠策略', width: 120, colKey: 'discountPolicyName'),
            TDTableCol(title: '出票控制', width: 100, colKey: 'drawOutControl'),
            TDTableCol(title: '日期', width: 120, colKey: 'date'),
            TDTableCol(title: '地点', width: 160, colKey: 'location'),
            TDTableCol(title: '票价', width: 100, colKey: 'price'),
          ],
          data: _buildDisplayData(),
        );
      },
    );
  }
}