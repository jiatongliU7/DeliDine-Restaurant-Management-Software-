import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:restaurantsoftware/firebase/db.dart';

import 'employee.dart';

class ClockInOutPage extends StatefulWidget {
  ClockInOutPage({Key? key, required this.employee}) : super(key: key);
  final Employee employee;

  @override
  _ClockInOutPageState createState() => _ClockInOutPageState();
}

class _ClockInOutPageState extends State<ClockInOutPage> {
  void clockIn() {
    widget.employee.clockIn();
    setState(() {});
  }

  void clockOut() {
    widget.employee.clockOut();
    setState(() {});
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
                  ? DateFormat('hh:mm:ss a')
                  .format(widget.employee.currentClockIn!)
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
                  ? DateFormat('hh:mm:ss a').format(
                  widget.employee.timesheet.entries.last.value.toDate())
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
                  Map timesheet = widget.employee.timesheet;
                  addEvents({'timesheet': timesheet}, widget.employee.uid);
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