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
  final BookingController _BookingController = Get.put(BookingController());

  @override
  void initState() {
    super.initState();
    loadBookings();
  }

  Future<void> loadBookings() async {
    setState(() {
      _BookingController.isLoading.value = true;
    });

    await _BookingController.getAllBookings();

    setState(() {
      _BookingController.isLoading.value = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      body: Obx(() {
        return _BookingController.isLoading.value
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: _BookingController.userBookings.length,
                itemBuilder: (context, index) {
                  var booking = _BookingController.userBookings[index];

                  // Format date and time
                  String formattedDate = '';
                  String formattedStartTime = '';
                  String formattedEndTime = '';
                  if (booking?.start_time != null) {
                    formattedDate = DateFormat('yyyy-MM-dd').format(booking!.start_time!);
                    formattedStartTime = DateFormat('HH:mm').format(booking.start_time!);
                    formattedEndTime = DateFormat('HH:mm').format(booking.end_time!);
                  } else {
                    formattedDate = 'Invalid date';
                    formattedStartTime = 'XX';
                    formattedEndTime = 'XX';
                  }

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
                            booking!.room_number ?? "Unknown Room",
                            style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                          ),
                          // Date
                          Text(
                            'Date: $formattedDate',
                            style: GoogleFonts.poppins(),
                          ),
                          // Time Range
                          Text(
                            'Time: $formattedStartTime - $formattedEndTime',
                            style: GoogleFonts.poppins(),
                          ),
                          // Company Branch Name
                          Text(
                            booking.company_branch_name ?? "Unknown Company Branch",
                            style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              // Accept Button
                              ElevatedButton(
                                onPressed: () async {
                                  bool confirmed = await showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Confirm Accept'),
                                      content: const Text('Are you sure you want to accept this booking?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context, false),
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () => Navigator.pop(context, true),
                                          child: const Text('Accept'),
                                        ),
                                      ],
                                    ),
                                  );

                                  if (confirmed) {
                                    await _BookingController.updateBookingStatus(bookingId: booking.id, status: 'Approved');
                                    setState(() => loadBookings());
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                ),
                                child: const Text('Accept'),
                              ),
                              const SizedBox(width: 10),
                              // Reject Button
                              ElevatedButton(
                                onPressed: () async {
                                  bool confirmed = await showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Confirm Reject'),
                                      content: const Text('Are you sure you want to reject this booking?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context, false),
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () => Navigator.pop(context, true),
                                          child: const Text('Reject'),
                                        ),
                                      ],
                                    ),
                                  );

                                  if (confirmed) {
                                    await _BookingController.updateBookingStatus(bookingId: booking.id, status: 'Rejected');
                                    setState(() => loadBookings());
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                                child: const Text('Reject'),
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
