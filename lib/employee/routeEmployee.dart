import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:restaurantsoftware/employee/availabilityScreen.dart';
import 'package:restaurantsoftware/employee/employee.dart';
import 'package:restaurantsoftware/employee/profile.dart';
import 'package:restaurantsoftware/employee/timesheet.dart';

import '../firebase/authentication.dart';
import '../firebase/db.dart';
//import 'clockINOutScreen.dart';

class RouteEmployeePage extends StatefulWidget {
  const RouteEmployeePage({Key? key}) : super(key: key);

  @override
  State<RouteEmployeePage> createState() => _RouteEmployeePageState();
}

class _RouteEmployeePageState extends State<RouteEmployeePage> {
  Employee? employee;

  @override
  initState() {
    super.initState();
    _getInfo();
  }

  _getInfo() async {
    Map? info = await getMyInfo();
    String uid = AuthenticationHelper().uid;
    print(info);
    setState(() {
      if (info != null) {
        employee = Employee(
            uid:uid,
            name: info['name'],
            lastName: info['lastName'],
            email: info['email'],
            role: info['role'],
            phoneNumber: info['phoneNumber'],
            availability: info['Availability'],
            timesheet: info['timesheet'],
            timeOff: info['Time Off'],
            schedule: info['schedule']);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery
        .of(context)
        .size
        .width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        automaticallyImplyLeading: false,
        leading: Container(),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              AuthenticationHelper()
                  .signOut()
                  .then((value) => Navigator.of(context).pop());
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 50.0),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 54,
                width: width * 0.75,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) =>
                    //             ClockInOutPage(employee: employee!)));
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF276B27),
                      shape: const RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.all(Radius.circular(24.0)))),
                  child: const Text(
                    'ClockIn & Clock Out',
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: SizedBox(
                  height: 54,
                  width: width * 0.75,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  TimesheetPage(employee: employee!)));
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF276B27),
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.all(Radius.circular(24.0)))),
                    child: const Text(
                      'Timesheet',
                      style: TextStyle(fontSize: 24, color: Colors.white),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: SizedBox(
                  height: 54,
                  width: width * 0.75,
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) =>
                      //             AvailabilityPage(
                      //               employee: employee!, isEdited: false,
                      //             )));
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF276B27),
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.all(Radius.circular(24.0)))),
                    child: const Text(
                      'Availability',
                      style: TextStyle(fontSize: 24, color: Colors.white),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: SizedBox(
                  height: 54,
                  width: width * 0.75,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ProfilePage(
                                    employee: employee!,
                                  )));
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF276B27),
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.all(Radius.circular(24.0)))),
                    child: const Text(
                      'Edit Profile',
                      style: TextStyle(fontSize: 24, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}