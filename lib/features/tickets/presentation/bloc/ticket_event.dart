import 'package:equatable/equatable.dart';

abstract class TicketEvent extends Equatable {
  const TicketEvent();

  @override
  List<Object?> get props => [];
}

class TicketLoadRequested extends TicketEvent {
  const TicketLoadRequested();
}

class TicketSearchRequested extends TicketEvent {
  final String query;

  const TicketSearchRequested(this.query);

  @override
  List<Object?> get props => [query];
}

class TicketDeleteRequested extends TicketEvent {
  final String ticketId;

  const TicketDeleteRequested(this.ticketId);

  @override
  List<Object?> get props => [ticketId];
}

class TicketStatusChanged extends TicketEvent {
  final String ticketId;
  final int statusIndex;

  const TicketStatusChanged({
    required this.ticketId,
    required this.statusIndex,
  });

  @override
  List<Object?> get props => [ticketId, statusIndex];
}
