import 'package:desktop_system/core/result/result.dart';
import 'package:desktop_system/core/models/paginated.dart';
import '../entities/order_entity.dart';
import '../repositories/order_repository.dart';

class OrderUsecase {
  final OrderRepository orderRepository;

  OrderUsecase(this.orderRepository);

  Future<Paginated<Order>> getOrders(Map<String, Object?> params) async {
    try {
      final result = await orderRepository.getOrders(params);
      return result;
    } catch (e) {
      throw AppError(message: '获取订单列表失败: ${e.toString()}');
    }
  }

  /* Future<Order> getOrderById(String id) async {
    try {
      return await orderRepository.getOrderById(id);
    } catch (e) {
      throw AppError(message: '获取订单详情失败: ${e.toString()}');
    }
  } */
}