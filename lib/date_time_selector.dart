import 'package:flutter/material.dart';

enum DateTimeSelectionType {
  date,
  time,
}

class DateTimeSelectorFormField extends StatefulWidget {
  final String labelText;
  final DateTime initialDateTime;
  final ValueChanged<DateTime?> onSelect;
  final FormFieldValidator<String>? validator;
  final DateTimeSelectionType type;

  DateTimeSelectorFormField({
    required this.labelText,
    required this.initialDateTime,
    required this.onSelect,
    this.validator,
    this.type = DateTimeSelectionType.date,
  });

  @override
  _DateTimeSelectorFormFieldState createState() =>
      _DateTimeSelectorFormFieldState();
}

class _DateTimeSelectorFormFieldState extends State<DateTimeSelectorFormField> {
  DateTime? _selectedDateTime;

  @override
  void initState() {
    super.initState();
    _selectedDateTime = widget.initialDateTime;
  }

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      validator: widget.validator,
      builder: (state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.labelText,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            InkWell(
              onTap: () async {
                await _selectDateTime();
                state.didChange(_selectedDateTime.toString());
              },
              child: InputDecorator(
                decoration: InputDecoration(
                  errorText: state.errorText,
                  border: OutlineInputBorder(),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedDateTime != null
                          ? widget.type == DateTimeSelectionType.date
                          ? _selectedDateTime!
                          .toLocal()
                          .toString()
                          .split(' ')[0]
                          : _selectedDateTime!
                          .toLocal()
                          .toString()
                          .split(' ')[1].substring(0,5)
                          : 'Select',
                    ),
                    widget.type == DateTimeSelectionType.date ? Icon(
                        Icons.calendar_today): Icon(
                        Icons.access_time_outlined),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _selectDateTime() async {
    DateTime? newDateTime;

    if (widget.type == DateTimeSelectionType.date) {
      newDateTime = await showDatePicker(
        context: context,
        initialDate: _selectedDateTime ?? DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),
      );
    } else {
      final selectedTime = await showTimePicker(
        context: context,
        initialTime:
        TimeOfDay.fromDateTime(_selectedDateTime ?? DateTime.now()),
      );
      if (selectedTime != null) {
        final currentDate = _selectedDateTime ?? DateTime.now();
        newDateTime = DateTime(
          currentDate.year,
          currentDate.month,
          currentDate.day,
          selectedTime.hour,
          selectedTime.minute,
        );
      }
    }

    if (newDateTime != null) {
      setState(() {
        _selectedDateTime = newDateTime;
      });
      widget.onSelect(_selectedDateTime);
    }
  }
}