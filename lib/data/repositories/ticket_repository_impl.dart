import 'package:desktop_system/core/models/paginated.dart';
import 'package:desktop_system/domain/entities/ticket_entity.dart';
import 'package:desktop_system/domain/repositories/ticket_repository.dart';
import 'package:desktop_system/core/config/app_config.dart';
import 'package:desktop_system/data/datasources/remote/ticket_remote_datasource.dart';
import 'package:desktop_system/data/datasources/local/ticket_local_datasource.dart';

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
  Future<Paginated<Ticket>> getTickets({int pageNum = 1, int pageSize = 10}) {
    if (_useRemote) {
      return _remoteDataSource!.getTickets(pageNum: pageNum, pageSize: pageSize);
    }
    return _localDataSource!.getTickets(pageNum: pageNum, pageSize: pageSize);
  }

  @override
  Future<Ticket> getTicketById(String id) {
    if (_useRemote) {
      return _remoteDataSource!.getTicketById(id);
    }
    return _localDataSource!.getTicketById(id);
  }
}
