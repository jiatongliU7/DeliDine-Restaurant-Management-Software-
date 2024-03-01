import 'package:flutter/material.dart';
import 'package:restaurantsoftware/model/timebox.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class MyCalendar extends StatefulWidget{
  const MyCalendar({Key? key}) : super(key:key);
  @override
  _MyCalendar createState() => _MyCalendar();
}

class _MyCalendar extends State<MyCalendar> {


   @override
  Widget build(BuildContext context)
   {
     return Scaffold(
       body: SfCalendar(
         view: CalendarView.week,
           dataSource: ShiftDataSource(_getDataSource())));
   }
   List<TimeBox> _getDataSource() {
     final List<TimeBox> shifts = <TimeBox>[];
     final DateTime today = DateTime.now();
     final DateTime startTime = DateTime(today.year, today.month, today.day, 9);
     final DateTime endTime = startTime.add(const Duration(hours: 8));
     shifts.add(TimeBox('Opening', startTime, endTime, Colors.green));
     return shifts;
   }
}

class ShiftDataSource extends CalendarDataSource{
  ShiftDataSource(List<TimeBox> source) {
    appointments = source;
  }
  @override
  DateTime getStartTime(int index) {
    return _getShiftData(index).from;
  }
  @override
  DateTime getEndTime(int index)
  {
    return _getShiftData(index).to;
  }
  @override
  String getSubject(int index){
    return _getShiftData(index).shiftName;
  }
  TimeBox _getShiftData(int index){
    final dynamic timebox = appointments![index];
    late final TimeBox timeBoxData;
    if(timebox is TimeBox){
      timeBoxData = timebox;
    }
    return timeBoxData;
  }

}