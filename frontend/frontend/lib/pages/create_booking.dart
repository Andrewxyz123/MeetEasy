import 'package:flutter/material.dart';

class CreateBookingScreen extends StatefulWidget {
  @override
  _CreateBookingScreenState createState() => _CreateBookingScreenState();
}

class _CreateBookingScreenState extends State<CreateBookingScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedRoom;
  DateTime? _selectedDate;
  TimeOfDay? _selectedStartTime;
  TimeOfDay? _selectedEndTime;
  String? _description;
  bool _isSlotAvailable = true;

  final List<String> rooms = ["Conference Room A", "Conference Room B", "Conference Room C"];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        if (isStartTime) {
          _selectedStartTime = picked;
        } else {
          _selectedEndTime = picked;
        }
      });
    }
  }

  void _saveBooking() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Mock validation for time slot availability
      setState(() {
        _isSlotAvailable = _selectedRoom != "Conference Room A" ||
            _selectedDate != DateTime(2023, 11, 15) ||
            _selectedStartTime != TimeOfDay(hour: 9, minute: 0);
      });

      if (_isSlotAvailable) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Booking successfully saved!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('This time slot is already reserved. Please select another time.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Access the theme

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Update Reservation',
          style: theme.textTheme.titleLarge, // Use the theme's title style
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<String>(
                value: _selectedRoom,
                decoration: InputDecoration(
                  labelText: 'Room',
                  labelStyle: theme.textTheme.bodyLarge, // Use theme's label style
                ),
                items: rooms.map((room) {
                  return DropdownMenuItem(
                    value: room,
                    child: Text(room, style: theme.textTheme.bodyMedium),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedRoom = value;
                  });
                },
                validator: (value) => value == null ? 'Please select a room' : null,
              ),
              SizedBox(height: 16),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: AbsorbPointer(
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Date',
                      hintText: _selectedDate == null
                          ? 'Select a date'
                          : '${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}',
                      labelStyle: theme.textTheme.bodyLarge,
                    ),
                    validator: (value) => _selectedDate == null ? 'Please select a date' : null,
                  ),
                ),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _selectTime(context, true),
                      child: AbsorbPointer(
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Start Time',
                            hintText: _selectedStartTime == null
                                ? 'Select start time'
                                : _selectedStartTime!.format(context),
                            labelStyle: theme.textTheme.bodyLarge,
                          ),
                          validator: (value) => _selectedStartTime == null ? 'Select start time' : null,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _selectTime(context, false),
                      child: AbsorbPointer(
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'End Time',
                            hintText: _selectedEndTime == null
                                ? 'Select end time'
                                : _selectedEndTime!.format(context),
                            labelStyle: theme.textTheme.bodyLarge,
                          ),
                          validator: (value) => _selectedEndTime == null ? 'Select end time' : null,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Description',
                  labelStyle: theme.textTheme.bodyLarge,
                ),
                maxLines: 3,
                onSaved: (value) => _description = value,
              ),
              SizedBox(height: 16),
              if (!_isSlotAvailable)
                Text(
                  'This time slot is already reserved. Please select another time.',
                  style: theme.textTheme.bodyMedium?.copyWith(color: Colors.red),
                ),
              Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveBooking,
                  style: theme.elevatedButtonTheme.style,
                  child: Text(
                    'Save Changes',
                    style: theme.textTheme.bodyLarge?.copyWith(color: Colors.white),
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
