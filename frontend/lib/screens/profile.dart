import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';

//header
class InvertedCornerClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, 0);
    path.lineTo(0, size.height);
    path.quadraticBezierTo(
      size.width / 2,
      size.height - 50,
      size.width,
      size.height,
    );
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
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
              color: Color.fromRGBO(191, 189, 187, 0.8),
              fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 3),
        Row(children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 1, color: kBase5Color),
                ),
                // borderRadius: BorderRadius.circular(10),
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
  String name = "Phan Ngoc Hoa",
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
        backgroundColor: kBase2Color,
        leading: IconButton(
            onPressed: () => {print("Hello")}, icon: Icon(Icons.arrow_back)),
        centerTitle: true,
        title: const Text(
          'Profile',
          style: TextStyle(
            fontSize: bigFont,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          ClipPath(
            clipper: InvertedCornerClipper(),
            child: Container(
              width: screensize,
              height: 120,
              color: kBase2Color,
            ),
          ),
          SingleChildScrollView(
            child: SizedBox(
              width: screensize,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.white),
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
                  Container(
                    width: screensize,
                    margin: EdgeInsets.only(top: 10, left: 30, right: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            '$name #$id',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: kBase2Color,
                            ),
                          ),
                        ),
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
        ],
      ),
    );
  }
}
