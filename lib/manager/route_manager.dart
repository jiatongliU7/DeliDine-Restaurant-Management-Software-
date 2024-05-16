import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:restaurantsoftware/manager/emergency_contact_screen.dart';
import 'package:restaurantsoftware/manager/signup_screen.dart';
import 'package:restaurantsoftware/employee/weekly_schedule.dart';
import '/firebase/authentication.dart';

class RouteManagerPage extends StatefulWidget {
  const RouteManagerPage({Key? key}) : super(key: key);

  @override
  State<RouteManagerPage> createState() => _RouteManagerPageState();
}

class _RouteManagerPageState extends State<RouteManagerPage> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
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
                Navigator.of(context).pop();
              });
            },
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: [
          WeeklySchedulePage(),
          EmergencyContactPage(),
          Signup(), // Add User Page
        ],
      ),
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
        onTap: _onItemTapped,
      ),
    );
  }
}
