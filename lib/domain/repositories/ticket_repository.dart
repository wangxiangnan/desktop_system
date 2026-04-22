import '../entities/ticket_entity.dart';

/// Abstract repository interface for tickets
/// This defines the contract that any data source must implement
abstract class TicketRepository {
  /// Get paginated list of tickets
  Future<PaginatedTickets> getTickets({int page = 1, int pageSize = 10});

  /// Get ticket by ID
  Future<Ticket> getTicketById(String id);

  /// Create a new ticket
  Future<Ticket> createTicket(Ticket ticket);

  /// Update an existing ticket
  Future<Ticket> updateTicket(Ticket ticket);

  /// Delete a ticket
  Future<void> deleteTicket(String id);

  /// Search tickets by query
  Future<List<Ticket>> searchTickets(
    String query, {
    int page = 1,
    int pageSize = 10,
  });
}
