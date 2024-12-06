import 'package:frontend/globals.dart';
import 'package:frontend/models/user.dart';

class Student extends User {
  final String mssv;
  final String faculty;
  final String dob;

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
    if (json['avatar'] != null) {
      // avatarUrl = json['avatar'];
      avatarUrl = 'https://drive.google.com/uc?export=view&id=1jIKx3DphrLDpPp68Co953Cm6Z_S8daOP'; // testing
    }
    else if (json['gender'] == 'female') {
      avatarUrl = 'https://drive.google.com/uc?export=view&id=1jIKx3DphrLDpPp68Co953Cm6Z_S8daOP';
    }
    else { // if u r not female, u r male :))
      avatarUrl = 'https://drive.google.com/uc?export=view&id=1df6TULh5Q0RWm4c_P7BGIvfIh7jSivPr';
    }

    return Student(
      id: json['ID_user'],
      name: json['name'] ?? 'N/A',
      email: json['email'] ?? 'N/A',
      gender: json['gender'] ?? 'N/A',
      avatarUrl: avatarUrl,
      address: json['address'] ?? 'N/A',
      phoneNum: json['phoneNum'] ?? 'N/A',
      // role: json['role'],
      mssv: json['MSSV'] ?? 'N/A',
      faculty: json['faculty'] ?? 'N/A',
      dob: json['dob'] ?? 'N/A',
    );
  }
}