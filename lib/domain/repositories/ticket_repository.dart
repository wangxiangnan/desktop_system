import 'package:desktop_system/core/models/paginated.dart';
import '../entities/ticket_entity.dart';

/// Abstract repository interface for tickets
/// This defines the contract that any data source must implement
abstract class TicketRepository {
  /// Get paginated list of tickets
  Future<Paginated<Ticket>> getOrders({int pageNum = 1, int pageSize = 10});

  /// Get ticket by ID
  Future<Ticket> getTicketById(String id);

}
