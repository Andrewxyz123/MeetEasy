import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:frontend/models/room.dart';

class BookingDetailPage extends StatelessWidget {
  final int? bookingId;
  final Room? selectedRoom;
  final DateTime? startTime;
  final DateTime? endTime;

  const BookingDetailPage({
    Key? key,
    this.bookingId,
    this.selectedRoom,
    this.startTime,
    this.endTime,
  }) : super(key: key);

  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return 'Not available';
    return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Booking Detail',
          style: TextStyle(color: Colors.white), // Set title text color to white
        ),
        backgroundColor: const Color(0xFF4C51BF),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Booking Information',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                title: const Text('Booking ID'),
                subtitle: Text(bookingId?.toString() ?? 'Not available', style: theme.textTheme.bodyLarge),
              ),
              ListTile(
                title: const Text('Room'),
                subtitle: Text(
                  selectedRoom?.roomNumber ?? 'No room selected',
                  style: theme.textTheme.bodyLarge,
                ),
              ),
              ListTile(
                title: const Text('Start Date & Time'),
                subtitle: Text(_formatDateTime(startTime), style: theme.textTheme.bodyLarge),
              ),
              ListTile(
                title: const Text('End Date & Time'),
                subtitle: Text(_formatDateTime(endTime), style: theme.textTheme.bodyLarge),
              ),
              const Spacer(),
              Center(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4C51BF),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Back',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
