import 'package:equatable/equatable.dart';

/// Ticket status enumeration
enum TicketStatus { pending, processing, completed, cancelled }

/// Domain entity for Ticket
/// This is the core business object, independent of data layer
class Ticket extends Equatable {
  final String id;
  final String ticketNumber;
  final String passengerName;
  final String route;
  final DateTime departureTime;
  final TicketStatus status;
  final double price;
  final String? notes;
  final DateTime createdAt;

  const Ticket({
    required this.id,
    required this.ticketNumber,
    required this.passengerName,
    required this.route,
    required this.departureTime,
    required this.status,
    required this.price,
    this.notes,
    required this.createdAt,
  });

  Ticket copyWith({
    String? id,
    String? ticketNumber,
    String? passengerName,
    String? route,
    DateTime? departureTime,
    TicketStatus? status,
    double? price,
    String? notes,
    DateTime? createdAt,
  }) {
    return Ticket(
      id: id ?? this.id,
      ticketNumber: ticketNumber ?? this.ticketNumber,
      passengerName: passengerName ?? this.passengerName,
      route: route ?? this.route,
      departureTime: departureTime ?? this.departureTime,
      status: status ?? this.status,
      price: price ?? this.price,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        ticketNumber,
        passengerName,
        route,
        departureTime,
        status,
        price,
        notes,
        createdAt,
      ];
}

/// Paginated tickets result
class PaginatedTickets {
  final List<Ticket> tickets;
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
