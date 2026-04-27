import 'package:desktop_system/domain/entities/ticket_entity.dart';

/// Local data source for tickets (Mock implementation)
/// Used for development and testing without API
class TicketLocalDataSource {
  final List<Ticket> _tickets = [];

  TicketLocalDataSource() {
    _initMockData();
  }

  void _initMockData() {
    final now = DateTime.now();
    final names = [
      'John Doe',
      'Jane Smith',
      'Bob Johnson',
      'Alice Williams',
      'Charlie Brown',
      'David Wilson',
      'Emma Davis',
      'Frank Miller',
      'Grace Lee',
      'Henry Taylor',
      'Ivy Anderson',
      'Jack Thomas',
    ];
    final routes = [
      'New York - Boston',
      'Los Angeles - San Francisco',
      'Chicago - Detroit',
      'Miami - Orlando',
      'Seattle - Portland',
      'Dallas - Houston',
      'Atlanta - Charlotte',
      'Phoenix - Las Vegas',
    ];

    for (int i = 0; i < 25; i++) {
      _tickets.add(
        Ticket(
          id: '${i + 1}',
          ticketNumber: 'TK${(i + 1).toString().padLeft(3, '0')}',
          passengerName: names[i % names.length],
          route: routes[i % routes.length],
          departureTime: now.add(Duration(days: i, hours: i * 2)),
          status: TicketStatus.values[i % 4],
          price: 20.0 + (i * 5),
          notes: i % 3 == 0 ? 'Special assistance required' : null,
          createdAt: now.subtract(Duration(days: i)),
        ),
      );
    }
  }

  /// Get paginated tickets
  Future<PaginatedTickets> getTickets({int page = 1, int pageSize = 10}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final start = (page - 1) * pageSize;
    final end = start + pageSize;
    final paginatedList = _tickets.length > start
        ? _tickets.sublist(start, end.clamp(0, _tickets.length))
        : <Ticket>[];

    return PaginatedTickets(
      tickets: paginatedList,
      total: _tickets.length,
      page: page,
      pageSize: pageSize,
    );
  }

  /// Get ticket by ID
  Future<Ticket> getTicketById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _tickets.firstWhere((t) => t.id == id);
  }

  /// Create ticket
  Future<Ticket> createTicket(Ticket ticket) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _tickets.add(ticket);
    return ticket;
  }

  /// Update ticket
  Future<Ticket> updateTicket(Ticket ticket) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _tickets.indexWhere((t) => t.id == ticket.id);
    if (index != -1) {
      _tickets[index] = ticket;
    }
    return ticket;
  }

  /// Delete ticket
  Future<void> deleteTicket(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _tickets.removeWhere((t) => t.id == id);
  }

  /// Search tickets
  Future<List<Ticket>> searchTickets(
    String query, {
    int page = 1,
    int pageSize = 10,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final lowerQuery = query.toLowerCase();
    final filtered = _tickets.where((t) {
      return t.passengerName.toLowerCase().contains(lowerQuery) ||
          t.ticketNumber.toLowerCase().contains(lowerQuery) ||
          t.route.toLowerCase().contains(lowerQuery);
    }).toList();

    final start = (page - 1) * pageSize;
    final end = start + pageSize;
    return filtered.length > start
        ? filtered.sublist(start, end.clamp(0, filtered.length))
        : <Ticket>[];
  }
}
