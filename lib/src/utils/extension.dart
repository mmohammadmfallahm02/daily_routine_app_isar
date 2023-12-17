import 'package:flutter/material.dart';

extension TimeFormatter on TimeOfDay {
  String timeToString() => '$hour:$minute ${period.name}';
}

extension StringFormatter on String {
  TimeOfDay stringToTime() {
    final List<String> parts = split(' ');
    final List<String> timeParts = parts[0].split(':');

    int hour = int.parse(timeParts[0]);
    int minute = int.parse(timeParts[1]);

    return TimeOfDay(hour: hour, minute: minute)..period;
  }
}
