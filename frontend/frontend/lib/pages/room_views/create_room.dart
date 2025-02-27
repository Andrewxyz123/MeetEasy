import 'package:flutter/material.dart';
import 'package:frontend/controllers/BookingController.dart';
import 'package:frontend/controllers/BranchController.dart';
import 'package:frontend/controllers/RoomController.dart';
import 'package:frontend/controllers/UserController.dart';
import 'package:frontend/models/booking.dart';
import 'package:frontend/models/room.dart';
import 'package:frontend/models/company_branch.dart'; // Assuming you have this model
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
  final BookingController _bookingController = Get.put(BookingController());
  final UserController _userController = Get.put(UserController());
  final Branchcontroller branchcontroller = Get.put(Branchcontroller());

  List<Booking> bookingList = [];
  List<Room> roomList = [];
  List<CompanyBranch> companyBranchList = [];
  CompanyBranch? _selectedBranch;

  // Fetch the company branches
  Future<void> _fetchCompanyBranches() async {
    final branches = await branchcontroller.fetchBranchForLoggedInUser(); // Assume this method fetches the branches
    setState(() {
      companyBranchList = branches;
      print(companyBranchList);
    });
  }

  void _saveRoom() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Gather room data
      String roomNumber = _roomNumberController.text.trim();
      String roomType = _roomTypeController.text.trim();
      String description = _descriptionController.text.trim();
      int? capacity = int.tryParse(_capacityController.text.trim());

      print('test');

      try {
        await _roomController.createRoom(
          roomNumber: roomNumber,
          roomType: roomType,
          description: description,
          capacity: capacity,
          branch: _selectedBranch
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

      await _roomController.fetchRoomsForLoggedInUser(); 
      final bookings = await _bookingController.fetchBookingsForLoggedInUser();
      final rooms = await _roomController.fetchRoomsForLoggedInUser2();

      setState(() {
        bookingList = bookings;
        roomList = rooms;
      });

      Navigator.pushReplacementNamed(context, '/dashboard', arguments: {'user': _userController.user,
        'booking-list': bookingList,
        if (_userController.user?.role?.name?.toLowerCase() == 'room_manager') 'room-list': roomList,
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchCompanyBranches(); // Fetch the company branches when the page is initialized
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create Room',
          style: TextStyle(color: Colors.white),
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
              // Room number
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
              const SizedBox(height: 15),

              // Room type
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
              const SizedBox(height: 15),

              // Description
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  labelStyle: theme.textTheme.bodyLarge,
                ),
                maxLines: 1,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),

              // Capacity
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
              const SizedBox(height: 15),

              // Dropdown for selecting a company branch
              DropdownButtonFormField<CompanyBranch>(
                value: _selectedBranch,
                decoration: InputDecoration(
                  labelText: 'Branch',
                  labelStyle: theme.textTheme.bodyLarge,
                ),
                items: companyBranchList.map((branch) {
                  return DropdownMenuItem<CompanyBranch>(
                    value: branch,
                    child: Text(branch.name ?? 'No branch name'),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedBranch = value;
                  });
                },
                validator: (value) => value == null ? 'Please select a branch' : null,
              ),
              const SizedBox(height: 15),

              // Create Room Button
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
