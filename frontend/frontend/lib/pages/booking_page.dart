import 'package:frontend/models/Booking.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:frontend/controllers/BookingController.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  List<dynamic> BookingList = [];
  int user_id = 0;
  bool _loading = true;
  final BookingController _BookingController = Get.put(BookingController());

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.blueGrey[50], // Background color for the entire page
      body: Obx(() {
        return _BookingController.isLoading.value
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: _BookingController.bookings.value.length,
                itemBuilder: (context, index) {
                  var booking = _BookingController.bookings.value[index];
                  return BookingData(booking: booking);
                },
              );
      }),
    );
  }
}

class BookingData extends StatelessWidget {
  const BookingData({
    super.key,
    required this.booking,
  });

  final dynamic booking; // Assuming the booking object is of dynamic type

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
      decoration: BoxDecoration(
        color: Colors.white, // Background color for each booking
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
            // Room Name (or any other field in your model)
            Text(
              booking['roomName'],
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            ),
            // Single Date (assuming booking has a 'date' field)
            Text(
              'Date: ${booking['date']}',
              style: GoogleFonts.poppins(),
            ),
            // Time Range (Start Time - End Time)
            Text(
              'Time: ${booking['startTime']} - ${booking['endTime']}',
              style: GoogleFonts.poppins(),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                // Edit Button (can be used for modifying bookings in the future)
                IconButton(
                  onPressed: () {
                    // Simulate editing booking (navigate to a mock form)
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
                      // Simulate booking deletion logic (static data removal, etc.)
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
  }
}
