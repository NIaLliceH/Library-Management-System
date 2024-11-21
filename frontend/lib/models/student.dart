import 'package:frontend/models/user.dart';

class Student extends User {
  final String mssv;
  final String faculty;
  final DateTime dob;

  Student({
    required super.id,
    required super.name,
    required super.email,
    required super.avatarUrl,
    required super.address,
    required super.phoneNum,
    // required super.role,
    required super.gender,
    required this.mssv,
    required this.faculty,
    required this.dob,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    String avatarUrl;
    if (json['avatarUrl'] != null) {
      avatarUrl = json['avatarUrl'];
    }
    else if (json['gender'] == 'female') {
      avatarUrl = 'https://drive.google.com/uc?export=view&id=1jIKx3DphrLDpPp68Co953Cm6Z_S8daOP';
    }
    else { // if u r not female, u r male :))
      avatarUrl = 'https://drive.google.com/uc?export=view&id=1df6TULh5Q0RWm4c_P7BGIvfIh7jSivPr';
    }

    return Student(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      gender: json['gender'],
      avatarUrl: avatarUrl,
      address: json['address'],
      phoneNum: json['phoneNum'],
      // role: json['role'],
      mssv: json['mssv'],
      faculty: json['faculty'],
      dob: DateTime.parse(json['dob']),
    );
  }
}