import 'dart:async';

import 'package:flutter/material.dart';

import 'date_parts.dart';
import 'number_picker.dart';

class LinearDatePicker extends StatefulWidget {
  final bool showDay;
  final Function(DateTime date) dateChangeListener;

  final DateTime? startDate;
  final DateTime? endDate;
  final DateTime? initialDate;

  final Decoration? yearDecoration;
  final Decoration? monthDecoration;
  final Decoration? dayDecoration;

  final TextStyle? labelStyle;
  final TextStyle? selectedRowStyle;
  final TextStyle? unselectedRowStyle;

  final String yearLabel;
  final String monthLabel;
  final String dayLabel;

  final bool showLabels;
  final double columnWidth;
  final bool showMonthName;

  final Duration? debounceDuration;

  final List<String>? monthsNames;

  const LinearDatePicker({
    super.key,
    this.startDate,
    this.endDate,
    this.initialDate,
    this.yearDecoration,
    this.monthDecoration,
    this.dayDecoration,
    required this.dateChangeListener,
    this.showDay = true,
    this.labelStyle,
    this.selectedRowStyle,
    this.unselectedRowStyle,
    this.yearLabel = 'Year',
    this.monthLabel = 'Month',
    this.dayLabel = 'Day',
    this.showLabels = true,
    this.columnWidth = 55.0,
    this.debounceDuration,
    this.showMonthName = false,
    this.monthsNames,
  });

  @override
  State<LinearDatePicker> createState() => _LinearDatePickerState();
}

class _LinearDatePickerState extends State<LinearDatePicker> {
  late DateParts selectedDateParts;

  int? minYear;
  int? maxYear;

  int minMonth = 01;
  int maxMonth = 12;

  int minDay = 01;
  int maxDay = 31;

  Timer? _debounce;
  static const int _debounceDuration = 200;

  @override
  initState() {
    super.initState();
    minYear = DateTime.now().year - 100;
    maxYear = DateTime.now().year;

    selectedDateParts = _calculateSelectedDateParts();
  }

  DateParts _calculateSelectedDateParts() {
    late DateParts dateParts;
    if (widget.initialDate != null) {
      dateParts = _convertDateToDateParts(dateTime: widget.initialDate!);
    } else {
      dateParts = DateParts(
        day: DateTime.now().day,
        month: DateTime.now().month,
        year: DateTime.now().year,
      );
    }
    if (!widget.showDay) {
      dateParts.day = 1;
    }
    return dateParts;
  }

  @override
  Widget build(BuildContext context) {
    maxDay = _getMonthLength(selectedDateParts.year, selectedDateParts.month);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Visibility(
          visible: widget.showLabels,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: widget.columnWidth,
                child: Text(
                  widget.monthLabel,
                  style: widget.labelStyle,
                  textAlign: TextAlign.center,
                ),
              ),
              Visibility(
                visible: widget.showDay,
                child: SizedBox(
                  width: widget.columnWidth,
                  child: Text(
                    widget.dayLabel,
                    style: widget.labelStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(
                width: widget.columnWidth,
                child: Text(
                  widget.yearLabel,
                  style: widget.labelStyle,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            NumberPicker.integer(
              listViewWidth: widget.columnWidth,
              initialValue: selectedDateParts.month,
              minValue: _getMinimumMonth(),
              maxValue: _getMaximumMonth(),
              selectedRowStyle: widget.selectedRowStyle,
              unselectedRowStyle: widget.unselectedRowStyle,
              showMonthName: widget.showMonthName,
              monthsNames: widget.monthsNames,
              decoration: widget.monthDecoration,
              onChanged: (value) {
                if (value != selectedDateParts.month) {
                  setState(() {
                    selectedDateParts.month = value as int;
                    _notifyDateChange();
                  });
                }
              },
            ),
            Visibility(
              visible: widget.showDay,
              child: NumberPicker.integer(
                listViewWidth: widget.columnWidth,
                initialValue: selectedDateParts.day,
                minValue: _getMinimumDay(),
                maxValue: _getMaximumDay(),
                selectedRowStyle: widget.selectedRowStyle,
                unselectedRowStyle: widget.unselectedRowStyle,
                decoration: widget.dayDecoration,
                onChanged: (value) {
                  if (value != selectedDateParts.day) {
                    setState(() {
                      selectedDateParts.day = value as int;
                      _notifyDateChange();
                    });
                  }
                },
              ),
            ),
            NumberPicker.integer(
              listViewWidth: widget.columnWidth,
              initialValue: selectedDateParts.year,
              minValue: _getMinimumYear()!,
              maxValue: _getMaximumYear()!,
              selectedRowStyle: widget.selectedRowStyle,
              unselectedRowStyle: widget.unselectedRowStyle,
              decoration: widget.yearDecoration,
              onChanged: (value) {
                if (value != selectedDateParts.year) {
                  setState(() {
                    selectedDateParts.year = value as int;
                    _notifyDateChange();
                  });
                }
              },
            ),
          ],
        ),
      ],
    );
  }

  void _notifyDateChange() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(
      widget.debounceDuration ??
          const Duration(milliseconds: _debounceDuration),
      () {
        try {
          DateTime selectedDate = DateTime(
            selectedDateParts.year,
            selectedDateParts.month,
            selectedDateParts.day,
          );
          widget.dateChangeListener(selectedDate);
        } catch (e) {
          debugPrint(e.toString());
        }
      },
    );
  }

