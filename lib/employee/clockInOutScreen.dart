import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'employee.dart';

class ClockInOutPage extends StatefulWidget {
  ClockInOutPage({Key? key, required this.employee}) : super(key: key);
  final Employee employee;

  @override
  _ClockInOutPageState createState() => _ClockInOutPageState();
}

class _ClockInOutPageState extends State<ClockInOutPage> {
  void clockIn() {
    DateTime now = DateTime.now();
    widget.employee.currentClockIn = now;
    widget.employee.timesheet[now.toIso8601String()] = Timestamp.fromDate(now);
    setState(() {});
    _updateTimesheet();
  }

  void clockOut() {
    DateTime now = DateTime.now();
    if (widget.employee.currentClockIn != null) {
      widget.employee.timesheet[widget.employee.currentClockIn!.toIso8601String()] = Timestamp.fromDate(now);
      widget.employee.currentClockOut = now;
      setState(() {});
      _updateTimesheet();
    }
  }

  void _updateTimesheet() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.employee.uid)
        .update({
      'timesheet': widget.employee.timesheet,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Clock In/Out App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Clock-In Time:',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),
            Text(
              widget.employee.currentClockIn != null
                  ? DateFormat('hh:mm:ss a').format(widget.employee.currentClockIn!)
                  : 'Not clocked in',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),
            Text(
              'Clock-Out Time:',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),
            Text(
              widget.employee.currentClockOut != null
                  ? DateFormat('hh:mm:ss a').format(widget.employee.currentClockOut!)
                  : 'Not clocked out',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                if (widget.employee.currentClockIn == null) {
                  clockIn();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Already clocked in.'),
                    ),
                  );
                }
              },
              child: Text('Clock In'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (widget.employee.currentClockIn == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('You must clock in first.'),
                    ),
                  );
                } else if (widget.employee.currentClockOut != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Already clocked out.'),
                    ),
                  );
                } else {
                  clockOut();
                }
              },
              child: Text('Clock Out'),
            ),
          ],
        ),
      ),
    );
  }
}
