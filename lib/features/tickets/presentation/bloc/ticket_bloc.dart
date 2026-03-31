import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/repositories/ticket_repository.dart';
import '../../../../data/models/ticket_model.dart';
import 'ticket_event.dart';
import 'ticket_state.dart';

class TicketBloc extends Bloc<TicketEvent, TicketState> {
  final TicketRepository _ticketRepository;

  TicketBloc(this._ticketRepository) : super(const TicketInitial()) {
    on<TicketLoadRequested>(_onLoadRequested);
    on<TicketSearchRequested>(_onSearchRequested);
    on<TicketDeleteRequested>(_onDeleteRequested);
    on<TicketStatusChanged>(_onStatusChanged);
  }

  Future<void> _onLoadRequested(
    TicketLoadRequested event,
    Emitter<TicketState> emit,
  ) async {
    emit(const TicketLoading());

    try {
      final tickets = await _ticketRepository.getTickets();
      emit(TicketLoaded(tickets: tickets));
    } catch (e) {
      emit(TicketError(e.toString()));
    }
  }

  Future<void> _onSearchRequested(
    TicketSearchRequested event,
    Emitter<TicketState> emit,
  ) async {
    emit(const TicketLoading());

    try {
      final tickets = event.query.isEmpty
          ? await _ticketRepository.getTickets()
          : await _ticketRepository.searchTickets(event.query);
      emit(TicketLoaded(tickets: tickets, searchQuery: event.query));
    } catch (e) {
      emit(TicketError(e.toString()));
    }
  }

  Future<void> _onDeleteRequested(
    TicketDeleteRequested event,
    Emitter<TicketState> emit,
  ) async {
    try {
      await _ticketRepository.deleteTicket(event.ticketId);
      add(const TicketLoadRequested());
    } catch (e) {
      emit(TicketError(e.toString()));
    }
  }

  Future<void> _onStatusChanged(
    TicketStatusChanged event,
    Emitter<TicketState> emit,
  ) async {
    try {
      final ticket = await _ticketRepository.getTicketById(event.ticketId);
      final newStatus = TicketStatus.values[event.statusIndex];
      final updatedTicket = ticket.copyWith(status: newStatus);
      await _ticketRepository.updateTicket(updatedTicket);
      add(const TicketLoadRequested());
    } catch (e) {
      emit(TicketError(e.toString()));
    }
  }
}
