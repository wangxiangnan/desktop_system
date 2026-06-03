import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16.0),
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
                controller: controller('orderInfoId'),
                decoration: const InputDecoration(
                  labelText: '订单ID',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                onChanged: (_) => onUpdateParams(),
              ),
            ),
            SizedBox(
              width: 200,
              child: TextFormField(
                controller: controller('thirdOrderNoId'),
                decoration: const InputDecoration(
                  labelText: '项目ID',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                onChanged: (_) => onUpdateParams(),
              ),
            ),
            SizedBox(
              width: 200,
              child: TextFormField(
                controller: controller('packageOrderActivityId'),
                decoration: const InputDecoration(
                  labelText: '套票活动ID',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                onChanged: (_) => onUpdateParams(),
              ),
            ),
            SizedBox(
              width: 200,
              child: TextFormField(
                controller: controller('mainOrderInfoId'),
                decoration: const InputDecoration(
                  labelText: '邀请函code',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                onChanged: (_) => onUpdateParams(),
              ),
            ),
            SizedBox(
              width: 200,
              child: TextFormField(
                controller: controller('ticketNo'),
                decoration: const InputDecoration(
                  labelText: '票号',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                onChanged: (_) => onUpdateParams(),
              ),
            ),
            SizedBox(
              width: 200,
              child: TextFormField(
                controller: controller('createBeginTime'),
                decoration: const InputDecoration(
                  labelText: '创建开始时间',
                  hintText: 'YYYY-MM-DD',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                onChanged: (_) => onUpdateParams(),
              ),
            ),
            SizedBox(
              width: 200,
              child: TextFormField(
                controller: controller('createEndTime'),
                decoration: const InputDecoration(
                  labelText: '创建结束时间',
                  hintText: 'YYYY-MM-DD',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                onChanged: (_) => onUpdateParams(),
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
              height: 40,
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