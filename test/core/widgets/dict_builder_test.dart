import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:desktop_system/core/services/dict_service.dart';
import 'package:desktop_system/core/widgets/dict_builder.dart';
import 'package:desktop_system/data/models/dict_data.dart';
import 'package:desktop_system/domain/repositories/dict_repository.dart';

class _MockDictRepository extends DictRepository {
  final Map<String, List<DictData>> _data = {};
  bool shouldThrow = false;

  void addDict(String dictId, List<DictData> items) {
    _data[dictId] = items;
  }

  @override
  Future<List<DictData>> getDict(String dictId) async {
    if (shouldThrow) throw Exception('network error');
    return _data[dictId] ?? [];
  }
}

Widget _buildTestApp(DictBuilder builder) {
  return MaterialApp(home: builder);
}

void main() {
  late _MockDictRepository mockRepo;
  late DictService service;

  setUp(() {
    mockRepo = _MockDictRepository();
    service = DictService(mockRepo);
  });

  testWidgets('shows loading then loaded state', (tester) async {
    mockRepo.addDict('test', [const DictData(dictLabel: '标签', dictValue: 'v')]);

    await tester.pumpWidget(_buildTestApp(
      DictBuilder(
        dictIds: const ['test'],
        dictService: service,
        builder: (context, dicts, state) {
          if (state.isLoading) return const Text('loading...');
          if (state.hasError) return Text('error: ${state.errorMessage}');
          return Text('dict: ${dicts['test']?['v'] ?? ''}');
        },
      ),
    ));

    expect(find.text('loading...'), findsOneWidget);

    await tester.pumpAndSettle();

    expect(find.text('dict: 标签'), findsOneWidget);
  });

  testWidgets('handles error state', (tester) async {
    mockRepo.shouldThrow = true;

    await tester.pumpWidget(_buildTestApp(
      DictBuilder(
        dictIds: const ['test'],
        dictService: service,
        builder: (context, dicts, state) {
          if (state.isLoading) return const Text('loading...');
          if (state.hasError) return Text('error: ${state.errorMessage}');
          return const Text('loaded');
        },
      ),
    ));

    await tester.pumpAndSettle();

    expect(find.textContaining('Exception: network error'), findsOneWidget);
  });

  testWidgets('loads multiple dicts', (tester) async {
    mockRepo.addDict('a', [const DictData(dictLabel: 'A', dictValue: 'a')]);
    mockRepo.addDict('b', [const DictData(dictLabel: 'B', dictValue: 'b')]);

    await tester.pumpWidget(_buildTestApp(
      DictBuilder(
        dictIds: const ['a', 'b'],
        dictService: service,
        builder: (context, dicts, state) {
          if (state.isLoading) return const Text('loading...');
          return Text('a: ${dicts['a']?['a'] ?? ""} b: ${dicts['b']?['b'] ?? ""}');
        },
      ),
    ));

    await tester.pumpAndSettle();

    expect(find.text('a: A b: B'), findsOneWidget);
  });

  testWidgets('reloads when dictIds change', (tester) async {
    mockRepo.addDict('a', [const DictData(dictLabel: 'A', dictValue: 'a')]);
    mockRepo.addDict('b', [const DictData(dictLabel: 'B', dictValue: 'b')]);

    await tester.pumpWidget(_buildTestApp(
      DictBuilder(
        dictIds: const ['a'],
        dictService: service,
        builder: (context, dicts, state) {
          if (state.isLoading) return const Text('loading...');
          return Text('dicts: ${dicts.keys.join(",")}');
        },
      ),
    ));

    await tester.pumpAndSettle();
    expect(find.text('dicts: a'), findsOneWidget);

    await tester.pumpWidget(_buildTestApp(
      DictBuilder(
        dictIds: const ['a', 'b'],
        dictService: service,
        builder: (context, dicts, state) {
          if (state.isLoading) return const Text('loading...');
          return Text('dicts: ${dicts.keys.join(",")}');
        },
      ),
    ));

    await tester.pumpAndSettle();
    expect(find.text('dicts: a,b'), findsOneWidget);
  });
}
