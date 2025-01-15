import 'package:flutter/material.dart';
import 'package:frontend/controllers/RoomController.dart';
import 'package:frontend/controllers/UserController.dart';
import 'package:frontend/models/booking.dart';
import 'package:frontend/controllers/BookingController.dart';
import 'package:frontend/models/room.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ManageBookingStatusPage extends StatefulWidget {
  const ManageBookingStatusPage({super.key});

  @override
  State<ManageBookingStatusPage> createState() => _ManageBookingStatusPageState();
}

class _ManageBookingStatusPageState extends State<ManageBookingStatusPage> {
  final BookingController _bookingController = Get.put(BookingController());
  final UserController userController = Get.put(UserController());
  
  RoomController _RoomController = Get.put(RoomController());
  List<Booking> bookingList = [];
  List<Room> roomList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadBookings();
  }

  Future<void> loadBookings() async {
    setState(() => isLoading = true);

    try {
      bookingList = await _bookingController.fetchBookingsForLoggedInUser();
    } catch (e) {
      print('Error fetching bookings: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> updateBookingStatus(int? bookingId, String? newStatus) async {

    await _RoomController.fetchRoomsForLoggedInUser(); // Assuming this is an async function
    final bookings = await _bookingController.fetchBookingsForLoggedInUser();
    final rooms = await _RoomController.fetchRoomsForLoggedInUser2();

    try {
      await _bookingController.updateBookingStatus(bookingId: bookingId, status: newStatus);

      setState(() {
        bookingList = bookings;
        roomList = rooms;
      });
      Navigator.pushReplacementNamed(context, '/dashboard', arguments: {'user': userController.user,
        'booking-list': bookingList,
        if (userController.user?.role?.name?.toLowerCase() == 'room_manager') 'room-list': roomList,
      });
      loadBookings(); // Refresh the booking list after updating
    } catch (e) {
      print('Error updating booking status: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Bookings',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF4C51BF),
      ),
      backgroundColor: Colors.blueGrey[50],
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
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
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: bookingList.length,
                      itemBuilder: (context, index) {
                        var booking = bookingList[index];

                        // Format the date and time
                        String formattedDate = booking.startTime != null
                            ? DateFormat('yyyy-MM-dd').format(booking.startTime!)
                            : 'Invalid date';
                        String formattedStartTime = booking.startTime != null
                            ? DateFormat('HH:mm').format(booking.startTime!)
                            : 'XX';
                        String formattedEndTime = booking.endTime != null
                            ? DateFormat('HH:mm').format(booking.endTime!)
                            : 'XX';

                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            title: Text(
                              'Room ${booking.room?.roomNumber ?? "Unknown Room"}',
                              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Date: $formattedDate',
                                  style: GoogleFonts.poppins(),
                                ),
                                Text(
                                  'Time: $formattedStartTime - $formattedEndTime',
                                  style: GoogleFonts.poppins(),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  booking.room?.companyBranch?.name ?? "Sentosa Company",
                                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    // Accept Button
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                      ),
                                      onPressed: () => updateBookingStatus(booking.id, 'approved'),
                                      child: const Text('Accept'),
                                    ),
                                    const SizedBox(width: 8),
                                    // Reject Button
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                      ),
                                      onPressed: () => updateBookingStatus(booking.id, 'rejected'),
                                      child: const Text('Reject'),
                                    ),
                                  ],
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
            ),
    );
  }
}
