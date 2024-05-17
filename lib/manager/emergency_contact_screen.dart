import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:restaurantsoftware/employee/employee.dart';
import 'package:restaurantsoftware/manager/employeeProfile.dart';

class EmergencyContactPage extends StatefulWidget {
  const EmergencyContactPage({super.key});

  @override
  State<EmergencyContactPage> createState() => _EmergencyContactPageState();
}

class _EmergencyContactPageState extends State<EmergencyContactPage> {
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

  void getEmployeeData() async {
    try {
      var snapshot = await FirebaseFirestore.instance.collection('users').get();
      var data = snapshot.docs;

      setState(() {
        data.forEach((doc) {
          var value = doc.data();
          if (value['role'] != 'Manager') {
            debugPrint(value.toString());
            duplicateItems.add(value['name'] + ' ' + value['lastName']);
            duplicateEmployeeInfo.add(Employee.fromMap(value, doc.id));
          }
        });
        items = duplicateItems;
        employeeInfo = duplicateEmployeeInfo;
        isLoading = false;
        debugPrint('Employee Info Loaded: ${employeeInfo.length}');
      });
    } catch (e) {
      debugPrint('Error fetching employee data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void filterSearchResults(String query) {
    setState(() {
      items = [];
      employeeInfo = [];
      for (int i = 0; i < duplicateItems.length; i++) {
        if (duplicateItems[i].toLowerCase().contains(query.toLowerCase())) {
          bool isScheduled = true;
          if (selectedDay != 'All') {
            int indexWeekDay = weekDays.indexOf(selectedDay) - 1;
            if (!duplicateEmployeeInfo[i].schedule.containsKey(indexWeekDay)) {
              isScheduled = false;
            }
          }
          if (isScheduled) {
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
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text('Filter by Day:'),
                  SizedBox(width: 10),
                  DropdownButton<String>(
                    value: selectedDay,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedDay = newValue!;
                        filterSearchResults('');
                      });
                    },
                    items: weekDays
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            Expanded(
              child: isLoading
                  ? const Center(
                child: CircularProgressIndicator(),
              )
                  : Padding(
                padding: const EdgeInsets.all(8),
                child: items.isNotEmpty
                    ? ListView.builder(
                  shrinkWrap: true,
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
                                  EmployeeProfilePage(
                                    employee: employeeInfo[index],
                                  ),
                            ),
                          );
                        },
                        title: Text(
                          '${items[index]}',
                          style: const TextStyle(fontSize: 20),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Works as: ${employeeInfo[index].role}',
                              style: const TextStyle(fontSize: 18),
                            ),
                            Text(
                              'Email: ${employeeInfo[index].email}',
                              style: const TextStyle(fontSize: 18),
                            ),
                            Text(
                              'Phone: ${employeeInfo[index].phoneNumber}',
                              style: const TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                        trailing: Icon(Icons.arrow_forward_ios_sharp),
                      ),
                    );
                  },
                )
                    : Center(
                  child: const Text('No Match'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
