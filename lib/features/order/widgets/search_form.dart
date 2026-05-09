import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
class SearchForm extends StatelessWidget {
  final VoidCallback onSearch;
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {};

  SearchForm({
    super.key,
    required this.onSearch,
  });

  TextEditingController _controller(String field) {
    return _controllers.putIfAbsent(field, () => TextEditingController());
  }

  _onReset() {

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Wrap(
          spacing: 16,
          runSpacing: 16,
          alignment: WrapAlignment.start,
          runAlignment: WrapAlignment.center,
          children: [
            SizedBox(
              width: 200,
              child: TextFormField(
                controller: _controller('orderInfoId'),
                decoration: const InputDecoration(
                  labelText: '订单ID',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
              ),
            ),
            SizedBox(
              width: 200,
              child: TextFormField(
                controller: _controller('thirdOrderNoId'),
                decoration: const InputDecoration(
                  labelText: '项目ID',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
              ),
            ),
            SizedBox(
              width: 200,
              child: TextFormField(
                controller: _controller('packageOrderActivityId'),
                decoration: const InputDecoration(
                  labelText: '套票活动ID',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
              ),
            ),
            SizedBox(
              width: 200,
              child: TextFormField(
                controller: _controller('mainOrderInfoId'),
                decoration: const InputDecoration(
                  labelText: '邀请函code',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
              ),
            ),
            SizedBox(
              width: 200,
              child: TextFormField(
                controller: _controller('ticketNo'),
                decoration: const InputDecoration(
                  labelText: '票号',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
              ),
            ),
            SizedBox(
              width: 200,
              child: TextFormField(
                controller: _controller('createBeginTime'),
                decoration: const InputDecoration(
                  labelText: '创建开始时间',
                  hintText: 'YYYY-MM-DD',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
              ),
            ),
            SizedBox(
              width: 260,
              child: TDInput(
                leftLabel: 'Label Text',
                controller: _controller('timeRange'),
                hintText: '创建开始-结束时间',
                readOnly: true,
                onTapOutside: (event) {
                  TDCalendarPopup(
                    context,
                    visible: true,
                    child: TDCalendar(
                      title: '请选择日期区间',
                      type: CalendarType.range,
                      value: [
                        DateTime.now().millisecondsSinceEpoch,
                        DateTime.now()
                            .add(const Duration(days: 6))
                            .millisecondsSinceEpoch,
                      ],
                    ),
                  );
                },
                onClearTap: () {
                  
                },
              )
            ),
            /* SizedBox(
              width: 200,
              child: TextFormField(
                controller: _controller('createEndTime'),
                decoration: const InputDecoration(
                  labelText: '创建结束时间',
                  hintText: 'YYYY-MM-DD',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
              ),
            ), */
            SizedBox(
              width: 160,
              child: ElevatedButton(
                onPressed: onSearch,
                child: const Text('查询'),
              ),
            ),
            SizedBox(
              width: 160,
              child: OutlinedButton(
                onPressed: _onReset,
                child: const Text('重置'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}