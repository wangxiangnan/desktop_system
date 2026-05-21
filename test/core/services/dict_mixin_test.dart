import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:desktop_system/core/services/dict_mixin.dart';
import 'package:desktop_system/core/services/dict_service.dart';
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

class _TestWidget extends StatefulWidget {
  final _MockDictRepository repo;

  const _TestWidget(this.repo);

  @override
  State<_TestWidget> createState() => _TestWidgetState();
}

class _TestWidgetState extends State<_TestWidget> with DictMixin {
  @override
  DictService get dictService => DictService(widget.repo);

  @override
  List<String> get dictIds => ['test_dict'];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('loaded: $dictsLoaded'),
        Text('loading: $dictLoading'),
        Text('error: ${dictError ?? ''}'),
        Text('label: ${dictLabel('test_dict', 'val')}'),
      ],
    );
  }
}

void main() {
  late _MockDictRepository repo;

  setUp(() {
    repo = _MockDictRepository();
  });

  testWidgets('loads dicts on init and exposes dictLabel', (tester) async {
    repo.addDict('test_dict', [
      DictData(dictLabel: '测试值', dictValue: 'val'),
    ]);

    await tester.pumpWidget(MaterialApp(home: _TestWidget(repo)));

    expect(find.text('loaded: false'), findsOneWidget);
    expect(find.text('loading: true'), findsOneWidget);

    await tester.pumpAndSettle();

    expect(find.text('loaded: true'), findsOneWidget);
    expect(find.text('loading: false'), findsOneWidget);
    expect(find.text('error: '), findsOneWidget);
    expect(find.text('label: 测试值'), findsOneWidget);
  });

  testWidgets('returns raw value when dict not found', (tester) async {
    await tester.pumpWidget(MaterialApp(home: _TestWidget(repo)));

    await tester.pumpAndSettle();

    expect(find.text('label: val'), findsOneWidget);
  });

  testWidgets('handles error gracefully', (tester) async {
    repo.shouldThrow = true;

    await tester.pumpWidget(MaterialApp(home: _TestWidget(repo)));

    await tester.pumpAndSettle();

    expect(find.text('loaded: false'), findsOneWidget);
    expect(find.text('loading: false'), findsOneWidget);
    expect(
      find.textContaining('Exception: network error'),
      findsOneWidget,
    );
  });
}
