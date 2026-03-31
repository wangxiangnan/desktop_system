import '../models/ticket_model.dart';
import 'ticket_repository.dart';

class TicketRepositoryImpl implements TicketRepository {
  final List<TicketModel> _tickets = [];

  TicketRepositoryImpl() {
    _initMockData();
  }

  void _initMockData() {
    final now = DateTime.now();
    _tickets.addAll([
      TicketModel(
        id: '1',
        ticketNumber: 'TK001',
        passengerName: 'John Doe',
        route: 'New York - Boston',
        departureTime: now.add(const Duration(hours: 2)),
        status: TicketStatus.completed,
        price: 45.00,
        createdAt: now.subtract(const Duration(days: 1)),
      ),
      TicketModel(
        id: '2',
        ticketNumber: 'TK002',
        passengerName: 'Jane Smith',
        route: 'Los Angeles - San Francisco',
        departureTime: now.add(const Duration(days: 1)),
        status: TicketStatus.pending,
        price: 35.00,
        createdAt: now,
      ),
      TicketModel(
        id: '3',
        ticketNumber: 'TK003',
        passengerName: 'Bob Johnson',
        route: 'Chicago - Detroit',
        departureTime: now.add(const Duration(hours: 5)),
        status: TicketStatus.processing,
        price: 28.50,
        notes: 'Special assistance required',
        createdAt: now.subtract(const Duration(hours: 3)),
      ),
      TicketModel(
        id: '4',
        ticketNumber: 'TK004',
        passengerName: 'Alice Williams',
        route: 'Miami - Orlando',
        departureTime: now.add(const Duration(days: 2)),
        status: TicketStatus.cancelled,
        price: 22.00,
        createdAt: now.subtract(const Duration(days: 2)),
      ),
    ]);
  }

  @override
  Future<List<TicketModel>> getTickets() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_tickets);
  }

  @override
  Future<TicketModel> getTicketById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _tickets.firstWhere((t) => t.id == id);
  }

  @override
  Future<TicketModel> createTicket(TicketModel ticket) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _tickets.add(ticket);
    return ticket;
  }

  @override
  Future<TicketModel> updateTicket(TicketModel ticket) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _tickets.indexWhere((t) => t.id == ticket.id);
    if (index != -1) {
      _tickets[index] = ticket;
    }
    return ticket;
  }

  @override
  Future<void> deleteTicket(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _tickets.removeWhere((t) => t.id == id);
  }

  @override
  Future<List<TicketModel>> searchTickets(String query) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final lowerQuery = query.toLowerCase();
    return _tickets.where((t) {
      return t.passengerName.toLowerCase().contains(lowerQuery) ||
          t.ticketNumber.toLowerCase().contains(lowerQuery) ||
          t.route.toLowerCase().contains(lowerQuery);
    }).toList();
  }
}
