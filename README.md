# Linear Date Picker

A beautiful and customizable linear date picker widget for Flutter that displays month, day, and year in separate scrollable columns with a highlighted selection bar.

![Linear Date Picker](screenshot.png)

## Features

- 🎨 **Customizable Design**: Customize decorations, text styles, and labels for each column
- 📅 **Flexible Date Selection**: Support for date ranges with `startDate` and `endDate`
- 🎯 **Initial Date**: Set an initial selected date
- 🔄 **Debounced Updates**: Configurable debounce duration for date change callbacks
- 🌍 **Localization Support**: Custom month names and labels
- 📱 **Responsive**: Adjustable column widths
- ⚡ **Lightweight**: Minimal dependencies, built with Flutter SDK only

## Getting started

Add this package to your `pubspec.yaml`:

```yaml
dependencies:
  linear_date_picker: ^0.0.2
```

Then run:

```bash
flutter pub get
```

## Usage

### Basic Usage

```dart
import 'package:linear_date_picker/linear_date_picker.dart';

LinearDatePicker(
  dateChangeListener: (DateTime date) {
    print('Selected date: $date');
  },
)
```

### Advanced Usage with Customization

```dart
LinearDatePicker(
  initialDate: DateTime(2008, 1, 1),
  startDate: DateTime(2000, 1, 1),
  endDate: DateTime(2020, 12, 31),
  dateChangeListener: (DateTime date) {
    print('Selected date: $date');
  },
  showDay: true,
  showLabels: true,
  columnWidth: 80.0,
  yearLabel: 'Year',
  monthLabel: 'Month',
  dayLabel: 'Day',
  // Custom decorations
  yearDecoration: BoxDecoration(
    color: Colors.red,
    borderRadius: BorderRadius.circular(8),
  ),
  monthDecoration: BoxDecoration(
    color: Colors.blue,
    borderRadius: BorderRadius.circular(8),
  ),
  dayDecoration: BoxDecoration(
    color: Colors.green,
    borderRadius: BorderRadius.circular(8),
  ),
  // Custom text styles
  labelStyle: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  ),
  selectedRowStyle: TextStyle(
    color: Colors.white,
    fontSize: 18,
    fontWeight: FontWeight.bold,
  ),
  unselectedRowStyle: TextStyle(
    color: Colors.grey,
    fontSize: 16,
  ),
  // Debounce duration
  debounceDuration: Duration(milliseconds: 300),
  // Custom month names
  showMonthName: true,
  monthsNames: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 
                'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
)
```

### Month and Year Only (No Day)

```dart
LinearDatePicker(
  showDay: false,
  dateChangeListener: (DateTime date) {
    print('Selected month/year: ${date.month}/${date.year}');
  },
)
```

## Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `dateChangeListener` | `Function(DateTime)` | **Required** | Callback function called when date changes |
| `initialDate` | `DateTime?` | `null` | Initial selected date (defaults to current date) |
| `startDate` | `DateTime?` | `null` | Minimum selectable date |
| `endDate` | `DateTime?` | `null` | Maximum selectable date |
| `showDay` | `bool` | `true` | Whether to show the day column |
| `showLabels` | `bool` | `true` | Whether to show column labels |
| `columnWidth` | `double` | `55.0` | Width of each column |
| `yearLabel` | `String` | `'Year'` | Label for year column |
| `monthLabel` | `String` | `'Month'` | Label for month column |
| `dayLabel` | `String` | `'Day'` | Label for day column |
| `yearDecoration` | `Decoration?` | `null` | Decoration for year column selection bar |
| `monthDecoration` | `Decoration?` | `null` | Decoration for month column selection bar |
| `dayDecoration` | `Decoration?` | `null` | Decoration for day column selection bar |
| `labelStyle` | `TextStyle?` | `null` | Style for column labels |
| `selectedRowStyle` | `TextStyle?` | `null` | Style for selected row text |
| `unselectedRowStyle` | `TextStyle?` | `null` | Style for unselected row text |
| `debounceDuration` | `Duration?` | `200ms` | Debounce duration for date change callbacks |
| `showMonthName` | `bool` | `false` | Whether to show month names instead of numbers |
| `monthsNames` | `List<String>?` | `null` | Custom month names (requires 12 items) |

## Credits

This package is inspired by [flutter_linear_datepicker](https://pub.dev/packages/flutter_linear_datepicker) (version ^3.0.1).

## Additional information

For more information, issues, or contributions, please visit the [GitHub repository](https://github.com/ahsan-creates/linear_date_picker).
