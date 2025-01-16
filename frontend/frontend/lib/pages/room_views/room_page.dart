import 'package:flutter/material.dart';
import 'package:frontend/controllers/BookingController.dart';
import 'package:frontend/controllers/UserController.dart';
import 'package:frontend/models/booking.dart';
import 'package:frontend/models/room.dart';
import 'package:frontend/pages/room_views/room_detail.dart';
import 'package:frontend/pages/room_views/update_room.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:frontend/controllers/RoomController.dart';

class RoomPage extends StatefulWidget {
  const RoomPage({Key? key}) : super(key: key);

  @override
  State<RoomPage> createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  final RoomController _RoomController = Get.put(RoomController());
    final BookingController _BookingController = Get.put(BookingController());
  final UserController userController = Get.put(UserController());

  bool isLoading = true;

    List<Room> roomList = [];
  
  late List<Booking> bookingList = [];

  @override
  void initState() {
    super.initState();
    loadRooms();
  }

  Future<void> loadRooms() async {
    setState(() {
      isLoading = true;
    });

    await _RoomController.getAllRooms();

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Rooms',
          style: TextStyle(color: Colors.white), // Set title text color to white
        ),
        backgroundColor: const Color(0xFF4C51BF),
      ),
      backgroundColor: Colors.blueGrey[50], // Match BookingPage background color
      body: Obx(() {
        return _RoomController.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/create-room');
                    },
                    child: Container(
                      margin: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF4C51BF), Color(0xFF434190)],
                        ),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF718096).withOpacity(0.1),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(16.0),
                      child: const Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Create Meeting Room',
                                  style: TextStyle(fontSize: 14, color: Colors.white),
                                ),
                                const SizedBox(height: 4),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: 24,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF718096).withOpacity(0.1),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        itemCount: _RoomController.userRooms.length,
                        itemBuilder: (context, index) {
                          var room = _RoomController.userRooms[index];

                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: ListTile(
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    room?.roomNumber ?? "Unknown Room",
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Type: ${room?.roomType ?? "Unknown"}',
                                    style: GoogleFonts.poppins(fontSize: 14),
                                  ),
                                  Text(
                                    'Capacity: ${room?.capacity ?? "Unknown"}',
                                    style: GoogleFonts.poppins(fontSize: 14),
                                  ),
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.info, color: Colors.green, size: 20),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => RoomDetailPage(
                                            roomId: room?.id,
                                            roomNumber: room?.roomNumber,
                                            roomType: room?.roomType,
                                            description: room?.description,
                                            capacity: room?.capacity,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.edit, color: Colors.blue, size: 20),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => UpdateRoomPage(
                                            roomId: room?.id,
                                            roomNumber: room?.roomNumber,
                                            roomType: room?.roomType,
                                            description: room?.description,
                                            capacity: room?.capacity,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red ,size: 20),
                                    onPressed: () async {
                                      bool confirmed = await showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: const Text('Confirm Delete'),
                                          content: const Text('Are you sure you want to delete this room?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.pop(context, false),
                                              child: const Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () => Navigator.pop(context, true),
                                              child: const Text('Delete'),
                                            ),
                                          ],
                                        ),
                                      );

                                      if (confirmed) {
                                        await _RoomController.deleteRoom(room?.id);
                                          await _RoomController.fetchRoomsForLoggedInUser(); // Assuming this is an async function
                                          final bookings = await _BookingController.fetchBookingsForLoggedInUser();
                                          final rooms = await _RoomController.fetchRoomsForLoggedInUser2();
                                          // Perform deletion action here

                                          setState(() {
                                            bookingList = bookings;
                                            roomList = rooms;
                                          });
                                          Navigator.pushReplacementNamed(context, '/dashboard', arguments: {'user': userController.user,
                                            'booking-list': bookingList,
                                            if (userController.user?.role?.name?.toLowerCase() == 'room_manager') 'room-list': roomList,
                                          });
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              );
      }),
    );
  }
}
