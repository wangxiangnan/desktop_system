import 'package:desktop_system/core/models/paginated.dart';
import '../entities/order_entity.dart';

abstract class OrderRepository {
  Future<Paginated<Order>> getOrders({int pageNum = 1, int pageSize = 10});
  Future<Order> getOrderById(String id);
}