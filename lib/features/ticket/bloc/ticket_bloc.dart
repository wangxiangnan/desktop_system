import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:desktop_system/domain/repositories/ticket_repository.dart';
import 'package:desktop_system/domain/entities/ticket_entity.dart';
import 'ticket_event.dart';
import 'ticket_state.dart';

class TicketBloc extends Bloc<TicketEvent, TicketState> {
  final TicketRepository _ticketRepository;
  int _pageSize = 10;

  TicketBloc(this._ticketRepository) : super(const TicketInitial()) {
    on<TicketLoadRequested>(_onLoadRequested);
    on<TicketPageChanged>(_onPageChanged);
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
      _pageSize = event.pageSize;
      final result = await _ticketRepository.getTickets(
        page: event.page,
        pageSize: event.pageSize,
      );
      print('Loaded ${result.tickets.length} tickets (Page ${result.page}/${result.totalPages})');
      emit(
        TicketLoaded(
          tickets: result.tickets,
          currentPage: result.page,
          totalPages: result.totalPages,
          total: result.total,
        ),
      );
    } catch (e) {
      emit(TicketError(e.toString()));
    }
  }

  Future<void> _onPageChanged(
    TicketPageChanged event,
    Emitter<TicketState> emit,
  ) async {
    final currentState = state;
    final currentQuery = currentState is TicketLoaded
        ? currentState.searchQuery
        : null;

    emit(const TicketLoading());

    try {
      if (currentQuery != null && currentQuery.isNotEmpty) {
        final result = await _ticketRepository.searchTickets(
          currentQuery,
          page: event.page,
          pageSize: _pageSize,
        );
        emit(
          TicketLoaded(
            tickets: result,
            searchQuery: currentQuery,
            currentPage: event.page,
            totalPages: (result.length / _pageSize).ceil(),
            total: result.length,
          ),
        );
      } else {
        final result = await _ticketRepository.getTickets(
          page: event.page,
          pageSize: _pageSize,
        );
        emit(
          TicketLoaded(
            tickets: result.tickets,
            currentPage: result.page,
            totalPages: result.totalPages,
            total: result.total,
          ),
        );
      }
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
      if (event.query.isEmpty) {
        final result = await _ticketRepository.getTickets(
          page: 1,
          pageSize: _pageSize,
        );
        emit(
          TicketLoaded(
            tickets: result.tickets,
            currentPage: result.page,
            totalPages: result.totalPages,
            total: result.total,
          ),
        );
      } else {
        final tickets = await _ticketRepository.searchTickets(
          event.query,
          page: event.page,
          pageSize: _pageSize,
        );
        emit(
          TicketLoaded(
            tickets: tickets,
            searchQuery: event.query,
            currentPage: event.page,
            totalPages: (tickets.length / _pageSize).ceil(),
            total: tickets.length,
          ),
        );
      }
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
