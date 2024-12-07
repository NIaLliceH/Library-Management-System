import 'package:frontend/models/user.dart';

class Student extends User {
  final String mssv;
  final String faculty;
  final String dob;
  final bool status; // allow or disallow to login
  final int numOfWarning; // number of warnings

  Student({
    required this.mssv,
    required this.faculty,
    required this.dob,
    required this.status,
    required this.numOfWarning,
    required super.id, required super.name, required super.email, required super.avatarUrl, required super.gender, required super.address, required super.joinDate, required super.role});

  factory Student.fromJson(Map<String, dynamic> json) {
    String avatarUrl;
    if (json['avatarUrl'] != null) {
      avatarUrl = json['avatarUrl']; // lmao, bug so funny
    }
    else if (json['gender'] == 'female') {
      avatarUrl = 'https://drive.google.com/uc?export=view&id=1jIKx3DphrLDpPp68Co953Cm6Z_S8daOP';
    }
    else { // if u r not female, u r male :))
      avatarUrl = 'https://drive.google.com/uc?export=view&id=1df6TULh5Q0RWm4c_P7BGIvfIh7jSivPr';
    }

    return Student(
      id: json['userId'] ?? 'N/A',
      name: json['name'] ?? 'N/A',
      email: json['email'] ?? 'N/A',
      gender: json['gender'] ?? 'N/A',
      avatarUrl: avatarUrl,
      address: json['address'] ?? 'N/A',
      role: json['role'] ?? 'N/A',
      mssv: json['MSSV'] ?? 'N/A',
      faculty: json['faculty'] ?? 'N/A',
      dob: json['doB'] ?? 'N/A',
      joinDate: json['joinDate'] ?? 'N/A',
      status: json['status'] == 'on' ? true : false,
      numOfWarning: int.parse(json['noWarning'].toString()),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'userId': id,
      'name': name,
      'avatarUrl': avatarUrl,
      'email': email,
      'role': role,
      'gender': gender,
      'address': address,
      'joinDate': joinDate,
      'MSSV': mssv,
      'doB': dob,
      'faculty': faculty,
      'noWarning': numOfWarning.toString(),
      'status': status,
    };
  }
}