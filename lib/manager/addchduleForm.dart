import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../date_time_selector.dart';
import '../employee/employee.dart';
import '../firebase/db.dart';

class AddScheduleForm extends StatefulWidget {
  AddScheduleForm({
    Key? key,
  }) : super(key: key);

  @override
  _AddScheduleFormState createState() => _AddScheduleFormState();
}

class _AddScheduleFormState extends State<AddScheduleForm> {
  late DateTime _date;
  DateTime? _startTime;
  DateTime? _endTime;
  Color _color = Colors.blue;
  final _form = GlobalKey<FormState>();
  List<Employee> scheduleEmployeeList = [];

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
    'Sunday',
  ];

  @override
  void initState() {
    super.initState();
    getEmployeeData();
    _setDefaults();
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
          int indexWeekDay = weekDays.indexOf(selectedDay) - 1;
          if (selectedDay == 'All' ||
              duplicateEmployeeInfo[i]
                  .availability[indexWeekDay]['selectedDay']) {
            items.add(duplicateItems[i]);
            employeeInfo.add(duplicateEmployeeInfo[i]);
          }
        }
      }
    });
  }

  String getScheduleEmployees() {
    String scheduleEmployees = '';
    for (Employee employee in scheduleEmployeeList) {
      scheduleEmployees += '${employee.name} ${employee.lastName}, ';
    }
    return scheduleEmployees;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set Schedule'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: TextField(
                  onChanged: (value) {
                    filterSearchResults(value);
                  },
                  controller: editingController,
                  decoration: const InputDecoration(
                    labelText: "Search",
                    hintText: "Search",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(25),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    const Text('Filter by Day:'),
                    const SizedBox(width: 10),
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
              SizedBox(
                height: height * 0.3,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: items.isNotEmpty
                        ? ListView.builder(
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        return Card(
                            child: ListTile(
                              title: Text('${items[index]}',
                                  style: const TextStyle(fontSize: 20)),
                              subtitle: Text(
                                  'Works as: ${employeeInfo[index].role}',
                                  style: const TextStyle(fontSize: 18)),
                              trailing: IconButton(
                                icon: scheduleEmployeeList
                                    .contains(employeeInfo[index])
                                    ? const Icon(Icons.remove,
                                    color: Colors.red) // Display a minus icon if the employee is in the list
                                    : const Icon(Icons.add, color: Colors.green),
                                // Display a plus icon if the employee is not in the list
                                onPressed: () {
                                  setState(() {
                                    if (scheduleEmployeeList
                                        .contains(employeeInfo[index])) {
                                      scheduleEmployeeList
                                          .remove(employeeInfo[index]);
                                    } else {
                                      scheduleEmployeeList
                                          .add(employeeInfo[index]);
                                    }
                                  });
                                },
                              ),
                            ));
                      },
                    )
                        : const Center(child: Text('No Match')),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              const Text('Schedule Employees',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              InputDecorator(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  child: Text(getScheduleEmployees())),
              const SizedBox(height: 15),
              DateTimeSelectorFormField(
                labelText: "Date",
                initialDateTime: _date,
                onSelect: (date) {
                  // Handle start date selection
                  _date = date!;
                  _startTime = DateTime(
                    _date.year,
                    _date.month,
                    _date.day,
                    9,
                    0,
                  ); // year, month, day, hour,Minutes
                  _endTime = DateTime(
                    _date.year,
                    _date.month,
                    _date.day,
                    18,
                    0,
                  );

                  if (mounted) {
                    setState(() {});
                  }
                },
                type: DateTimeSelectionType.date,
              ),
              const SizedBox(height: 15),
              DateTimeSelectorFormField(
                labelText: "Start Time",
                initialDateTime: _startTime!,
                onSelect: (date) {
                  // Handle start time selection
                  if (_endTime != null && date!.isAfter(_endTime!)) {
                    _endTime = date.add(const Duration(minutes: 1));
                  }
                  _startTime = date;

                  if (mounted) {
                    setState(() {});
                  }
                },
                type: DateTimeSelectionType.time,
              ),
              DateTimeSelectorFormField(
                labelText: "End Time",
                initialDateTime: _endTime!,
                onSelect: (date) {
                  // Handle end time selection
                  if (_startTime != null && date!.isBefore(_startTime!)) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('End time is less than start time.'),
                    ));
                  } else {
                    _endTime = date;
                  }
                  if (mounted) {
                    setState(() {});
                  }
                },
                type: DateTimeSelectionType.time,
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  const Text(
                    "Schedule Color: ",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                    ),
                  ),
                  GestureDetector(
                    onTap: _displayColorPicker,
                    child: CircleAvatar(
                      radius: 15,
                      backgroundColor: _color,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: _addSchedule,
                child: const Text('Save Schedule'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _addSchedule() async {
    for (Employee employee in scheduleEmployeeList) {
      Map<String, dynamic> schedule = employee.schedule;
      Map<String, dynamic> event = {};
      String date = _date.toLocal().toString().split(' ')[0];
      event['startTime'] = Timestamp.fromDate(_startTime!);
      event['endTime'] = Timestamp.fromDate(_endTime!);
      event['color'] = _color.value; // Save the color as an integer value
      schedule[date] = event;

      employee.schedule = schedule;

      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(employee.uid)
            .update({'schedule': schedule});
      } catch (e) {
        debugPrint('Error saving schedule: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving schedule: $e'),
          ),
        );
        return;
      }
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Schedule was saved.'),
      ),
    );
    Navigator.of(context).pop();
  }

  void _setDefaults() {
    _date = DateTime.now();
    _startTime = DateTime(
      _date.year,
      _date.month,
      _date.day,
      9,
      0,
    );
    _endTime = DateTime(
      _date.year,
      _date.month,
      _date.day,
      18,
      0,
    );
    _color = Colors.green;
  }

  void _displayColorPicker() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Color selectedColor = _color;

        return AlertDialog(
          title: const Text('Select Schedule Color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: selectedColor,
              onColorChanged: (Color color) {
                setState(() {
                  selectedColor = color;
                });
              },
              showLabel: true,
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Select'),
              onPressed: () {
                setState(() {
                  _color = selectedColor;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
