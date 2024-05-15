import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../date_time_selector.dart';
import '../firebase/db.dart';
import 'employee.dart';

class AddOrEditScheduleForm extends StatefulWidget {
  AddOrEditScheduleForm({
    Key? key,
    required this.employee,
  }) : super(key: key);
  final Employee employee;

  @override
  _AddOrEditScheduleFormState createState() => _AddOrEditScheduleFormState();
}

class _AddOrEditScheduleFormState extends State<AddOrEditScheduleForm> {
  late DateTime _startDate;
  late DateTime _endDate;
  DateTime? _startTime;
  DateTime? _endTime; // year, month, day, hour,Minutes
  final _form = GlobalKey<FormState>();
  late final _titleController = TextEditingController();
  late final _titleNode = FocusNode();
  List<bool> selectedDays = List.generate(7, (index) => false);

  String selectedType = 'Availability';

  @override
  void initState() {
    super.initState();
    _setDefaults();
  }

  @override
  void dispose() {
    _titleNode.dispose();
    _titleController.dispose();
    super.dispose();
  }

  String _getDayName(int index) {
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[index];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Availability - Time Off'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: ListView(
            children: [
              const SizedBox(height: 20),
              const Text('Type:'),
              Align(
                alignment: Alignment.center,
                child: DropdownButton<String>(
                  value: selectedType,
                  onChanged: (value) {
                    setState(() {
                      selectedType = value!;
                    });
                  },
                  items: ['Availability', 'Time Off'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 20),
              selectedType == 'Availability'
                  ? Column(
                children: [
                  const Text('Select Availability Days:'),
                  Wrap(
                      children: List.generate(7, (index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ChoiceChip(
                            showCheckmark: false,
                            label: Text(_getDayName(index),
                                style: const TextStyle(color: Colors.white)),
                            selected: selectedDays[index],
                            selectedColor:
                            const Color.fromRGBO(9, 93, 126, 1.0),
                            backgroundColor:
                            const Color.fromRGBO(72, 88, 94, 1.0),
                            onSelected: (selected) {
                              setState(() {
                                selectedDays[index] = selected;
                              });
                            },
                          ),
                        );
                      })),
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
                      if (_startTime != null &&
                          date!.isBefore(_startTime!)) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(
                          content:
                          Text('End time is less than start time.'),
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
                ],
              )
                  : Column(
                children: [
                  DateTimeSelectorFormField(
                    labelText: "Start Date",
                    initialDateTime: _startDate,
                    onSelect: (date) {
                      // Handle start date selection
                      _startDate = date!;

                      if (mounted) {
                        setState(() {});
                      }
                    },
                    type: DateTimeSelectionType.date,
                  ),
                  DateTimeSelectorFormField(
                    labelText: "End Date",
                    initialDateTime: _endDate,
                    onSelect: (date) {
                      // Handle start date selection
                      _endDate = date!;
                      if (mounted) {
                        setState(() {});
                      }
                    },
                    type: DateTimeSelectionType.date,
                  ),
                ],
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: selectedType == 'Availability'
                    ? _addAvailabilityForSelectedWeekdays
                    : _addTimeOff,
                child: const Text('Save '),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _addAvailabilityForSelectedWeekdays() {
    final List<Map> dates = [];

    for (int i = 0; i < selectedDays.length; i++) {
      Map event = {'selectedDay': selectedDays[i]};
      if (selectedDays[i]) {
        event['startTime'] = _startTime;
        event['endTime'] = _endTime;
      }
      dates.add(event);
    }
    widget.employee.availability = dates;
    addEvents({selectedType: dates}, widget.employee.uid);
  }

  _addTimeOff() {
    Map event = {};
    event['startDate'] = _startDate;
    event['endDate'] = _endDate;
    addEvents({selectedType: event}, widget.employee.uid);
  }

  void _setDefaults() {
    // Initialize form fields with default values or values from an existing schedule
    // You can set _startDate, _startTime, _endTime, _color,
    // _titleController, and _descriptionController based on your requirements.

    // Example: Setting default values for start and end date/time
    _startDate = DateTime.now();
    _endDate = DateTime.now().add(Duration(days: 2));
    _startTime = DateTime(
      _startDate.year,
      _startDate.month,
      _startDate.day,
      9,
      0,
    ); // year, month, day, hour,Minutes
    _endTime = DateTime(
      _startDate.year,
      _startDate.month,
      _startDate.day,
      18,
      0,
    );
  }
}