import 'package:flutter/material.dart';
import 'package:frontend/controllers/BookingController.dart';
import 'package:frontend/controllers/LoginController.dart';
import 'package:frontend/controllers/RoomController.dart';
import 'package:frontend/models/room.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class UpdateBookingPage extends StatefulWidget {
  final int? bookingId;
  final Room? selectedRoom;
  final DateTime? start_time;
  final DateTime? end_time;

  const UpdateBookingPage({
    Key? key,
    required this.bookingId,
    this.selectedRoom,
    this.start_time,
    this.end_time,
  }) : super(key: key);

  @override
  _UpdateBookingPageState createState() => _UpdateBookingPageState();
}

class _UpdateBookingPageState extends State<UpdateBookingPage> {
  final BookingController _bookingController = BookingController();
  final RoomController _roomController = LoginController().roomController;

  List<Room?> rooms = [];
  Room? selectedRoom;
  DateTime? selectedDate;
  TimeOfDay? startTime;
  TimeOfDay? endTime;

  @override
  void initState() {
    super.initState();
    loadRooms();
    selectedRoom = widget.selectedRoom;
    selectedDate = widget.start_time ?? DateTime.now();
    startTime = widget.start_time != null
        ? TimeOfDay.fromDateTime(widget.start_time!)
        : TimeOfDay.now();
    endTime = widget.end_time != null
        ? TimeOfDay.fromDateTime(widget.end_time!)
        : TimeOfDay.now();
  }

  Future<void> loadRooms() async {
  try {
    setState(() {
      rooms = _roomController.userRooms.where((room) => room != null).toSet().toList();
    });
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to load rooms: $e')),
    );
  }
}


  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStartTime ? startTime! : endTime!,
    );
    if (picked != null) {
      setState(() {
        if (isStartTime) {
          startTime = picked;
        } else {
          endTime = picked;
        }
      });
    }
  }

  DateTime _combineDateAndTime(DateTime date, TimeOfDay time) {
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  void _updateBooking() async {
    if (selectedDate != null && startTime != null && endTime != null && selectedRoom != null) {
      DateTime startDateTime = _combineDateAndTime(selectedDate!, startTime!);
      DateTime endDateTime = _combineDateAndTime(selectedDate!, endTime!);

      if (endDateTime.isBefore(startDateTime)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('End time must be after start time')),
        );
        return;
      }

      try {
        await _bookingController.updateBooking(
          bookingId: widget.bookingId,
          startDateTime: startDateTime,
          endDateTime:endDateTime,
          selectedRoom: selectedRoom!,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Booking updated successfully!')),
        );

        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update booking: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all fields')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Booking', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF4C51BF),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: rooms.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonFormField<Room>(
                    value: rooms.contains(selectedRoom) ? selectedRoom : null,
                    decoration: const InputDecoration(labelText: 'Room'),
                    items: rooms.map((room) {
                      return DropdownMenuItem<Room>(
                        value: room,
                        child: Text(room?.roomNumber ?? 'No Room Number'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedRoom = value;
                      });
                    },
                    validator: (value) => value == null ? 'Please select a room' : null,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Date:', style: GoogleFonts.poppins(fontSize: 16)),
                      TextButton(
                        onPressed: () => _selectDate(context),
                        child: Text(
                          selectedDate != null
                              ? DateFormat('yyyy-MM-dd').format(selectedDate!)
                              : 'Select Date',
                          style: GoogleFonts.poppins(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Start Time:', style: GoogleFonts.poppins(fontSize: 16)),
                      TextButton(
                        onPressed: () => _selectTime(context, true),
                        child: Text(
                          startTime != null
                              ? startTime!.format(context)
                              : 'Select Start Time',
                          style: GoogleFonts.poppins(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('End Time:', style: GoogleFonts.poppins(fontSize: 16)),
                      TextButton(
                        onPressed: () => _selectTime(context, false),
                        child: Text(
                          endTime != null ? endTime!.format(context) : 'Select End Time',
                          style: GoogleFonts.poppins(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _updateBooking,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4C51BF),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(
                        'Update Booking',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
