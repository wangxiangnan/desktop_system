import '../models/ticket_model.dart';

class PaginatedTickets {
  final List<TicketModel> tickets;
  final int total;
  final int page;
  final int pageSize;

  const PaginatedTickets({
    required this.tickets,
    required this.total,
    required this.page,
    required this.pageSize,
  });

  int get totalPages => (total / pageSize).ceil();
  bool get hasNextPage => page < totalPages;
  bool get hasPreviousPage => page > 1;
}

abstract class TicketRepository {
  Future<PaginatedTickets> getTickets({int page = 1, int pageSize = 10});
  Future<TicketModel> getTicketById(String id);
  Future<TicketModel> createTicket(TicketModel ticket);
  Future<TicketModel> updateTicket(TicketModel ticket);
  Future<void> deleteTicket(String id);
  Future<List<TicketModel>> searchTickets(
    String query, {
    int page = 1,
    int pageSize = 10,
  });
}
