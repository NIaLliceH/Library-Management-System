import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';

void go_back() {
  print("go back");
}

// info
class _InfoElement extends StatefulWidget {
  final String title, content;
  const _InfoElement(this.title, this.content);
  @override
  State<StatefulWidget> createState() => _InfoState();
}

class _InfoState extends State<_InfoElement> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: TextStyle(
              fontSize: smallFont,
              color: Colors.black,
              fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 3),
        Row(children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: kBase5Color),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: Text(
                  widget.content,
                  style: TextStyle(fontSize: smallFont),
                ),
              ),
            ),
          ),
        ]),
      ],
    );
  }
}

// Screen
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String name = "Hoa",
      id = "123",
      department = "abc",
      dob = "10/10/2004",
      gender = "Male",
      joinDate = "5/11/2024";

  @override
  Widget build(BuildContext context) {
    double screensize = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: go_back, icon: Icon(Icons.arrow_back)),
        centerTitle: true,
        title: const Text(
          'Profile',
          style: TextStyle(
            fontSize: bigFont,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: screensize,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(3),
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: kBase5Color),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(80),
                  child: Image.network(
                    'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
                    width: 130,
                    height: 130,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: screensize,
                margin: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _InfoElement("Name", name),
                    SizedBox(height: 10),
                    _InfoElement("ID", id),
                    SizedBox(height: 10),
                    _InfoElement("Department", department),
                    SizedBox(height: 10),
                    _InfoElement("Date of birth", dob),
                    SizedBox(height: 10),
                    _InfoElement("Gender", gender),
                    SizedBox(height: 10),
                    _InfoElement("Join date", joinDate),
                    SizedBox(height: 10),
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
