import 'package:flutter/material.dart';
import 'package:restaurantsoftware/loginPage.dart';
import 'package:restaurantsoftware/manager/emergency_contact_screen.dart';
import 'package:restaurantsoftware/manager/signup_screen.dart';
import 'package:restaurantsoftware/manager/weekly_schedule.dart';
import 'package:restaurantsoftware/firebase/authentication.dart';

class RouteManagerPage extends StatefulWidget {
  const RouteManagerPage({Key? key}) : super(key: key);

  @override
  State<RouteManagerPage> createState() => _RouteManagerPageState();
}

class _RouteManagerPageState extends State<RouteManagerPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> _buildBody() {
    return [
      WeeklySchedulePage(),
      EmergencyContactPage(),
      Signup(), // Add User Page
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manager Dashboard'),
        automaticallyImplyLeading: false,
        leading: Container(),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              AuthenticationHelper().signOut().then((value) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()), // Replace with your login screen
                      (route) => false,
                );
              });
            },
          ),
        ],
      ),
      body: _buildBody()[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Weekly Schedule',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contact_page),
            label: 'Emergency Contact',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_add),
            label: 'Add User',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}
