import 'package:flutter/material.dart';
import 'package:frontend/controllers/BookingController.dart';
import 'package:frontend/controllers/RoomController.dart';
import 'package:frontend/controllers/UserController.dart';
import 'package:frontend/models/booking.dart';
import 'package:frontend/models/room.dart';
import 'package:get/get.dart';

class UpdateRoomPage extends StatefulWidget {
  final int? roomId;
  final String? roomNumber;
  final String? roomType;
  final String? description;
  final int? capacity;

  UpdateRoomPage({
    required this.roomId,
    this.roomNumber,
    this.roomType,
    this.description,
    this.capacity,
  });

  @override
  _UpdateRoomPageState createState() => _UpdateRoomPageState();
}

class _UpdateRoomPageState extends State<UpdateRoomPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _roomNumberController = TextEditingController();
  final TextEditingController _roomTypeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _capacityController = TextEditingController();

  final RoomController _roomController = Get.put(RoomController());
  final BookingController _bookingController = BookingController();
  final UserController _userController = Get.put(UserController());

    List<Booking> bookingList = [];
    List<Room> roomList = [];

  @override
  void initState() {
    super.initState();

    // Pre-fill the form fields with existing data
    if (widget.roomNumber != null) {
      _roomNumberController.text = widget.roomNumber!;
    }
    if (widget.roomType != null) {
      _roomTypeController.text = widget.roomType!;
    }
    if (widget.description != null) {
      _descriptionController.text = widget.description!;
    }
    if (widget.capacity != null) {
      _capacityController.text = widget.capacity.toString();
    }
  }

  void _updateRoom() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Gather updated room data
      String roomNumber = _roomNumberController.text.trim();
      String roomType = _roomTypeController.text.trim();
      String description = _descriptionController.text.trim();
      int? capacity = int.tryParse(_capacityController.text.trim());

      try {
        await _roomController.updateRoom(
          roomId: widget.roomId,
          roomNumber: roomNumber,
          roomType: roomType,
          description: description,
          capacity: capacity,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Room successfully updated!')),
        );

        Navigator.pop(context); // Navigate back after saving

        await _roomController.fetchRoomsForLoggedInUser();
        final bookings = await _bookingController.fetchBookingsForLoggedInUser();
        final rooms = await _roomController.fetchRoomsForLoggedInUser2();

        // Mock validation for time slot availability
        setState(() {
          bookingList = bookings;
          roomList = rooms;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Booking updated successfully!')),
        );

        Navigator.pop(context);

        Navigator.pushReplacementNamed(context, '/dashboard', arguments: {'user': _userController.user,
        'booking-list': bookingList,
        if (_userController.user?.role?.name?.toLowerCase() == 'room_manager') 'room-list': roomList,
      });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating room: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Update Room',
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
              TextFormField(
                controller: _roomNumberController,
                decoration: InputDecoration(
                  labelText: 'Room Number',
                  labelStyle: theme.textTheme.bodyLarge,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter the room number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 25),
              TextFormField(
                controller: _roomTypeController,
                decoration: InputDecoration(
                  labelText: 'Room Type',
                  hintText: 'e.g., Conference, Office',
                  labelStyle: theme.textTheme.bodyLarge,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter the room type';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 25),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  labelStyle: theme.textTheme.bodyLarge,
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 25),
              TextFormField(
                controller: _capacityController,
                decoration: InputDecoration(
                  labelText: 'Capacity',
                  hintText: 'e.g., 10',
                  labelStyle: theme.textTheme.bodyLarge,
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter the room capacity';
                  }
                  if (int.tryParse(value) == null || int.parse(value) <= 0) {
                    return 'Please enter a valid positive number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 25),
              Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _updateRoom,
                  style: theme.elevatedButtonTheme.style,
                  child: Text(
                    'Update Room',
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
