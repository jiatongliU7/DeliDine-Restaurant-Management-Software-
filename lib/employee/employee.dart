import 'package:cloud_firestore/cloud_firestore.dart';

class Employee {
  String name;
  String lastName;
  String phoneNumber;
  String email;
  List availability;
  Map<String, dynamic> schedule; // Assuming keys and values are strings
  Map<String, dynamic> timesheet; // key: clock-in-time, value: clock-out-time
  DateTime? currentClockIn;
  DateTime? currentClockOut;
  String? role;
  Map<String, dynamic> timeOff; // Assuming keys are strings and values can be dynamic
  String uid;

  Employee({
    required this.name,
    required this.lastName,
    required this.email,
    required this.role,
    required this.uid,
    this.phoneNumber = '',
    this.availability = const [],
    this.schedule = const {},
    this.timesheet = const {},
    this.timeOff = const {},
  });

  void clockIn() {
    currentClockIn = DateTime.now();
    print('Clocked in at $currentClockIn');
  }

  void clockOut() async {
    DateTime currentTime = DateTime.now();

    if (currentClockIn != null && currentClockOut == null && currentTime.isAfter(currentClockIn!)) {
      String currentClockInString = currentClockIn!.toIso8601String();
      timesheet[currentClockInString] = currentTime.toIso8601String();

      // Update Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('timesheet')
          .doc(currentClockInString)
          .set({
        'clockIn': currentClockInString,
        'clockOut': currentTime.toIso8601String(),
      });

      // Reset current clock-in and clock-out times
      currentClockIn = null;
      currentClockOut = null;
    } else if (currentClockIn == null) {
      print('Error, User is not clocked in!');
    } else {
      print('Error: Invalid clock-out time. It should be after clock-in time');
    }
  }

  void setAvailability(List newAvailability) {
    availability = newAvailability;
  }

  void requestTimeOff(DateTime start, DateTime end) {
    print('Time off request sent for $start to $end');
  }

  factory Employee.fromMap(Map<String, dynamic> data, String uid) {
    return Employee(
      name: data['name'] ?? '',
      lastName: data['lastName'] ?? '',
      email: data['email'] ?? '',
      role: data['role'] ?? '',
      uid: uid,
      phoneNumber: data['phoneNumber'] ?? '',
      availability: data['availability'] ?? [],
      schedule: data['schedule'] ?? {},
      timesheet: data['timesheet'] ?? {},
      timeOff: data['timeOff'] ?? {},
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'email': email,
      'role': role,
      'uid': uid,
      'availability': availability,
      'schedule': schedule,
      'timesheet': timesheet,
      'timeOff': timeOff,
    };
  }

  Future<void> saveToFirestore() async {
    final firestore = FirebaseFirestore.instance;
    DocumentReference userDoc = firestore.collection('users').doc(uid);
    await userDoc.set(toMap());

    // Save subcollections
    await userDoc.collection('availability').doc('availability').set({
      'days': availability,
    });
    await userDoc.collection('schedule').doc('schedule').set(schedule);
    await userDoc.collection('timesheet').doc('timesheet').set(timesheet.map((key, value) =>
        MapEntry(key, {'clockOut': value})));
    await userDoc.collection('timeOff').doc('timeOff').set(timeOff);
  }

  @override
  String toString() {
    return "User $name $lastName, Phone: $phoneNumber, Email: $email";
  }
}
