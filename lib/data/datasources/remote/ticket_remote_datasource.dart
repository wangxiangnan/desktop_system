import 'package:desktop_system/core/models/paginated.dart';
import 'package:desktop_system/core/network/dio_client.dart';
import 'package:desktop_system/domain/entities/ticket_entity.dart';

const _ticketBasePath = '/api/ticket/v1/auth/performance/infoMain';

/// Remote data source for tickets using Dio
class TicketRemoteDataSource {
  final DioClient _dioClient;

  TicketRemoteDataSource(this._dioClient);

  /// Fetch paginated tickets from API
  Future<Paginated<Ticket>> getTickets({int pageNum = 1, int pageSize = 10}) async {
    final response = await _dioClient.post(
      '$_ticketBasePath/listPage',
      data: {'pageNum': pageNum, 'pageSize': pageSize},
    );
    final data = response.data['data'] as Map<String, dynamic>?;
    final List<dynamic> ticketsJson = data?['rows'] ?? [];
    print('API Response: ${ticketsJson}'); // Debug log for API response
    final tickets = ticketsJson
        .map((json) => _ticketFromJson(json as Map<String, dynamic>))
        .toList();

    return Paginated<Ticket>(
      rows: tickets,
      total: data?['total'] ?? 0,
      pageNum: data?['pageNum'] ?? pageNum,
      pageSize: data?['pageSize'] ?? pageSize,
    );
  }

  /// Fetch ticket by ID from API
  Future<Ticket> getTicketById(String id) async {
    final response = await _dioClient.post('$_ticketBasePath/get', data: {'id': id});
    return _ticketFromJson(response.data['data'] as Map<String, dynamic>);
  }

  // JSON conversion helpers
  Ticket _ticketFromJson(Map<String, dynamic> json) {
    return Ticket(
      id: json['id'] as String,
      ticketNumber: json['ticket_number'] as String,
      passengerName: json['passenger_name'] as String,
      route: json['route'] as String,
      departureTime: DateTime.parse(json['departure_time'] as String),
      status: TicketStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => TicketStatus.pending,
      ),
      price: (json['price'] as num).toDouble(),
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['createTime'] as String),
    );
  }

  Map<String, dynamic> _ticketToJson(Ticket ticket) {
    return {
      'id': ticket.id,
      'ticket_number': ticket.ticketNumber,
      'passenger_name': ticket.passengerName,
      'route': ticket.route,
      'departure_time': ticket.departureTime.toIso8601String(),
      'status': ticket.status.name,
      'price': ticket.price,
      'notes': ticket.notes,
      'createTime': ticket.createdAt.toIso8601String(),
    };
  }
}
