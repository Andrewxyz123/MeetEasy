import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BookingPage extends StatelessWidget {
  // Static data for bookings with Room Name, Date, Start Time, and End Time
  final List<Map<String, dynamic>> BookingList = [
    {
      'roomName': 'Room A',
      'date': '2025-01-10',
      'startTime': '10:00 AM',
      'endTime': '12:00 PM',
    },
    {
      'roomName': 'Room B',
      'date': '2025-01-10',
      'startTime': '2:00 PM',
      'endTime': '4:00 PM',
    },
    {
      'roomName': 'Room C',
      'date': '2025-01-11',
      'startTime': '11:00 AM',
      'endTime': '1:00 PM',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50], // Background color for the entire page
      body: ListView.builder(
        itemCount: BookingList.length,
        itemBuilder: (context, index) {
          var booking = BookingList[index];
          return BookingData(booking: booking);
        },
      ),
    );
  }
}

class BookingData extends StatelessWidget {
  const BookingData({
    super.key,
    required this.booking,
  });

  final Map<String, dynamic> booking;

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
            // Room Name
            Text(
              booking['roomName'],
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            ),
            // Single Date
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
