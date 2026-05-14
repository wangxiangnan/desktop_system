import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

class SearchForm extends StatelessWidget {
  final VoidCallback onSearch;
  final VoidCallback onReset;
  final VoidCallback onUpdateParams;
  final TextEditingController Function(String field) controller;
  final List<int>? calendarValue;
  final void Function(List<int> value) onCalendarConfirm;
  final _formKey = GlobalKey<FormState>();

  SearchForm({
    super.key,
    required this.onSearch,
    required this.onReset,
    required this.controller,
    required this.onUpdateParams,
    required this.calendarValue,
    required this.onCalendarConfirm,
  });

  String get _calendarButtonLabel {
    print('当前时间');
    print(DateTime.now());
    print(DateTime.fromMicrosecondsSinceEpoch(DateTime.now().microsecondsSinceEpoch));
    if (calendarValue != null && calendarValue!.length == 2) {
      final begin =
          DateFormat('yyyy-MM-dd').format(
              DateTime.fromMillisecondsSinceEpoch(calendarValue![0]));
      final end =
          DateFormat('yyyy-MM-dd').format(
              DateTime.fromMillisecondsSinceEpoch(calendarValue![1]));
      return '$begin - $end';
    }
    return '创建开始时间 - 创建结束时间';
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
              child: TDInput(
                controller: controller('orderInfoId'),
                needClear: true,
                hintText: '订单ID',
                onChanged: (text) {
                  onUpdateParams();
                },
                onClearTap: () {
                },
              ),
            ),
            SizedBox(
              width: 200,
              child: TDInput(
                controller: controller('thirdOrderNoId'),
                needClear: true,
                hintText: '项目ID',
                onChanged: (text) {
                  onUpdateParams();
                },
                onClearTap: () {
                },
              ),
            ),
            SizedBox(
              width: 200,
              child: TDInput(
                controller: controller('packageOrderActivityId'),
                needClear: true,
                hintText: '套票活动ID',
                onChanged: (text) {
                  onUpdateParams();
                },
                onClearTap: () {
                },
              ),
            ),
            SizedBox(
              width: 200,
              child: TDInput(
                controller: controller('mainOrderInfoId'),
                needClear: true,
                hintText: '邀请函code',
                onChanged: (text) {
                  onUpdateParams();
                },
                onClearTap: () {
                },
              ),
            ),
            SizedBox(
              width: 200,
              child: TDInput(
                controller: controller('ticketNo'),
                needClear: true,
                hintText: '票号',
                onChanged: (text) {
                  onUpdateParams();
                },
                onClearTap: () {
                },
              ),
            ),
            SizedBox(
              width: 260,
              child: TDButton(
                text: _calendarButtonLabel,
                size: TDButtonSize.large,
                type: TDButtonType.text,
                shape: TDButtonShape.rectangle,
                onTap: () {
                  TDCalendarPopup(
                    context,
                    visible: true,
                    onConfirm: onCalendarConfirm,
                    child: TDCalendar(
                      title: '请选择日期区间',
                      type: CalendarType.range,
                      height: 500,
                      minDate: DateTime.now().subtract(const Duration(days: 182)).millisecondsSinceEpoch,
                      maxDate: DateTime.now().millisecondsSinceEpoch,
                      value: calendarValue,
                    ),
                  );
                },
              ),
            ),
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
                onPressed: onReset,
                child: const Text('重置'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}