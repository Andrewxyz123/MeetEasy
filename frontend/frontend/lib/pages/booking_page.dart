import 'package:frontend/models/Booking.dart';
import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    loadBookings();  // Call the async function
  }

  Future<void> loadBookings() async {
    setState(() {
      isLoading = true;
    });

    await _BookingController.getAllBookings(); // Assuming this is an async function

    setState(() {
      if (_BookingController.userBookings.isEmpty) {
        print('No Bookings available.');
      } else {
        print('Bookings fetched successfully!');
      }
      isLoading = false; // Stop loading once data is fetched
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50], // Background color for the entire page
      body: Obx(() {
        return _BookingController.isLoading.value
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: _BookingController.userBookings.length,
                itemBuilder: (context, index) {
                  var booking = _BookingController.userBookings[index];
                  
                  // Format the date here
                  String formattedDate = '';
                  if (booking?.start_time != null) {
                    formattedDate = DateFormat('yyyy-MM-dd').format(booking!.start_time!);
                  } else {
                    formattedDate = 'Invalid date';
                  }
                  
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
                          // Room Number (or any other field in your model)
                          Text(
                            booking!.room_number ?? "Unknown Room",
                            style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                          ),
                          // Date (formatted)
                          Text(
                            'Date: $formattedDate', // Show the formatted date
                            style: GoogleFonts.poppins(),
                          ),
                          // Time Range (Start Time - End Time)
                          Text(
                            'Time: ${DateFormat('HH:mm').format(booking.start_time!)} - ${DateFormat('HH:mm').format(booking.end_time!)}',
                            style: GoogleFonts.poppins(),
                          ),
                          // const SizedBox(height: 10),
                          Text(
                            booking!.company_branch_name ?? "Unknown Company Branch",
                            style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              // Edit Button (can be used for modifying bookings in the future)
                              IconButton(
                                onPressed: () {
                                  // Simulate editing booking 
                                  
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
                                    // Simulate booking deletion logic

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
