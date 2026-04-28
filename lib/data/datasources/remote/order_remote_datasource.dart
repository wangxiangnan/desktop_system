

import 'package:desktop_system/core/network/dio_client.dart';
import '../../models/order_model.dart';
import 'package:desktop_system/core/models/paginated.dart';

const _orderBasePath = '/api/order/v1/auth/performance/infoMain';

class OrderRemoteDataSource {
  final DioClient _dioClient;

  OrderRemoteDataSource(this._dioClient);

  Future<Paginated<OrderModel>> getOrders({int pageNum = 1, int pageSize = 10}) async {
    final response = await _dioClient.get(
      '$_orderBasePath/listPage',
      queryParameters: {'pageNum': pageNum, 'pageSize': pageSize},
    );
    final data = response.data['data'] as Map<String, dynamic>?;
    final List<dynamic> ordersJson = data?['rows'] ?? [];
    final orders = ordersJson
        .map((json) => OrderModel.fromJson(json as Map<String, dynamic>))
        .toList();

    return Paginated<OrderModel>(
      rows: orders,
      total: data?['total'] ?? 0,
      pageNum: data?['pageNum'] ?? pageNum,
      pageSize: data?['pageSize'] ?? pageSize,
    );
  }
}