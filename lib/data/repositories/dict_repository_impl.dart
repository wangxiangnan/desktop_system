import 'package:desktop_system/data/models/dict_data.dart';
import 'package:desktop_system/domain/repositories/dict_repository.dart';
import '../datasources/remote/system_remote_datasource.dart';

class DictRepositoryImpl extends DictRepository {
  final SystemRemoteDataSource _remoteDataSource;

  DictRepositoryImpl({required SystemRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Future<List<DictData>> getDict(String dictId) async {
    return _remoteDataSource.getDict(dictId);
  }
}
