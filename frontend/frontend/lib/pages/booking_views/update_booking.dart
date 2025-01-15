import 'package:flutter/material.dart';
import 'package:frontend/controllers/BookingController.dart';
import 'package:frontend/controllers/RoomController.dart';
import 'package:frontend/models/room.dart';
import 'package:get/get.dart';

class UpdateBookingPage extends StatefulWidget {
  final int? bookingId;
  final Room? selectedRoom;
  final DateTime? start_time; // Changed to DateTime?
  final DateTime? end_time; // Changed to DateTime?

  UpdateBookingPage({
    required this.bookingId,
    this.selectedRoom,
    this.start_time,
    this.end_time,
  });

  @override
  _UpdateBookingPageState createState() => _UpdateBookingPageState();
}

class _UpdateBookingPageState extends State<UpdateBookingPage> {
  final _formKey = GlobalKey<FormState>();
  Room? _selectedRoom;
  DateTime? _selectedStartDateTime;
  DateTime? _selectedEndDateTime;

  final TextEditingController _startDateTimeController = TextEditingController();
  final TextEditingController _endDateTimeController = TextEditingController();

  final RoomController _RoomController = Get.put(RoomController());
  final BookingController _BookingController = Get.put(BookingController());

  @override
  void initState() {
    super.initState();
    _selectedRoom = widget.selectedRoom;
    _selectedStartDateTime = widget.start_time;
    _selectedEndDateTime = widget.end_time;

    // Pre-fill the controllers
    if (_selectedStartDateTime != null) {
      _startDateTimeController.text = _formatDateTime(_selectedStartDateTime!);
    }
    if (_selectedEndDateTime != null) {
      _endDateTimeController.text = _formatDateTime(_selectedEndDateTime!);
    }

    _loadRooms();
  }

  Future<void> _loadRooms() async {
    await _RoomController.getAllRooms();
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} '
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _selectDateTime(BuildContext context, bool isStart) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: isStart
          ? _selectedStartDateTime ?? DateTime.now()
          : _selectedEndDateTime ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(
          isStart
              ? _selectedStartDateTime ?? DateTime.now()
              : _selectedEndDateTime ?? DateTime.now(),
        ),
      );

      if (pickedTime != null) {
        setState(() {
          final selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );

          if (isStart) {
            _selectedStartDateTime = selectedDateTime;
            _startDateTimeController.text = _formatDateTime(selectedDateTime);
          } else {
            _selectedEndDateTime = selectedDateTime;
            _endDateTimeController.text = _formatDateTime(selectedDateTime);
          }
        });
      }
    }
  }

  void _updateBooking() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (_selectedStartDateTime != null && _selectedEndDateTime != null) {
        _BookingController.updateBooking(
          bookingId: widget.bookingId,
          selectedRoom: _selectedRoom,
          startDateTime: _selectedStartDateTime,
          endDateTime: _selectedEndDateTime,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Booking successfully updated!')),
        );

        Navigator.pop(context); // Navigate back after saving
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update booking.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Update Booking',
          style: TextStyle(color: Colors.white), // Set title text color to white
        ),
        backgroundColor: const Color(0xFF4C51BF),
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
                decoration: InputDecoration(labelText: 'Room'),
                items: _RoomController.userRooms.map((room) {
                  return DropdownMenuItem<Room?>(
                    value: room,
                    child: Text(room?.roomNumber ?? 'No room number'),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => _selectedRoom = value);
                },
                validator: (value) => value == null ? 'Please select a room' : null,
              ),
              SizedBox(height: 25),
              GestureDetector(
                onTap: () => _selectDateTime(context, true),
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: _startDateTimeController,
                    decoration: InputDecoration(labelText: 'Start Date & Time'),
                    validator: (value) =>
                        _selectedStartDateTime == null ? 'Please select start date & time' : null,
                  ),
                ),
              ),
              SizedBox(height: 25),
              GestureDetector(
                onTap: () => _selectDateTime(context, false),
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: _endDateTimeController,
                    decoration: InputDecoration(labelText: 'End Date & Time'),
                    validator: (value) =>
                        _selectedEndDateTime == null ? 'Please select end date & time' : null,
                  ),
                ),
              ),
              Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _updateBooking,
                  child: Text('Update Booking'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
