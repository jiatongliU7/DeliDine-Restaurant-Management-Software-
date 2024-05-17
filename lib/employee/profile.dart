import 'package:flutter/material.dart';
import 'package:restaurantsoftware/employee/availabilityScreen.dart';
import 'package:restaurantsoftware/employee/contact.dart';
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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.green,
                  child: Text(
                    '${widget.employee.name[0]}${widget.employee.lastName[0]}',
                    style: TextStyle(fontSize: 40, color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: Column(
                  children: [
                    Text(
                      '${widget.employee.name} ${widget.employee.lastName}',
                      style: const TextStyle(
                          fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Works as ${widget.employee.role}',
                      style: const TextStyle(
                          fontSize: 25, fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              Divider(),
              Text(
                'Contact Information',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              ListTile(
                leading: Icon(Icons.email),
                title: Text(widget.employee.email),
              ),
              ListTile(
                leading: Icon(Icons.phone),
                title: Text(widget.employee.phoneNumber.isNotEmpty
                    ? widget.employee.phoneNumber
                    : 'Not Provided'),
              ),
              SizedBox(height: 30),
              Divider(),
              Center(
                child: Column(
                  children: [

                    SizedBox(
                      height: 54,
                      width: width * 0.75,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ContactPage(
                                    employee: widget.employee,
                                  )));
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF276B27),
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(24.0)))),
                        child: const Text(
                          'Contact',
                          style: TextStyle(fontSize: 24, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
