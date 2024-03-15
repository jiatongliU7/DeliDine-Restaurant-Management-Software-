import 'package:cloud_firestore/cloud_firestore.dart';

class Employee{
  String name;
  String lastName;
  String phoneNumber;
  String email;
  List availability;
  Map schedule;
  Map timesheet; //Key: clock-in-time, value: clock-out-time
  DateTime? currentClockIn;
  DateTime? currentClockOut;
  String? role;
  Map timeOff;
  String uid;

  Employee(
  {
  required this.name,
  required this.lastName,
    required this.email,
    required this.role,
    required this.uid,
    this.phoneNumber = '',
    this.availability = const [],
    this.schedule = const {},
    this.timesheet = const {},
    this.timeOff = const {}
  });

  void clockIn(){
    currentClockIn = DateTime.now();
  }
  void clockOut() {
    DateTime currentTime = DateTime.now();

    if(currentClockIn != null &&
    currentClockOut == null &&
    currentTime.isAfter(currentClockIn!)) {
      String currentClockInString = currentClockIn!.toIso8601String();
      timesheet[currentClockIn] = Timestamp.fromDate(currentTime);
    }
    else if(currentClockIn == null){
      print('Error, User is not clocked in!');
    }
    else {
      print('Error: Invalid clock-out time. It should be after clock-in time');
    }
  }
  void setAvailability(List newAvailability){
    availability = newAvailability;
  }
  //remember to update
  void requestTimeOff(DateTime start, DateTime end){
    print('Time off request sent for $start to $end');
  }
  Map<String, dynamic> toMap() {
    return {
      'name' : name,
      'lastname' : lastName,
      'phoneNumber' : phoneNumber,
      'email': email,
      'Availability' : availability,
      'timesheet': timesheet.map((key, value) =>
          MapEntry(key.toIso8601String(), value.toIso8601String())),
      'role': role,
      'TimeOff' : timeOff,
      'schedule' : schedule
    };
  }
  @override
  String toString(){
    return "User $name $lastName, Phone: $phoneNumber, Email: $email";
  }

}