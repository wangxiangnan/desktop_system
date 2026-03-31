import '../models/ticket_model.dart';

abstract class TicketRepository {
  Future<List<TicketModel>> getTickets();
  Future<TicketModel> getTicketById(String id);
  Future<TicketModel> createTicket(TicketModel ticket);
  Future<TicketModel> updateTicket(TicketModel ticket);
  Future<void> deleteTicket(String id);
  Future<List<TicketModel>> searchTickets(String query);
}
