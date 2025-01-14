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
    List<int> startTimeList = List<int>.from(json['startTime']);
    List<int> endTimeList = List<int>.from(json['endTime']);

    return Booking(
      id: json['id'],
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      room: json['room'] != null ? Room.fromJson(json['room']) : null,
      startTime: DateTime(
        startTimeList[0], // year
        startTimeList[1], // month
        startTimeList[2], // day
        startTimeList[3], // hour
        startTimeList[4], // minute
      ),
      endTime: DateTime(
        endTimeList[0], // year
        endTimeList[1], // month
        endTimeList[2], // day
        endTimeList[3], // hour
        endTimeList[4], // minute
      ),
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