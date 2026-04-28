import 'package:desktop_system/core/result/result.dart';
import 'package:desktop_system/core/models/paginated.dart';
import '../entities/order_entity.dart';
import '../repositories/order_repository.dart';

class OrderUsecase {
  final OrderRepository orderRepository;

  OrderUsecase(this.orderRepository);

  Future<Paginated<Order>> getOrders({int pageNum = 1, int pageSize = 10}) async {
    try {
      final result = await orderRepository.getOrders(pageNum: pageNum, pageSize: pageSize);
      if (result.rows.isEmpty) {
        throw AppError(message: '订单列表为空');
      }
      return result;
    } catch (e) {
      throw AppError(message: '获取订单列表失败: ${e.toString()}');
    }
  }

  Future<Order> getOrderById(String id) async {
    try {
      return await orderRepository.getOrderById(id);
    } catch (e) {
      throw AppError(message: '获取订单详情失败: ${e.toString()}');
    }
  }
}