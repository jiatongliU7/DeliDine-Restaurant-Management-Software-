
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:restaurantsoftware/employee/availabilityScreen.dart';

import '../firebase/db.dart';
//import 'contact.dart';
import 'employee.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key, required this.employee}) : super(key: key);
  final Employee employee;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        automaticallyImplyLeading: false,
        leading: Container(),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 50.0),
          child: Column(
            children: <Widget>[
              Text(widget.employee.name,
                  style: const TextStyle(
                      fontSize: 30, fontWeight: FontWeight.bold)),
              Text(widget.employee.lastName,
                  style: const TextStyle(
                      fontSize: 30, fontWeight: FontWeight.bold)),
              Text('Work as ${widget.employee.role}',
                  style: const TextStyle(
                      fontSize: 25, fontStyle: FontStyle.italic)),
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
                      //         builder: (context) => AvailabilityPage(
                      //           isEdited: true,
                      //           employee: widget.employee,
                      //         )));
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
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => ContactPage(
                      //           employee: widget.employee,
                      //         )));
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF276B27),
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.all(Radius.circular(24.0)))),
                    child: const Text(
                      'Contact',
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
