import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../date_time_selector.dart';
import '../firebase/db.dart';
import '../meeting.dart';
import 'addAvailability.dart';
import 'employee.dart';

/// The hove page which hosts the calendar
class AvailabilityPage extends StatefulWidget {
  /// Creates the home page to display teh calendar widget.
  const AvailabilityPage(
      {Key? key, required this.employee, required this.isEdited})
      : super(key: key);
  final Employee employee;
  final bool isEdited;

  @override
  // ignore: library_private_types_in_public_api
  _AvailabilityPageState createState() => _AvailabilityPageState();
}

class _AvailabilityPageState extends State<AvailabilityPage> {
  List<Meeting> meetings = <Meeting>[];
  DateTime? weekStartDate;
  DateTime? weekEndDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 15.0),
        child: SfCalendar(
          view: CalendarView.week,
          firstDayOfWeek: 1,
          // Sunday
          todayHighlightColor: Colors.red,
          cellBorderColor: Colors.blue,
          // view: CalendarView.month,
          dataSource: MeetingDataSource(meetings),
          selectionDecoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(color: Colors.red, width: 2),
            borderRadius: const BorderRadius.all(Radius.circular(4)),
            shape: BoxShape.rectangle,
          ),
          onTap: (CalendarTapDetails details) {
            if (details.targetElement == CalendarElement.calendarCell) {
              // User tapped on a calendar cell (date)
              DateTime tappedDate = details.date!;
              print(tappedDate);
              // Handle the tapped date as needed
            } else if (details.targetElement == CalendarElement.appointment) {
              // User tapped on an appointment
              Meeting meeting = details.appointments![0];
              // print(meeting.toString());
              // print(meetings.contains(meeting));
              // Handle the tapped appointment as needed
              if (meeting.eventName == 'Availability') {
                _showUpdateAvailableTimeDialog(context, meeting);
                // Future.delayed(const Duration(milliseconds: 100), () {
                //   setState(() {});
                // });
              }
            }
          },

          onViewChanged: (ViewChangedDetails details) {
            // This callback is triggered when the calendar view changes,
            // such as when the user moves to another week.
            weekStartDate =
                details.visibleDates.first.subtract(const Duration(days: 1));
            weekEndDate = details.visibleDates.last.add(const Duration(days: 1));

            // Now you have the start and end dates of the currently visible week.
            print('Start Date: $weekStartDate');
            print('End Date: $weekEndDate');

            _addAllEventsForSelectedWeekdays(weekStartDate!, weekEndDate!);
            Future.delayed(const Duration(milliseconds: 100), () {
              setState(() {});
            });
          },

          // // by default the month appointment display mode set as Indicator, we can
          // // change the display mode as appointment using the appointment display
          // // mode property
          //
          // monthViewSettings: const MonthViewSettings(
          //     appointmentDisplayMode: MonthAppointmentDisplayMode.appointment),
        ),
      ),
      floatingActionButton: widget.isEdited
          ? FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (context) => AddOrEditScheduleForm(
                      employee: widget.employee,
                    )));
          },
          child: const Icon(Icons.add_box_rounded))
          : null,
    );
  }

  void _showUpdateAvailableTimeDialog(BuildContext context, Meeting meeting) {
    int weekDayIndex = meeting.from.weekday - 1;
    DateTime startTime = meeting.from;
    DateTime endTime = meeting.to;
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Update Available Time'),
          content: SingleChildScrollView(
              child: Column(
                children: [
                  DateTimeSelectorFormField(
                    labelText: "Start Time",
                    initialDateTime: startTime,
                    onSelect: (date) {
                      // Handle start time selection
                      if (date!.isAfter(endTime)) {
                        endTime = date.add(const Duration(minutes: 1));
                      }
                      startTime = date!;

                      if (mounted) {
                        setState(() {});
                      }
                    },
                    type: DateTimeSelectionType.time,
                  ),
                  DateTimeSelectorFormField(
                    labelText: "End Time",
                    initialDateTime: endTime,
                    onSelect: (date) {
                      // Handle end time selection
                      if (date!.isBefore(startTime)) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('End time is less than start time.'),
                        ));
                      } else {
                        endTime = date;
                      }
                    },
                    type: DateTimeSelectionType.time,
                  ),
                ],
              )),
          actions: [
            TextButton(
              onPressed: () {
                // Create the new item using the entered values
                Map availability = widget.employee.availability[weekDayIndex];
                meeting.from = startTime;
                meeting.to = endTime;
                availability['startTime'] = Timestamp.fromDate(startTime);
                availability['endTime'] = Timestamp.fromDate(endTime);
                addEvents({'Availability': widget.employee.availability},
                    widget.employee.uid);
                // Close the dialog
                setState(() {});
                Navigator.of(context).pop();
              },
              child: const Text('Update Availability'),
            ),
            TextButton(
              onPressed: () {
                // Close the dialog without adding an item
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  _addAllEventsForSelectedWeekdays(
      DateTime weekStartDate, DateTime weekEndDate) {
    meetings = [];

    _addEventsForSelectedWeekdays(weekStartDate, weekEndDate,
        widget.employee.availability, Colors.blue, 'Availability');
    _addSchedule();
    _addTimeOff();
  }

  _addTimeOff() {
    if (widget.employee.timeOff.isNotEmpty) {
      DateTime currentDate = widget.employee.timeOff['startDate'].toDate();
      DateTime endDate = widget.employee.timeOff['endDate']
          .toDate()
          .add(const Duration(days: 1));

      while (currentDate.isBefore(endDate)) {
        Meeting meeting = Meeting(
          'Time Off', // You can set the title as needed
          currentDate, currentDate,
          Colors.yellow,
          true,
        );
        meetings.add(meeting);
        currentDate = currentDate.add(const Duration(days: 1));
      }
    }
  }

  _addSchedule() {
    widget.employee.schedule.forEach((key, date) {
      DateTime startTime = date['startTime'].toDate();
      DateTime endTime = date['endTime'].toDate();

      Meeting meeting = Meeting(
        'Schedule', // You can set the title as needed
        startTime, endTime,
        Colors.green,
        false,
      );
      meetings.add(meeting);
    });
  }

  _addEventsForSelectedWeekdays(
      DateTime weekStartDate, DateTime weekEndDate, events, color, title) {
    if (widget.employee.timeOff.isNotEmpty) {
      DateTime startDate = widget.employee.timeOff['startDate']
          .toDate()
          .subtract(const Duration(days: 1));
      DateTime endDate = widget.employee.timeOff['endDate']
          .toDate()
          .add(const Duration(days: 1));
      for (int i = 0; i < events.length; i++) {
        if (events[i]['selectedDay']) {
          // Calculate the date for the selected day within the specified week
          final DateTime selectedDate =
          weekStartDate.add(Duration(days: i + 1));
          // Check if the selected date is within the specified week's range
          if (!(selectedDate.isAfter(startDate) &&
              selectedDate.isBefore(endDate)) &&
              selectedDate.isAfter(weekStartDate) &&
              selectedDate.isBefore(weekEndDate)) {
            DateTime startTime = events[i]['startTime'].toDate();

            DateTime endTime = events[i]['endTime'].toDate();
            final Meeting meeting = Meeting(
              title, // You can set the title as needed
              DateTime(
                selectedDate.year,
                selectedDate.month,
                selectedDate.day,
                startTime.hour,
                startTime.minute,
              ),
              DateTime(
                selectedDate.year,
                selectedDate.month,
                selectedDate.day,
                endTime.hour,
                endTime.minute,
              ),
              color,
              false,
            );

            meetings.add(meeting);
            // print(meetings);
          }
        }
      }
    } else {
      for (int i = 0; i < events.length; i++) {
        if (events[i]['selectedDay']) {
          // Calculate the date for the selected day within the specified week
          final DateTime selectedDate =
          weekStartDate.add(Duration(days: i + 1));
          // Check if the selected date is within the specified week's range
          if (selectedDate.isAfter(weekStartDate) &&
              selectedDate.isBefore(weekEndDate)) {
            DateTime startTime = events[i]['startTime'].toDate();

            DateTime endTime = events[i]['endTime'].toDate();
            final Meeting meeting = Meeting(
              title, // You can set the title as needed
              DateTime(
                selectedDate.year,
                selectedDate.month,
                selectedDate.day,
                startTime.hour,
                startTime.minute,
              ),
              DateTime(
                selectedDate.year,
                selectedDate.month,
                selectedDate.day,
                endTime.hour,
                endTime.minute,
              ),
              color,
              false,
            );

            meetings.add(meeting);
            // print(meetings);
          }
        }
      }
    }
  }
}