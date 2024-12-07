import 'package:frontend/models/student.dart';

abstract class User {
  final String id;
  final String name;
  final String email;
  final String avatarUrl;
  final String gender;
  final String address;
  // final String phoneNum;
  final String joinDate;
  final String role;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.avatarUrl,
    required this.gender,
    required this.address,
    // required this.phoneNum,
    required this.joinDate,
    required this.role,
  });

  Map<String, dynamic> toJson();

  factory User.fromJson(Map<String, dynamic> json) {
    // currently, we only implement for student
    if (json['role'] == 'student') {
      return Student.fromJson(json);
    }

    throw Exception('Unknown role');
  }
}