import 'package:flutter/cupertino.dart';
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
    // TODO: implement initState
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
          padding: const EdgeInsets.only(top: 50),
          child: Column(
            children: <Widget>[
              Text(widget.employee.name,
                style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
              Text(widget.employee.lastName,
                style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
              Text(widget.employee.role!,
                style: const TextStyle(fontSize: 30, fontStyle: FontStyle.italic),),
              Padding(
                padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Column(
                    children: [
                      const Text('Contact',
                      style: TextStyle(
                        fontSize: 30, fontWeight: FontWeight.bold
                      ),),
                      Container(
                        height: 2,
                        width: width,
                        color: Colors.black,
                      )
                    ],
                  ),
              )
              )
            ],

          )
        )
      ),
    );
  }
}
