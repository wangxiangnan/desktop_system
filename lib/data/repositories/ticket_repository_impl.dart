import '../../domain/entities/ticket_entity.dart';
import '../../domain/repositories/ticket_repository.dart';
import '../datasources/remote/ticket_remote_datasource.dart';
import '../datasources/local/ticket_local_datasource.dart';
import '../../core/config/app_config.dart';

/// Implementation of TicketRepository
/// Automatically selects local or remote based on AppConfig
class TicketRepositoryImpl implements TicketRepository {
  final TicketRemoteDataSource? _remoteDataSource;
  final TicketLocalDataSource? _localDataSource;

  TicketRepositoryImpl({
    TicketRemoteDataSource? remoteDataSource,
    TicketLocalDataSource? localDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  /// Factory constructor for remote data source
  factory TicketRepositoryImpl.remote(TicketRemoteDataSource remoteDataSource) {
    return TicketRepositoryImpl(remoteDataSource: remoteDataSource);
  }

  /// Factory constructor for local (mock) data source
  factory TicketRepositoryImpl.local(TicketLocalDataSource localDataSource) {
    return TicketRepositoryImpl(localDataSource: localDataSource);
  }

  /// Create repository based on configuration
  factory TicketRepositoryImpl.fromConfig({
    required TicketRemoteDataSource remoteDataSource,
    required TicketLocalDataSource localDataSource,
  }) {
    if (AppConfig.useMockData) {
      return TicketRepositoryImpl(localDataSource: localDataSource);
    }
    return TicketRepositoryImpl(remoteDataSource: remoteDataSource);
  }

  bool get _useRemote => _remoteDataSource != null;

  @override
  Future<PaginatedTickets> getTickets({int page = 1, int pageSize = 10}) {
    if (_useRemote) {
      return _remoteDataSource!.getTickets(page: page, pageSize: pageSize);
    }
    return _localDataSource!.getTickets(page: page, pageSize: pageSize);
  }

  @override
  Future<Ticket> getTicketById(String id) {
    if (_useRemote) {
      return _remoteDataSource!.getTicketById(id);
    }
    return _localDataSource!.getTicketById(id);
  }

  @override
  Future<Ticket> createTicket(Ticket ticket) {
    if (_useRemote) {
      return _remoteDataSource!.createTicket(ticket);
    }
    return _localDataSource!.createTicket(ticket);
  }

  @override
  Future<Ticket> updateTicket(Ticket ticket) {
    if (_useRemote) {
      return _remoteDataSource!.updateTicket(ticket);
    }
    return _localDataSource!.updateTicket(ticket);
  }

  @override
  Future<void> deleteTicket(String id) {
    if (_useRemote) {
      return _remoteDataSource!.deleteTicket(id);
    }
    return _localDataSource!.deleteTicket(id);
  }

  @override
  Future<List<Ticket>> searchTickets(
    String query, {
    int page = 1,
    int pageSize = 10,
  }) {
    if (_useRemote) {
      return _remoteDataSource!.searchTickets(query, page: page, pageSize: pageSize);
    }
    return _localDataSource!.searchTickets(query, page: page, pageSize: pageSize);
  }
}
