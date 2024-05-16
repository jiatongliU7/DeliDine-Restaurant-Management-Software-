import 'package:flutter/material.dart';
import 'package:restaurantsoftware/employee/availabilityScreen.dart';
import 'package:restaurantsoftware/employee/clockInOutScreen.dart';
import 'package:restaurantsoftware/employee/employee.dart';
import 'package:restaurantsoftware/employee/profile.dart';
import 'package:restaurantsoftware/employee/timesheet.dart';
import 'package:restaurantsoftware/firebase/authentication.dart';
import 'package:restaurantsoftware/firebase/db.dart';

class RouteEmployeePage extends StatefulWidget {
  const RouteEmployeePage({Key? key}) : super(key: key);

  @override
  State<RouteEmployeePage> createState() => _RouteEmployeePageState();
}

class _RouteEmployeePageState extends State<RouteEmployeePage> {
  Employee? employee;
  int _selectedIndex = 0;

  @override
  void initState() {
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
          uid: uid,
          name: info['name'],
          lastName: info['lastName'],
          email: info['email'],
          role: info['role'],
          phoneNumber: info['phoneNumber'],
          availability: info['Availability'] ?? [],
          timesheet: info['timesheet'] ?? {},
          timeOff: info['Time Off'] ?? {},
          schedule: info['schedule'] ?? {},
        );
      }
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> _buildBody() {
    return [
      ClockInOutPage(employee: employee!),
      TimesheetPage(employee: employee!),
      AvailabilityPage(employee: employee!, isEdited: false),
      ProfilePage(employee: employee!),
    ];
  }

  @override
  Widget build(BuildContext context) {
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
      body: _buildBody()[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time),
            label: 'Clock In/Out',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.schedule),
            label: 'Timesheet',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.av_timer),
            label: 'Availability',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF276B27),
        onTap: _onItemTapped,
      ),
    );
  }
}
