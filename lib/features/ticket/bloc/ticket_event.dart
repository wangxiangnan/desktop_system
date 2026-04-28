import 'package:equatable/equatable.dart';

abstract class TicketEvent extends Equatable {
  const TicketEvent();

  @override
  List<Object?> get props => [];
}

class TicketLoadRequested extends TicketEvent {
  final int pageNum;
  final int pageSize;

  const TicketLoadRequested({this.pageNum = 1, this.pageSize = 10});

  @override
  List<Object?> get props => [pageNum, pageSize];
}

class TicketPageChanged extends TicketEvent {
  final int pageNum;

  const TicketPageChanged(this.pageNum);

  @override
  List<Object?> get props => [pageNum];
}

class TicketSearchRequested extends TicketEvent {
  final String query;
  final int pageNum;

  const TicketSearchRequested(this.query, {this.pageNum = 1});

  @override
  List<Object?> get props => [query, pageNum];
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
