import '../models/ticket_model.dart';
import 'ticket_repository.dart';
import '../../services/ticket_service.dart';

class TicketRepositoryImpl implements TicketRepository {
  final TicketService? _ticketService;
  final List<TicketModel> _tickets = [];

  TicketRepositoryImpl({TicketService? ticketService})
    : _ticketService = ticketService {
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
        TicketModel(
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

  @override
  Future<PaginatedTickets> getTickets({int page = 1, int pageSize = 10}) async {
    if (_ticketService != null) {
      return await _ticketService.getTickets(page: page, pageSize: pageSize);
    }

    await Future.delayed(const Duration(milliseconds: 300));
    final start = (page - 1) * pageSize;
    final end = start + pageSize;
    final paginatedList = _tickets.length > start
        ? _tickets.sublist(start, end.clamp(0, _tickets.length))
        : <TicketModel>[];

    return PaginatedTickets(
      tickets: paginatedList,
      total: _tickets.length,
      page: page,
      pageSize: pageSize,
    );
  }

  @override
  Future<TicketModel> getTicketById(String id) async {
    if (_ticketService != null) {
      return await _ticketService.getTicketById(id);
    }

    await Future.delayed(const Duration(milliseconds: 300));
    return _tickets.firstWhere((t) => t.id == id);
  }

  @override
  Future<TicketModel> createTicket(TicketModel ticket) async {
    if (_ticketService != null) {
      return await _ticketService.createTicket(ticket);
    }

    await Future.delayed(const Duration(milliseconds: 500));
    _tickets.add(ticket);
    return ticket;
  }

  @override
  Future<TicketModel> updateTicket(TicketModel ticket) async {
    if (_ticketService != null) {
      return await _ticketService.updateTicket(ticket);
    }

    await Future.delayed(const Duration(milliseconds: 500));
    final index = _tickets.indexWhere((t) => t.id == ticket.id);
    if (index != -1) {
      _tickets[index] = ticket;
    }
    return ticket;
  }

  @override
  Future<void> deleteTicket(String id) async {
    if (_ticketService != null) {
      await _ticketService.deleteTicket(id);
      return;
    }

    await Future.delayed(const Duration(milliseconds: 300));
    _tickets.removeWhere((t) => t.id == id);
  }

  @override
  Future<List<TicketModel>> searchTickets(
    String query, {
    int page = 1,
    int pageSize = 10,
  }) async {
    if (_ticketService != null) {
      return await _ticketService.searchTickets(
        query,
        page: page,
        pageSize: pageSize,
      );
    }

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
        : <TicketModel>[];
  }
}
