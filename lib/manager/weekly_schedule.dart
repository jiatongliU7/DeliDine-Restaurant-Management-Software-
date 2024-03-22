import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:restaurantsoftware/date_time_selector.dart';
import 'package:restaurantsoftware/employee/employee.dart';
import 'package:restaurantsoftware/firebase/db.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../Meeting.dart';

class WeeklySchedulePage extends StatefulWidget {
  const WeeklySchedulePage({super.key});

  @override
  State<WeeklySchedulePage> createState() => _WeeklySchedulePageState();
}

class _WeeklySchedulePageState extends State<WeeklySchedulePage> {
  List<Meeting> meetings = <Meeting>[];
  List<Employee> employeeList = [];

  @override
  void initState(){
    super.initState();
    _getEmployeeData();
  }

  void _getEmployeeData() {
    employeeList = [];
    getUsersInfo().then((value) => setState(
        () {
          value!.forEach((uid, value) {
            if(value['role'] != 'Manager'){
              debugPrint(value.toString());

              employeeList.add(Employee(
                  name: value['name'],
                  lastName: value['lastName'],
                  email: value["email"],
                  role: value['role'],
                  uid: uid,
                  availability: value['availability'],
                  phoneNumber: value['phoneNumber'],
                  timeOff: value['timeOff'],
                  timesheet: value['timesheet'],
                  schedule: value['schedule']
              ));
            }
          });
          _setDataSource();
        }
    ));
  }
  void _setDataSource(){
    meetings = [];
    for(Employee employee in employeeList){
      employee.schedule.forEach((key, date) {
        DateTime startTime = date['startTime'].toDate();
        DateTime endTime = date['endTime'].toDate();

        Meeting meeting = Meeting(
          '${employee.name} ${employee.lastName}',
        startTime, endTime,
        Colors.green,
        false,
        );
        meetings.add(meeting);
      });
    }
  }
  void _showUpdateAvailableTimeDialog(BuildContext context, Meeting meeting){
    DateTime startTime = meeting.from;
    DateTime endTime = meeting.to;
    showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
        title: const Text('Update Schedule Time'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              DateTimeSelectorFormField(
                labelText: 'Start Time',
                initialDateTime: startTime,
                onSelect: (date) {
                    if(date!.isAfter(endTime)){
                      endTime = date.add(const Duration(minutes: 1));
                    }
                    startTime = date;

                    if(mounted) {
                      setState(() {

                      });
                    }
                },
                type: DateTimeSelectionType.time,
              ),
              DateTimeSelectorFormField(
                  labelText: 'End Time',
                  initialDateTime: endTime,
                  onSelect: (date){
                    if(date!.isBefore(startTime)) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('End time is less than start time.')));
                    }
                    else{
                      endTime = date;
                    }
                  },
                  type: DateTimeSelectionType.time,
                  ),
            ],
          ),
        ),
        actions: [
          TextButton( onPressed: () {
            // Create the new item using the entered values
            int index = meetings.indexOf(meeting);
            Map schedule = employeeList[index].schedule;
            String date = meeting.from.toLocal().toString().split(' ')[0];
            meeting.from = startTime;
            meeting.to = endTime;
            Map event = {};
            event['startTime'] = Timestamp.fromDate(startTime);
            event['endTime'] = Timestamp.fromDate(endTime);
            schedule[date] = event;
            addEvents({'schedule': schedule}, employeeList[index].uid);
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
          )
        ],
      );
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 15.0),
        child: SfCalendar(
          allowAppointmentResize: true,
          view: CalendarView.week,
          firstDayOfWeek: 2,
          todayHighlightColor: Colors.red,
          cellBorderColor: Colors.blue,
          dataSource: MeetingDataSource(meetings),
          selectionDecoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(color: Colors.red, width: 2),
            borderRadius: const BorderRadius.all(Radius.circular(4)),
            shape: BoxShape.rectangle,
          ),
          onTap: (CalendarTapDetails details) {
            if(details.targetElement == CalendarElement.calendarCell){
              DateTime tappedTime = details.date!;
              print(tappedTime);
            } else if(details.targetElement == CalendarElement.appointment){
              DateTime tappedTime = details.date!;
              print(tappedTime);

              Meeting meeting = details.appointments![0];

              _showUpdateAvailableTimeDialog(context, meeting);
              Future.delayed(const Duration(milliseconds: 100), () {
                setState(() {

                });
              });
            }
          },
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
          CupertinoPageRoute(builder: (context) => AddScheduleForm()))
              .then((value) {
                _getEmployeeData();
                Future.delayed(const Duration(milliseconds: 100), () {
                  setState(() {

                  });
                });
          });
        },
        child: Icon(Icons.add_box_rounded)
      ),
    );
  }
}
