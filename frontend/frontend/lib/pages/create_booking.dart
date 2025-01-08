import 'package:flutter/material.dart';
import 'package:frontend/controllers/BookingController.dart';
import 'package:frontend/controllers/RoomController.dart';
import 'package:frontend/models/room.dart';
import 'package:get/get.dart';

class CreateBookingPage extends StatefulWidget {
  @override
  _CreateBookingPageState createState() => _CreateBookingPageState();
}

class _CreateBookingPageState extends State<CreateBookingPage> {
  final _formKey = GlobalKey<FormState>();
  Room? _selectedRoom;

  DateTime? _selectedDate;
  final TextEditingController _dateController = TextEditingController();
  
  TimeOfDay? _selectedStartTime;
  TimeOfDay? _selectedEndTime;
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();

  RoomController _RoomController = Get.put(RoomController());
  BookingController _BookingController = Get.put(BookingController());

  String? _description;
  final TextEditingController _descriptionController = TextEditingController();

  bool _isSlotAvailable = true;

  final List<String> rooms = ["Conference Room A", "Conference Room B", "Conference Room C"];

  bool isLoading = true;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        _dateController.text =
            '${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}';
      });
    }
  }

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

     if (pickedTime != null) {
      setState(() {
        if (isStartTime) {
          _selectedStartTime = pickedTime;
          _startTimeController.text = _selectedStartTime!.format(context);
        } else {
          _selectedEndTime = pickedTime;
          _endTimeController.text = _selectedEndTime!.format(context);
        }
      });
    }
  }

  DateTime _combineDateAndTime(DateTime date, TimeOfDay time) {
    // Combine DateTime with TimeOfDay
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  void _saveBooking() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      DateTime? startDateTime = _selectedDate != null && _selectedStartTime != null
        ? _combineDateAndTime(_selectedDate!, _selectedStartTime!)
        : null;

      DateTime? endDateTime = _selectedDate != null && _selectedEndTime != null
        ? _combineDateAndTime(_selectedDate!, _selectedEndTime!)
        : null;

      // print('Start DateTime: $startDateTime');
      // print('End DateTime: $endDateTime');
      
      bool isCreated = false;

      try {
        _BookingController.createBooking(room: _selectedRoom, start_time: startDateTime, end_time: endDateTime);
        bool isCreated = true;
      } catch (e) {
        print('error in creating Booking');
      }

      // Mock validation for time slot availability
      setState(() {
        // _isSlotAvailable = _selectedRoom != "Conference Room A" ||
        //     _selectedDate != DateTime(2023, 11, 15) ||
        //     _selectedStartTime != TimeOfDay(hour: 9, minute: 0);
      });

      if (isCreated == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Booking successfully saved!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error in Creating Booking.')),
        );
      }
    }
  }

     Future<void> createBookingLoad() async {
    // Start loading
    setState(() {
      isLoading = true;
    });

    // Perform the async operation
    await _RoomController.getAllRooms(); // Assuming this is an async function

    // Once async work is done, call setState to update the UI
    setState(() {
      if (_RoomController.userRooms.isEmpty) {
        print('No rooms available');
      } else {
        print('Rooms fetched successfully');
      }
      isLoading = false; // Stop loading once data is fetched
    });
  }

  @override
  void initState() {
    super.initState();
    loadRooms();  // Call the async function
  }

   Future<void> loadRooms() async {
    // Start loading
    setState(() {
      isLoading = true;
    });

    // Perform the async operation
    await _RoomController.getAllRooms(); // Assuming this is an async function

    // Once async work is done, call setState to update the UI
    setState(() {
      if (_RoomController.userRooms.isEmpty) {
        print('No rooms available');
      } else {
        print('Rooms fetched successfully');
      }
      isLoading = false; // Stop loading once data is fetched
    });
  }



  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Access the theme

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create Booking',
          style: theme.textTheme.titleLarge, // Use the theme's title style
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<Room?>(
                value: _selectedRoom,
                decoration: InputDecoration(
                  labelText: 'Room',
                  labelStyle: theme.textTheme.bodyLarge, // Use theme's label style
                ),
                items: _RoomController.userRooms.map((room) {
                  return DropdownMenuItem<Room?>(
                    value: room, // The value of the dropdown item (room itself)
                    child: Text(room?.room_number ?? 'No room number'), // Provide a default value if null
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedRoom = value;
                  });
                },
                validator: (value) => value == null ? 'Please select a room' : null,
              ),
              SizedBox(height: 25),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: _dateController,
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
              SizedBox(height: 25),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _selectTime(context, true),
                      child: AbsorbPointer(
                        child: TextFormField(
                          controller: _startTimeController,
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
                  SizedBox(width: 25),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _selectTime(context, false),
                      child: AbsorbPointer(
                        child: TextFormField(
                          controller: _endTimeController,
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
              SizedBox(height: 25),
              // TextFormField(
              //   controller: _descriptionController,
              //   decoration: InputDecoration(
              //     labelText: 'Description',
              //     labelStyle: theme.textTheme.bodyLarge,
              //     floatingLabelBehavior: FloatingLabelBehavior.always,
              //   ),
              //   maxLines: 3,
              //   onSaved: (value) => _description = value,
              // ),
              // SizedBox(height: 25),
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
                    'Create Booking',
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
