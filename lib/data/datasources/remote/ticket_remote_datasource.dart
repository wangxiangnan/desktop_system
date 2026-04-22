import '../../../core/network/dio_client.dart';
import '../../../domain/entities/ticket_entity.dart';

/// Remote data source for tickets using Dio
class TicketRemoteDataSource {
  final DioClient _dioClient;

  TicketRemoteDataSource(this._dioClient);

  /// Fetch paginated tickets from API
  Future<PaginatedTickets> getTickets({int page = 1, int pageSize = 10}) async {
    final response = await _dioClient.get(
      '/tickets',
      queryParameters: {'page': page, 'pageSize': pageSize},
    );
    final data = response.data;
    final List<dynamic> ticketsJson = data['tickets'] ?? [];
    final tickets = ticketsJson
        .map((json) => _ticketFromJson(json as Map<String, dynamic>))
        .toList();

    return PaginatedTickets(
      tickets: tickets,
      total: data['total'] ?? 0,
      page: data['page'] ?? page,
      pageSize: data['pageSize'] ?? pageSize,
    );
  }

  /// Fetch ticket by ID from API
  Future<Ticket> getTicketById(String id) async {
    final response = await _dioClient.get('/tickets/$id');
    return _ticketFromJson(response.data as Map<String, dynamic>);
  }

  /// Create ticket via API
  Future<Ticket> createTicket(Ticket ticket) async {
    final response = await _dioClient.post('/tickets', data: _ticketToJson(ticket));
    return _ticketFromJson(response.data as Map<String, dynamic>);
  }

  /// Update ticket via API
  Future<Ticket> updateTicket(Ticket ticket) async {
    final response = await _dioClient.put(
      '/tickets/${ticket.id}',
      data: _ticketToJson(ticket),
    );
    return _ticketFromJson(response.data as Map<String, dynamic>);
  }

  /// Delete ticket via API
  Future<void> deleteTicket(String id) async {
    await _dioClient.delete('/tickets/$id');
  }

  /// Search tickets via API
  Future<List<Ticket>> searchTickets(
    String query, {
    int page = 1,
    int pageSize = 10,
  }) async {
    final response = await _dioClient.get(
      '/tickets/search',
      queryParameters: {'q': query, 'page': page, 'pageSize': pageSize},
    );
    final List<dynamic> ticketsJson = response.data['tickets'] ?? [];
    return ticketsJson
        .map((json) => _ticketFromJson(json as Map<String, dynamic>))
        .toList();
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
      createdAt: DateTime.parse(json['created_at'] as String),
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
      'created_at': ticket.createdAt.toIso8601String(),
    };
  }
}
