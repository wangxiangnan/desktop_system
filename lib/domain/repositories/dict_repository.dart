import 'package:desktop_system/data/models/dict_data.dart';

abstract class DictRepository {
  Future<List<DictData>> getDict(String dictId);
}
