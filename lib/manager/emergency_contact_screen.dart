import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import 'package:restaurantsoftware/employee/employee.dart';
import 'package:restaurantsoftware/employee/profile.dart';
import 'package:restaurantsoftware/employee/timesheet.dart';
import 'package:restaurantsoftware/employee/availabilityScreen.dart';
import 'package:restaurantsoftware/manager/employeeProfile.dart';

import '../firebase/authentication.dart';
import '../firebase/db.dart';
import 'package:flutter/foundation.dart';
class EmergencyContactPage extends StatefulWidget {
  const EmergencyContactPage({super.key});

  @override
  State<EmergencyContactPage> createState() => _EmergencyContactPageState();
}

class _EmergencyContactPageState extends State<EmergencyContactPage> {
  Map data = {};
  List<String> items = [];
  List<String> duplicateItems = [];
  List<Employee> duplicateEmployeeInfo = [];
  List<Employee> employeeInfo = [];
  TextEditingController editingController = TextEditingController();
  bool isLoading = true;
  String selectedDay = 'All';
  List<String> weekDays = <String>[
    'All',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  @override
  void initState() {
    super.initState();
    getEmployeeData();
  }

  void getEmployeeData() {
    getUsersInfo().then((value) => setState(() {
      data = value!;
      data.forEach((uid, value) {
        if(value['role'] != 'Manager'){
          debugPrint(value.toString());
          duplicateItems.add(value['name'] + ' ' + value['lastName']);
          duplicateEmployeeInfo.add(
            Employee(
                name: value['name'],
                lastName: value['lastName'],
                email: value['email'],
                role: value['role'],
                availability: value['Availability'],
                phoneNumber: value['phoneNumber'],
                timeOff: value['timeOff'],
                timesheet: value['timesheet'],
                schedule: value['schedule'],
                uid: uid)
          );
        }
      });
      setState(() {
        items = duplicateItems;
        employeeInfo = duplicateEmployeeInfo;
        isLoading = false;
        print(employeeInfo);
      });
    }));
  }

  void filterSearchResults(String query) {
  items = [];
  setState(() {
    for(int i = 0; i < duplicateItems.length; i++){
      if(duplicateItems[i].toLowerCase().contains(query.toLowerCase())){
        int indexWeekDay = weekDays.indexOf(selectedDay) - 1;
        //change this to work with timestamps throughout the day not only the whole day
        if(selectedDay == 'All' || duplicateEmployeeInfo[i].availability[indexWeekDay]['selectedDay']){
          items.add(duplicateItems[i]);
          employeeInfo.add(duplicateEmployeeInfo[i]);
        }
      }
    }
  });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Emergency Contact')),
      body: Center(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8),
              child: TextField(
                onChanged: (value) {
                  filterSearchResults(value);
                },
                controller: editingController,
                decoration: const InputDecoration(
                  labelText: 'Search',
                  hintText: 'Search',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                  )
                )
              )
            ),
            Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text('Filter by Day:'),
                    SizedBox(width: 10,),
                    DropdownButton<String>(
                      value: selectedDay,
                      onChanged: (String? newValue){
                        setState(() {
                          selectedDay = newValue!;
                          filterSearchResults('');
                        });
                      },
                      items: weekDays.map<DropdownMenuItem<String>>((String value){
                        return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value)
                        );
                      }).toList(),
                    )
                  ],
                )
            ),
            Expanded(
                child: isLoading ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                    ],
                  ),
                )
                    : Padding(
                    padding: const EdgeInsets.all(8),
                    child: items.isNotEmpty
                    ?
                        ListView.builder(shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: ListTile(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            EmployeeProfilePage(employee: employeeInfo[index])
                                    )
                                );
                              },
                              title: Text('${items[index]}',
                                style:  const TextStyle(fontSize: 20),
                              ),
                              subtitle: Text(
                                'Works as: ${employeeInfo[index].role}',
                                style:  const TextStyle(fontSize: 18),
                              ),
                              trailing: Icon(Icons.arrow_forward_ios_sharp),
                            ),
                          );
                        },
                        )
                        : Center(child: const Text('No Match'),)
                )
            ),
          ]
        )
      )
    );
  }
}

