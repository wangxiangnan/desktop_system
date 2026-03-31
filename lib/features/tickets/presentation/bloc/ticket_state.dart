import 'package:equatable/equatable.dart';
import '../../../../data/models/ticket_model.dart';

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

  const TicketLoaded({required this.tickets, this.searchQuery});

  @override
  List<Object?> get props => [tickets, searchQuery];
}

class TicketError extends TicketState {
  final String message;

  const TicketError(this.message);

  @override
  List<Object?> get props => [message];
}
