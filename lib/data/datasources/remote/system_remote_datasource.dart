import 'package:desktop_system/data/models/dict_data.dart';
import 'package:desktop_system/core/network/dio_client.dart';

const _systemBasePath = '/system/dict/data/type';

/// Remote data source for system-level APIs.
class SystemRemoteDataSource {
  final DioClient _dioClient;

  SystemRemoteDataSource(this._dioClient);

  /// Fetch dictionary data by type ID.
  Future<List<DictData>> getDict(int dictId) async {
    final response = await _dioClient.get('$_systemBasePath/$dictId');
    final List<dynamic> data = response.data['data'] as List<dynamic>? ?? [];
    return data
        .map((json) => DictData.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
