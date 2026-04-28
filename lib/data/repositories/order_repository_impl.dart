import 'package:desktop_system/domain/entities/order_entity.dart';
import 'package:desktop_system/domain/repositories/order_repository.dart';
import 'package:desktop_system/core/models/paginated.dart';
import '../datasources/remote/order_remote_datasource.dart';

class OrderRepositoryImpl extends OrderRepository {
  final OrderRemoteDataSource _remoteDataSource;

  OrderRepositoryImpl({
    required OrderRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  Future<Paginated<Order>> getOrders({int pageNum = 1, int pageSize = 10}) async {
    final paginatedOrders = await _remoteDataSource.getOrders(pageNum: pageNum, pageSize: pageSize);
    final orders = paginatedOrders.rows.map((orderModel) => orderModel.toEntity()).toList();
    return Paginated(
      rows: orders,
      total: paginatedOrders.total,
      pageNum: paginatedOrders.pageNum,
      pageSize: paginatedOrders.pageSize,
    );
  }

  @override
  Future<Order> getOrderById(String id) async {
    // This method is not implemented in the remote data source, so we throw an error for now.
    throw UnimplementedError('getOrderById is not implemented yet');
  }
}