import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'employee.dart'; // Import your Employee class

class TimesheetPage extends StatelessWidget {
  final Employee employee;

  TimesheetPage({required this.employee});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Timesheet'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _buildTimesheetEntries(),
      ),
    );
  }

  Widget _buildTimesheetEntries() {
    List<MapEntry<String, DateTime>> sortedEntries = [];
    List<Widget> entries = [];
    // Iterate through the timesheet entries and create a list of key-value pairs
    // where the key is the formatted date and the value is the clock-in time

    if (employee.timesheet.isEmpty) {
      return Center(
          child: Text(
            'No timesheet available',
            style: TextStyle(fontSize: 30),
          ));
    }
    employee.timesheet.forEach((key, value) {
      final clockInTime = DateTime.parse(key);
      final formattedDate = DateFormat('MM/dd/yyyy').format(clockInTime);

      sortedEntries.add(MapEntry(formattedDate, clockInTime));
    });

    // Sort the list of entries based on the date
    sortedEntries.sort((a, b) => b.value.compareTo(a.value));
    print(sortedEntries);

    for (var entry in sortedEntries) {
      final formattedClockInTime = DateFormat('hh:mm:ss a').format(entry.value);
      final formattedClockOutTime = DateFormat('hh:mm:ss a')
          .format(employee.timesheet[entry.value.toIso8601String()].toDate());
      entries.add(Card(
        child: ListTile(
            title: Text(entry.key),
            subtitle: Text(
                ' Clock In: $formattedClockInTime\n Clock Out: $formattedClockOutTime\n ')),
      ));
    }

    return ListView(children: entries);
  }
}