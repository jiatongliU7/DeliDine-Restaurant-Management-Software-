import 'package:flutter/material.dart';
import 'package:restaurantsoftware/employee/employee.dart';

class EmployeeProfilePage extends StatefulWidget {
  const EmployeeProfilePage({super.key, required this.employee});
  final Employee employee;

  @override
  State<EmployeeProfilePage> createState() => _EmployeeProfilePageState();
}

class _EmployeeProfilePageState extends State<EmployeeProfilePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
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
            ],
          ),
        ),
      ),
    );
  }
}
