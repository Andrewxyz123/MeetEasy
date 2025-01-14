import 'package:flutter/material.dart';

class RoomDetailPage extends StatelessWidget {
  final int? roomId;
  final String? roomNumber;
  final String? roomType;
  final String? description;
  final int? capacity;

  const RoomDetailPage({
    Key? key,
    required this.roomId,
    required this.roomNumber,
    required this.roomType,
    required this.description,
    required this.capacity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Room Details'),
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
                'Room Information',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                title: const Text('Room ID'),
                subtitle: Text(roomId.toString(), style: theme.textTheme.bodyLarge),
              ),
              ListTile(
                title: const Text('Room Number'),
                subtitle: Text(roomNumber!, style: theme.textTheme.bodyLarge),
              ),
              ListTile(
                title: const Text('Room Type'),
                subtitle: Text(roomType!, style: theme.textTheme.bodyLarge),
              ),
              ListTile(
                title: const Text('Description'),
                subtitle: Text(description!, style: theme.textTheme.bodyLarge),
              ),
              ListTile(
                title: const Text('Capacity'),
                subtitle: Text(capacity.toString(), style: theme.textTheme.bodyLarge),
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
