import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'employee.dart'; // Import your Employee class

class TimesheetPage extends StatelessWidget {
  final Employee employee;

  TimesheetPage({required this.employee});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _buildTimesheetEntries(),
      ),
    );
  }

  Widget _buildTimesheetEntries() {
    List<MapEntry<String, DateTime>> sortedEntries = [];
    List<Widget> entries = [];

    if (employee.timesheet.isEmpty) {
      return Center(
        child: Text(
          'No timesheet available',
          style: TextStyle(fontSize: 30),
        ),
      );
    }

    employee.timesheet.forEach((key, value) {
      final clockInTime = DateTime.parse(key);
      final formattedDate = DateFormat('MM/dd/yyyy').format(clockInTime);
      sortedEntries.add(MapEntry(formattedDate, clockInTime));
    });

    sortedEntries.sort((a, b) => b.value.compareTo(a.value));
    print(sortedEntries);

    for (var entry in sortedEntries) {
      final formattedClockInTime = DateFormat('hh:mm:ss a').format(entry.value);
      final timestamp = employee.timesheet[entry.value.toIso8601String()];
      if (timestamp is Timestamp) {
        final clockOutTime = timestamp.toDate();
        final formattedClockOutTime = DateFormat('hh:mm:ss a').format(clockOutTime);

        entries.add(Card(
          child: ListTile(
            title: Text(entry.key),
            subtitle: Text(
              ' Clock In: $formattedClockInTime\n Clock Out: $formattedClockOutTime\n ',
            ),
          ),
        ));
      } else {
        // Handle the case where timestamp is not of type Timestamp
        entries.add(Card(
          child: ListTile(
            title: Text(entry.key),
            subtitle: Text(
              ' Clock In: $formattedClockInTime\n Clock Out: Invalid Timestamp\n ',
            ),
          ),
        ));
      }
    }

    return ListView(children: entries);
  }
}
