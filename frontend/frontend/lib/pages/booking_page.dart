import 'package:flutter/material.dart';
import 'package:frontend/controllers/UserController.dart';
import 'package:frontend/models/booking.dart';
import 'package:frontend/pages/booking_views/booking_detail.dart';
import 'package:frontend/pages/booking_views/update_booking.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:frontend/controllers/BookingController.dart';
import 'package:intl/intl.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  int user_id = 0;
  bool isLoading = true;
  final BookingController _BookingController = Get.put(BookingController());
  final UserController userController = Get.put(UserController());
  
  late List<Booking> bookingList = [];

  @override
  void initState() {
    super.initState();
    loadBookings();  // Call the async function
  }

Future<void> loadBookings() async {
  setState(() {
    isLoading = true;
  });

  try {
    bookingList = await _BookingController.fetchBookingsForLoggedInUser(); // Await the Future
  } catch (e) {
    print('Error fetching bookings: $e');
  } finally {
    setState(() {
      isLoading = false; // Update loading status
      if (bookingList.isEmpty) {
        print('No Bookings available.');
      }
    });
  }
}

@override
Widget build(BuildContext context) {
  final theme = Theme.of(context);
  return Scaffold(
    appBar: AppBar(
      title: Text(
        'Bookings',
        style: TextStyle(color: Colors.white), // Set title text color to white
      ),
      backgroundColor: const Color(0xFF4C51BF),
    ),
    backgroundColor: Colors.blueGrey[50], // Background color for the entire page
    body: isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Column(
            children: [
              // Upcoming Meetings Panel
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
                        offset: const Offset(0, 3), // Shadow offset
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: bookingList.length,
                          itemBuilder: (context, index) {
                            var booking = bookingList[index];

                            // Format the date and time here
                            String formattedDate = '';
                            String formattedStartTime = '';
                            String formattedEndTime = '';
                            if (booking.startTime != null) {
                              formattedDate = DateFormat('yyyy-MM-dd').format(booking.startTime!);
                              formattedStartTime = DateFormat('HH:mm').format(booking.startTime!);
                              formattedEndTime = DateFormat('HH:mm').format(booking.endTime!);
                            } else {
                              formattedDate = 'Invalid date';
                              formattedStartTime = 'XX';
                              formattedEndTime = 'XX';
                            }

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
                                      'Date: $formattedDate', // Show the formatted date
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
                                    const SizedBox(height: 10), // Space between text and icons
                                    // Icon buttons stacked vertically
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Status Container
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: booking.status == 'approved'
                                                ? Colors.green[100]
                                                : Colors.orange[100],
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            booking.status?.toUpperCase() ?? '',
                                            style: TextStyle(
                                              color: booking.status == 'approved'
                                                  ? Colors.green[700]
                                                  : Colors.orange[700],
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 8), // Space between the status and icons
                                        Row(
                                          children: [
                                            IconButton(
                                              icon: const Icon(Icons.info, color: Colors.green, size: 20),
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => BookingDetailPage(
                                                      bookingId: booking.id,
                                                      selectedRoom: booking.room,
                                                      startTime: booking.startTime,
                                                      endTime: booking.endTime,
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
                                                    builder: (context) => UpdateBookingPage(
                                                      bookingId: booking.id,
                                                      selectedRoom: booking.room,
                                                      start_time: booking.startTime,
                                                      end_time: booking.endTime,
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                                              onPressed: () async {
                                                bool confirmed = await showDialog(
                                                  context: context,
                                                  builder: (context) => AlertDialog(
                                                    title: const Text('Confirm Delete'),
                                                    content: const Text('Are you sure you want to delete this booking?'),
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
                                                  // Perform deletion action here
                                                  // _BookingController.deleteBooking(booking.id);
                                                }
                                              },
                                            ),
                                          ],
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
                    ],
                  ),
                ),
              ),
            ],
              )
      );
  // );
}
}
