import 'package:desktop_system/domain/entities/svg_entity.dart';
import 'package:desktop_system/domain/repositories/svg_repository.dart';
import 'package:desktop_system/core/config/app_config.dart';
import 'package:desktop_system/data/datasources/remote/svg_remote_datasource.dart';
import 'package:desktop_system/data/datasources/local/svg_local_datasource.dart';

/// Implementation of SvgRepository
/// Automatically selects local or remote based on AppConfig
class SvgRepositoryImpl implements SvgRepository {
  final SvgRemoteDataSource? _remoteDataSource;
  final SvgLocalDataSource? _localDataSource;

  SvgRepositoryImpl({
    SvgRemoteDataSource? remoteDataSource,
    SvgLocalDataSource? localDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  /// Factory constructor for remote data source
  factory SvgRepositoryImpl.remote(SvgRemoteDataSource remoteDataSource) {
    return SvgRepositoryImpl(remoteDataSource: remoteDataSource);
  }

  /// Factory constructor for local (mock) data source
  factory SvgRepositoryImpl.local(SvgLocalDataSource localDataSource) {
    return SvgRepositoryImpl(localDataSource: localDataSource);
  }

  /// Create repository based on configuration
  factory SvgRepositoryImpl.fromConfig({
    required SvgRemoteDataSource remoteDataSource,
    required SvgLocalDataSource localDataSource,
  }) {
    if (AppConfig.useMockData) {
      return SvgRepositoryImpl(localDataSource: localDataSource);
    }
    return SvgRepositoryImpl(remoteDataSource: remoteDataSource);
  }

  bool get _useRemote => _remoteDataSource != null;

  @override
  Future<List<SvgCanvas>> getCanvases() {
    if (_useRemote) {
      return _remoteDataSource!.getCanvases();
    }
    return _localDataSource!.getCanvases();
  }

  @override
  Future<SvgCanvas> getCanvasById(String id) {
    if (_useRemote) {
      return _remoteDataSource!.getCanvasById(id);
    }
    return _localDataSource!.getCanvasById(id);
  }

  @override
  Future<SvgCanvas> createCanvas(SvgCanvas canvas) {
    if (_useRemote) {
      return _remoteDataSource!.createCanvas(canvas);
    }
    return _localDataSource!.createCanvas(canvas);
  }

  @override
  Future<SvgCanvas> updateCanvas(SvgCanvas canvas) {
    if (_useRemote) {
      return _remoteDataSource!.updateCanvas(canvas);
    }
    return _localDataSource!.updateCanvas(canvas);
  }

  @override
  Future<void> deleteCanvas(String id) {
    if (_useRemote) {
      return _remoteDataSource!.deleteCanvas(id);
    }
    return _localDataSource!.deleteCanvas(id);
  }
}
