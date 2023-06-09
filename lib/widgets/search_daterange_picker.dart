import 'package:flutter/material.dart';

import '../core/constants.dart';
import '../core/utils.dart';

class SearchDaterangePicker extends StatefulWidget {
  const SearchDaterangePicker({super.key, required this.callback});

  final void Function(DateTimeRange) callback;

  @override
  State<SearchDaterangePicker> createState() => _SearchDaterangePickerState();
}

class _SearchDaterangePickerState extends State<SearchDaterangePicker> {
  late DateTime first;
  late DateTime last;

  final DateTime _firstDate =
      DateTime.now().subtract(const Duration(days: 365 * 10));
  final DateTime _lastDate = DateTime.now().add(const Duration(days: 365 * 10));

  @override
  void initState() {
    super.initState();

    first = DateTime.now();
    last = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      child: ListTile(
        dense: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
        shape: RoundedRectangleBorder(
          borderRadius: defaultBorderRadius,
          side: const BorderSide(color: Colors.grey),
        ),
        title: Text('${dateToString(first)}   --   ${dateToString(last)}'),
        onTap: () => _dateRangePicker(context),
        trailing: const Icon(Icons.calendar_month),
      ),
    );
  }

  Future _dateRangePicker(
    BuildContext context,
  ) async {
    final newDateRange = await showDateRangePicker(
      context: context,
      firstDate: _firstDate,
      lastDate: _lastDate,
      initialDateRange: DateTimeRange(start: first, end: last),
    );

    if (newDateRange == null) return;

    setState(() {
      first = newDateRange.start;
      last = newDateRange.end;
    });

    widget.callback(newDateRange);
  }
}
