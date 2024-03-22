import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '../date_time_selector.dart';
import '../employee/employee.dart';
import '../firebase/db.dart';
import '../meeting.dart';

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
  DateTime? _endTime; // year, month, day, hour,Minutes
  Color _color = Colors.blue;
  final _form = GlobalKey<FormState>();
  Map data = {};
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

  void getEmployeeData() {
    getUsersInfo().then((value) =>
        setState(
              () {
            data = value!;
            data.forEach((uid, value) {
              if (value['role'] != 'Manager') {
                debugPrint(value.toString());
                duplicateItems.add(value['name'] + ' ' + value['lastName']);
                duplicateEmployeeInfo.add(
                  Employee(
                      name: value['name'],
                      uid: uid,
                      role: value['role'],
                      email: value['email'],
                      lastName: value['lastName'],
                      availability: value['Availability'],
                      phoneNumber: value['phoneNumber'],
                      timeOff: value['Time Off'],
                      timesheet: value['timesheet'],
                      schedule: value['schedule']

                  ),
                );
              }
            });
            setState(() {
              items = duplicateItems;
              employeeInfo = duplicateEmployeeInfo;
              isLoading = false;
              print(employeeInfo);
            });
          },
        ));
  }

  void filterSearchResults(String query) {
    items = [];
    setState(() {
      for (int i = 0; i < duplicateItems.length; i++) {
        if (duplicateItems[i].toLowerCase().contains(query.toLowerCase())) {
          int indexWeekDay = weekDays.indexOf(selectedDay) - 1;
          // print(indexWeekDay);
          // print(duplicateEmployeeInfo[i].availability[indexWeekDay]);
          if (selectedDay == 'All' ||
              duplicateEmployeeInfo[i].availability[indexWeekDay]
              ['selectedDay']) {
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
      scheduleEmployees += '${employee.name}${employee.lastName}, ';
    }
    return scheduleEmployees;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery
        .of(context)
        .size
        .height;
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
                                  'Work as: ${employeeInfo[index].role}',
                                  style: const TextStyle(fontSize: 18)),
                              trailing: IconButton(
                                icon: scheduleEmployeeList
                                    .contains(employeeInfo[index])
                                    ? const Icon(Icons.remove,
                                    color: Colors
                                        .red) // Display a minus icon if the employee is in the list
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
                    "schedule Color: ",
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

  _addSchedule() {
    for (Employee employee in scheduleEmployeeList) {
      Map schedule = employee.schedule;
      Map event = {};
      String date = _date.toLocal().toString().split(' ')[0];
      event['startTime'] = _startTime;
      event['endTime'] = _endTime;
      schedule[date] = event;
      employee.schedule = schedule;
      addEvents({'schedule': schedule}, employee.uid);
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Schedule was saved.'),
      ),
    );
  }

  void _setDefaults() {
    // Initialize form fields with default values or values from an existing schedule
    // You can set _startDate, _startTime, _endTime, _color,
    // _titleController, and _descriptionController based on your requirements.

    // Example: Setting default values for start and end date/time
    _date = DateTime.now();
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

    // Example: Setting default color
    _color = Colors.green;
  }

  void _displayColorPicker() {
    // Display a color picker dialog and update _color

    showDialog(
      context: context,
      builder: (BuildContext context) {
        Color selectedColor = _color; // Initialize with current color

        return AlertDialog(
          title: const Text('Select schedule Color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: selectedColor,
              onColorChanged: (Color color) {
                setState(() {
                  selectedColor = color;
                });
              },
              showLabel: true, // Show color label
              pickerAreaHeightPercent: 0.8, // Adjust the picker area height
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
                  _color = selectedColor; // Update the selected color
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