

import 'package:desktop_system/core/network/dio_client.dart';
import '../../models/order_model.dart';
import 'package:desktop_system/core/models/paginated.dart';

const _orderBasePath = '/api/orders/v1/auth/orders/info';

class OrderRemoteDataSource {
  final DioClient _dioClient;

  OrderRemoteDataSource(this._dioClient);

  Future<Paginated<OrderModel>> getOrders(Map<String, Object?> params) async {
    final response = await _dioClient.post(
      '$_orderBasePath/listPage',
      data: params,
    );
    final data = response.data['data'] as Map<String, dynamic>?;
    final List<dynamic> ordersJson = data?['rows'] ?? [];
    final orders = ordersJson
        .map((json) => OrderModel.fromJson(json as Map<String, dynamic>))
        .toList();

    return Paginated<OrderModel>(
      rows: orders,
      total: data?['total'] ?? 0,
      pageNum: data?['currentPage'] ?? params['pageNum'],
      pageSize: data?['pageSize'] ?? params['pageSize'],
    );
  }
}