import 'package:flutter/material.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/models/booking.dart';
import 'package:frontend/models/company.dart';
import 'package:intl/intl.dart';

class DashboardPage extends StatelessWidget {
  final Company company;
  final String companyBranch;
  final List<Booking> upcomingBookings;

  const DashboardPage({
    Key? key,
    required this.company,
    required this.companyBranch,
    required this.upcomingBookings,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use ModalRoute.of(context) to retrieve arguments
    final Map<String, dynamic> arguments = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final User user = arguments['user'];  // Access the user argument

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // App Title
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 16),
                child: const Row(
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
              ),
              
              // Profile Panel
              Container(
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
                      // Left side - User Info
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
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
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              company.name ?? 'Company Name',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'ID: ${user.id}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black87,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Role: ${user.user_role}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black87,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      // Right side - Profile Picture
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blue[100],
                        ),
                        child: Center(
                          child: Icon(
                            Icons.person,
                            size: 30,
                            color: Colors.blue[600],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Booking Button Panel
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
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            const Color(0xFF4C51BF),
                            const Color(0xFF434190),
                          ],
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
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Book a meeting room at:',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  companyBranch,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          const Text(
                            '>',
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
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
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          'Upcoming Meetings',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: upcomingBookings.length,
                          itemBuilder: (context, index) {
                            final booking = upcomingBookings[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              child: ListTile(
                                title: Text(
                                  'Room ${booking.room_number}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      booking.company_branch_name ?? '',
                                      style: const TextStyle(
                                        color: Colors.black87,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      '${DateFormat('MMM dd, HH:mm').format(booking.start_time!)} - ${DateFormat('HH:mm').format(booking.end_time!)}',
                                      style: const TextStyle(
                                        color: Colors.black87,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: Container(
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
        ),
      ),
    );
  }
}
