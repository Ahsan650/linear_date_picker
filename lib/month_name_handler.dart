extension StringExt on int {
  String getMonthName({List<String>? monthsNames}) {
    if (this > 12 || this < 1) return '$this';

    if (monthsNames != null && monthsNames.length == 12) {
      return monthsNames[this - 1];
    }

    return this > 12 ? '$this' : (_months)[this - 1];
  }

  static const _months = [
    'Jan',
    'Feb',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
}
