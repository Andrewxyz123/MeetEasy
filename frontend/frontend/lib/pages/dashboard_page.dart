import 'package:flutter/material.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/models/booking.dart';
import 'package:frontend/models/room.dart';
import 'package:frontend/models/company.dart';
import 'package:intl/intl.dart';

class DashboardPage extends StatelessWidget {
  final Company company;
  final String companyBranch;

  const DashboardPage({
    Key? key,
    required this.company,
    required this.companyBranch,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> arguments = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final User user = arguments['user'];
    final List<Booking> bookingList = arguments['booking-list'];
    final List<Room>? roomList = arguments['room-list'];

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // App Title
              const Row(
                children: [
                  Text(
                    'Meet',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    'Easy',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4C51BF),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Profile Panel
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/profile', arguments: {'user': user});
                },
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.15,
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
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        // User Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Hello, ${user.fullname}',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                company.name ?? 'Company Name',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                user?.role?.name?.toLowerCase() == 'admin'
                                    ? 'Role: Room Manager'
                                    : 'Role: Employee',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Profile Picture
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.blue[100],
                          child: Icon(
                            Icons.person,
                            size: 30,
                            color: Colors.blue[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Booking Button
              Container(
                height: MediaQuery.of(context).size.height * 0.15,
                width: double.infinity,
                child: Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(15),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(15),
                    onTap: () {
                      Navigator.pushNamed(context, '/create-booking');
                    },
                    child: Container(
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
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Book a meeting room at:',
                                  style: TextStyle(fontSize: 14, color: Colors.white),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  companyBranch,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
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
                ),
              ),
              const SizedBox(height: 16),

              // List Sections
              Expanded(
                child: ListView(
                  children: [
                    // Display Upcoming Bookings
                    if (bookingList.isNotEmpty) ...[
                      SectionHeader(
                        title: 'Upcoming Meetings',
                        onViewAll: () {
                          Navigator.pushNamed(context, '/booking-list');
                        },
                      ),
                      ...bookingList.map((booking) => BookingCard(booking: booking)).toList(),
                    ],

                    // Display Room List
                    if (roomList != null && roomList.isNotEmpty) ...[
                      SectionHeader(
                        title: 'Available Rooms',
                        onViewAll: () {
                          Navigator.pushNamed(context, '/room-list');
                        },
                      ),
                      ...roomList.map((room) => RoomCard(room: room)).toList(),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onViewAll;

  const SectionHeader({
    Key? key,
    required this.title,
    required this.onViewAll,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          TextButton(
            onPressed: onViewAll,
            child: const Text(
              'View All',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF3182CE),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BookingCard extends StatelessWidget {
  final Booking booking;

  const BookingCard({Key? key, required this.booking}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Format the date and time here
    String formattedStartTime = DateFormat('HH:mm').format(booking.startTime!);
    String formattedEndTime = DateFormat('HH:mm').format(booking.endTime!);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text('Room ${booking.room?.roomNumber ?? "Unknown Room"}'),
        subtitle: Text('$formattedStartTime - $formattedEndTime'),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: booking.status == 'approved' ? Colors.green[100] : Colors.orange[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            booking.status?.toUpperCase() ?? '',
            style: TextStyle(
              color: booking.status == 'approved' ? Colors.green[700] : Colors.orange[700],
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class RoomCard extends StatelessWidget {
  final Room room;

  const RoomCard({Key? key, required this.room}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text('Room ${room.roomNumber}'),
        subtitle: Text('Capacity: ${room.capacity}'),
      ),
    );
  }
}
