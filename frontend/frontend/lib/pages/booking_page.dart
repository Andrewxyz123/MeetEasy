import 'package:flutter/material.dart';
import 'package:frontend/controllers/UserController.dart';
import 'package:frontend/models/booking.dart';
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
        style: theme.textTheme.titleLarge, // Use the theme's title style
      ),
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
                                  ],
                                ),
                                // Add more properties as needed
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
          ),
  );
}
}