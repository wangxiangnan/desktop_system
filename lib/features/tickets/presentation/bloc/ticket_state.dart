import 'package:equatable/equatable.dart';
import 'package:desktop_system/data/models/ticket_model.dart';

abstract class TicketState extends Equatable {
  const TicketState();

  @override
  List<Object?> get props => [];
}

class TicketInitial extends TicketState {
  const TicketInitial();
}

class TicketLoading extends TicketState {
  const TicketLoading();
}

class TicketLoaded extends TicketState {
  final List<TicketModel> tickets;
  final String? searchQuery;
  final int currentPage;
  final int totalPages;
  final int total;

  const TicketLoaded({
    required this.tickets,
    this.searchQuery,
    required this.currentPage,
    required this.totalPages,
    required this.total,
  });

  @override
  List<Object?> get props => [
    tickets,
    searchQuery,
    currentPage,
    totalPages,
    total,
  ];
}

class TicketError extends TicketState {
  final String message;

  const TicketError(this.message);

  @override
  List<Object?> get props => [message];
}
