import 'package:flutter/material.dart';
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
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadRooms();
  }

  Future<void> loadRooms() async {
    setState(() {
      isLoading = true;
    });

    await _RoomController.getAllRooms(); // Fetch rooms using the controller

    setState(() {
      isLoading = false; // Stop loading once data is fetched
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      body: Obx(() {
        return _RoomController.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: _RoomController.userRooms.length,
                itemBuilder: (context, index) {
                  var room = _RoomController.userRooms[index];

                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Room Number
                          Text(
                            room?.room_number ?? "Unknown Room Number",
                            style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                          ),
                          // Room Type
                          Text(
                            'Type: ${room?.room_type ?? "Unknown"}',
                            style: GoogleFonts.poppins(),
                          ),
                          // Room Capacity
                          Text(
                            'Capacity: ${room?.capacity ?? "Unknown"}',
                            style: GoogleFonts.poppins(),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              // Edit Button
                              IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => UpdateRoomPage(
                                        roomId: room?.id,
                                        roomNumber: room?.room_number,
                                        roomType: room?.room_type,
                                        description: room?.description,
                                        capacity: room?.capacity,
                                      ),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.edit),
                              ),
                              // Delete Button
                              IconButton(
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
                                    // Delete room logic here
                                    await _RoomController.deleteRoom(room?.id);
                                  }
                                },
                                icon: const Icon(Icons.delete),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
      }),
    );
  }
}
