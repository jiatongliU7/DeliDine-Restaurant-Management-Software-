import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '/firebase/authentication.dart';
//import '/manager/emergencyContactScreen.dart';
//import '/manager/weekly_schedule.dart';
//import 'signup_screen.dart';

class RouteManagerPage extends StatefulWidget {
  const RouteManagerPage({Key? key}) : super(key: key);

  @override
  State<RouteManagerPage> createState() => _RouteManagerPageState();
}

class _RouteManagerPageState extends State<RouteManagerPage> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        automaticallyImplyLeading: false,
        leading: Container(),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
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
                    //         builder: (context) => const WeeklySchedulePage()));
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF276B27),
                      shape: const RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.all(Radius.circular(24.0)))),
                  child: const Text(
                    'Weekly Schedule',
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
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) =>
                      //         const EmergencyContactPage()));
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF276B27),
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.all(Radius.circular(24.0)))),
                    child: const Text(
                      'Emergency Contact',
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
                      //         builder: (context) => const Signup()));
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF276B27),
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.all(Radius.circular(24.0)))),
                    child: const Text(
                      'Add User',
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