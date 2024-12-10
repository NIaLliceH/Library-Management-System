// import 'package:frontend/models/user.dart';
//
// // no need anymore
// class Admin extends User {
//   final String jobType;
//
//   Admin({
//     required super.id,
//     required super.name,
//     required super.email,
//     required super.avatarUrl,
//     required super.address,
//     required super.phoneNum,
//     // required super.role,
//     required super.gender,
//     required this.jobType,
//   });
//
//   factory Admin.fromJson(Map<String, dynamic> json) {
//     return Admin(
//       id: json['_id'],
//       name: json['name'],
//       email: json['email'],
//       avatarUrl: json['avatarUrl'] ?? 'https://drive.google.com/uc?export=view&id=1oxjzdaMKjybjbwoduSXd9mGGJDPTcJD6', // placeholder image
//       address: json['address'],
//       phoneNum: json['phoneNum'],
//       // role: json['role'],
//       jobType: json['jobType'],
//       gender: json['gender'],
//     );
//   }
// }