  int _getMonthLength(int? selectedYear, int? selectedMonth) {
    DateTime firstOfNextMonth;
    if (selectedMonth == 12) {
      firstOfNextMonth = DateTime(selectedYear! + 1, 1, 1, 12);
    } else {
      firstOfNextMonth = DateTime(selectedYear!, selectedMonth! + 1, 1, 12);
    }
    int numberOfDaysInMonth = firstOfNextMonth.subtract(Duration(days: 1)).day;
    return numberOfDaysInMonth;
  }

  int _getMinimumMonth() {
    if (widget.startDate != null) {
      var startDateParts = _convertDateToDateParts(dateTime: widget.startDate!);
      int startMonth = startDateParts.month;

      if (selectedDateParts.year == _getMinimumYear()) {
        return startMonth;
      }
    }

    return minMonth;
  }

  int _getMaximumMonth() {
    if (widget.endDate != null) {
      var endDateParts = _convertDateToDateParts(dateTime: widget.endDate!);
      int endMonth = endDateParts.month;
      if (selectedDateParts.year == _getMaximumYear()) {
        return endMonth;
      }
    }
    return maxMonth;
  }

  int? _getMinimumYear() {
    if (widget.startDate != null) {
      var startDateParts = _convertDateToDateParts(dateTime: widget.startDate!);
      return startDateParts.year;
    }
    return minYear;
  }

  int? _getMaximumYear() {
    if (widget.endDate != null) {
      var endDateParts = _convertDateToDateParts(dateTime: widget.endDate!);
      return endDateParts.year;
    }
    return maxYear;
  }

  int _getMinimumDay() {
    if (widget.startDate != null && widget.showDay) {
      var startDateParts = _convertDateToDateParts(dateTime: widget.startDate!);
      int startDay = startDateParts.day;

      if (selectedDateParts.year == _getMinimumYear() &&
          selectedDateParts.month == _getMinimumMonth()) {
        return startDay;
      }
    }

    return minDay;
  }

  int _getMaximumDay() {
    if (widget.endDate != null && widget.showDay) {
      var endDateParts = _convertDateToDateParts(dateTime: widget.endDate!);
      int endDay = endDateParts.day;
      if (selectedDateParts.year == _getMaximumYear() &&
          selectedDateParts.month == _getMaximumMonth()) {
        return endDay;
      }
    }
    return _getMonthLength(selectedDateParts.year, selectedDateParts.month);
  }

  DateParts _convertDateToDateParts({required DateTime dateTime}) {
    return DateParts(
      day: dateTime.day,
      month: dateTime.month,
      year: dateTime.year,
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
