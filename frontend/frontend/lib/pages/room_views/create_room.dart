import 'package:flutter/material.dart';
import 'package:frontend/controllers/RoomController.dart';
import 'package:get/get.dart';

class CreateRoomPage extends StatefulWidget {
  @override
  _CreateRoomPageState createState() => _CreateRoomPageState();
}

class _CreateRoomPageState extends State<CreateRoomPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _roomNumberController = TextEditingController();
  final TextEditingController _roomTypeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _capacityController = TextEditingController();

  final RoomController _roomController = Get.put(RoomController());

  void _saveRoom() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Gather room data
      String roomNumber = _roomNumberController.text.trim();
      String roomType = _roomTypeController.text.trim();
      String description = _descriptionController.text.trim();
      int? capacity = int.tryParse(_capacityController.text.trim());

      try {
        await _roomController.createRoom(
          roomNumber: roomNumber,
          roomType: roomType,
          description: description,
          capacity: capacity,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Room successfully created!')),
        );

        // Clear the form after successful creation
        _formKey.currentState?.reset();
        _roomNumberController.clear();
        _roomTypeController.clear();
        _descriptionController.clear();
        _capacityController.clear();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error creating room: $e')),
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
          'Create Booking',
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
                  onPressed: _saveRoom,
                  style: theme.elevatedButtonTheme.style,
                  child: Text(
                    'Create Room',
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
