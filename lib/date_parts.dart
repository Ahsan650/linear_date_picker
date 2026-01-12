/// Represents the parts of a date (day, month, year).
class DateParts {
  /// The day of the month (1-31).
  int day;

  /// The month (1-12).
  int month;

  /// The year.
  int year;

  /// Creates a [DateParts] instance.
  ///
  /// All parameters are required.
  DateParts({required this.day, required this.month, required this.year});
}
