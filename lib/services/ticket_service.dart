import '../../core/network/dio_client.dart';
import '../data/models/ticket_model.dart';
import '../data/repositories/ticket_repository.dart';

class TicketService {
  final DioClient _dioClient;

  TicketService(this._dioClient);

  /// 获取票据列表
  Future<PaginatedTickets> getTickets({int page = 1, int pageSize = 10}) async {
    try {
      final response = await _dioClient.get(
        '/tickets',
        queryParameters: {'page': page, 'pageSize': pageSize},
      );
      final data = response.data;
      final List<dynamic> ticketsJson = data['tickets'] ?? [];
      final tickets = ticketsJson
          .map((json) => TicketModel.fromJson(json))
          .toList();

      return PaginatedTickets(
        tickets: tickets,
        total: data['total'] ?? 0,
        page: data['page'] ?? page,
        pageSize: data['pageSize'] ?? pageSize,
      );
    } catch (e) {
      throw Exception('获取票据列表失败: $e');
    }
  }

  /// 根据ID获取票据
  Future<TicketModel> getTicketById(String id) async {
    try {
      final response = await _dioClient.get('/tickets/$id');
      return TicketModel.fromJson(response.data);
    } catch (e) {
      throw Exception('获取票据详情失败: $e');
    }
  }

  /// 创建票据
  Future<TicketModel> createTicket(TicketModel ticket) async {
    try {
      final response = await _dioClient.post('/tickets', data: ticket.toJson());
      return TicketModel.fromJson(response.data);
    } catch (e) {
      throw Exception('创建票据失败: $e');
    }
  }

  /// 更新票据
  Future<TicketModel> updateTicket(TicketModel ticket) async {
    try {
      final response = await _dioClient.put(
        '/tickets/${ticket.id}',
        data: ticket.toJson(),
      );
      return TicketModel.fromJson(response.data);
    } catch (e) {
      throw Exception('更新票据失败: $e');
    }
  }

  /// 删除票据
  Future<void> deleteTicket(String id) async {
    try {
      await _dioClient.delete('/tickets/$id');
    } catch (e) {
      throw Exception('删除票据失败: $e');
    }
  }

  /// 搜索票据
  Future<List<TicketModel>> searchTickets(
    String query, {
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      final response = await _dioClient.get(
        '/tickets/search',
        queryParameters: {'q': query, 'page': page, 'pageSize': pageSize},
      );
      final List<dynamic> ticketsJson = response.data['tickets'] ?? [];
      return ticketsJson.map((json) => TicketModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('搜索票据失败: $e');
    }
  }
}
