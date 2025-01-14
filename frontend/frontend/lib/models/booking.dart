import 'package:frontend/models/room.dart';
import 'package:frontend/models/user.dart';

class Booking {
  int? id;
  User? user;
  Room? room;
  DateTime? startTime;
  DateTime? endTime;
  String? status;

  Booking({
    this.id,
    this.user,
    this.room,
    this.startTime,
    this.endTime,
    this.status,
  });

factory Booking.fromJson(Map<String, dynamic> json) {
  return Booking(
    id: json['id'],
    user: json['user'] != null ? User.fromJson(json['user']) : null,
    room: json['room'] != null ? Room.fromJson(json['room']) : null,
    startTime: json['startTime'] != null ? DateTime.parse(json['startTime']) : null,
    endTime: json['endTime'] != null ? DateTime.parse(json['endTime']) : null,
    status: json['status']?.replaceAll('"', ''), // Clean up quotes
  );
}

  Map<String, dynamic> toJson() => {
    'id': id,
    'user': user?.toJson(),
    'room': room?.toJson(),
    'startTime': startTime?.toIso8601String(),
    'endTime': endTime?.toIso8601String(),
    'status': status,
  };
}