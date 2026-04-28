import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:desktop_system/domain/repositories/ticket_repository.dart';
import 'ticket_event.dart';
import 'ticket_state.dart';

class TicketBloc extends Bloc<TicketEvent, TicketState> {
  final TicketRepository _ticketRepository;
  int _pageSize = 10;

  TicketBloc(this._ticketRepository) : super(const TicketInitial()) {
    on<TicketLoadRequested>(_onLoadRequested);
    on<TicketPageChanged>(_onPageChanged);
    on<TicketSearchRequested>(_onSearchRequested);
  }

  Future<void> _onLoadRequested(
    TicketLoadRequested event,
    Emitter<TicketState> emit,
  ) async {
    emit(const TicketLoading());

    try {
      _pageSize = event.pageSize;
      final result = await _ticketRepository.getTickets(
        pageNum: event.pageNum,
        pageSize: event.pageSize,
      );
      print('Loaded ${result.rows.length} tickets (Page ${result.pageNum}/${result.totalPages})');
      emit(
        TicketLoaded(
          tickets: result.rows,
          currentPage: result.pageNum,
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

    emit(const TicketLoading());

    try {
      final result = await _ticketRepository.getTickets(
        pageNum: event.pageNum,
        pageSize: _pageSize,
      );
      emit(
        TicketLoaded(
          tickets: result.rows,
          currentPage: result.pageNum,
          totalPages: result.totalPages,
          total: result.total,
        ),
      );
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
          pageNum: 1,
          pageSize: _pageSize,
        );
        emit(
          TicketLoaded(
            tickets: result.rows,
            currentPage: result.pageNum,
            totalPages: result.totalPages,
            total: result.total,
          ),
        );
      }
    } catch (e) {
      emit(TicketError(e.toString()));
    }
  }

}
