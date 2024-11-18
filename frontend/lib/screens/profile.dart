import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';

enum VariableID { name, id, dep, date, gen, join }

//header
class InvertedCornerClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, 0);
    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 50,
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
  final bool finalLine;
  final bool editState;
  final VariableID state;
  final Function? onUpdate;
  const _InfoElement(this.title, this.content, this.editState, this.state,
      {this.finalLine = false, this.onUpdate, super.key});
  @override
  State<StatefulWidget> createState() => _InfoState();
}

class _InfoState extends State<_InfoElement> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Text(
            widget.title,
            style: TextStyle(
              fontSize: smallFontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        // SizedBox(height: 3),
        Container(
          decoration: widget.finalLine
              ? null
              : BoxDecoration(
                  border: Border(
                    bottom: BorderSide(width: 1, color: kBase5Color),
                  ),
                ),
          child: Theme(
            data: ThemeData(
              inputDecorationTheme: InputDecorationTheme(
                isDense: true,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: TextFormField(
                readOnly: !widget.editState,
                initialValue: widget.content,
                onFieldSubmitted: (value) {
                  widget.onUpdate!(widget.state, value);
                },
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                  hintText: widget.title,
                  labelStyle: TextStyle(
                    fontSize: smallFontSize,
                    fontWeight: FontWeight.w400,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ),
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
  String tempName = "Phan Ngoc Hoa",
      tempDepartment = "abc",
      tempDob = "10/10/2004",
      tempGender = "Male",
      tempJoinDate = "5/11/2024";
  bool editState = false;

  void updateVariable(VariableID id, String newValue) {
    switch (id) {
      case VariableID.name:
        tempName = newValue;
        break;
      case VariableID.date:
        tempDob = newValue;
        break;
      case VariableID.dep:
        tempDepartment = newValue;
        break;
      case VariableID.gen:
        tempGender = newValue;
        break;
      case VariableID.join:
        tempJoinDate = newValue;
        break;
      default:
    }
  }

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
            fontSize: bigFontSize,
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
              height: 50,
              color: const Color.fromRGBO(127, 199, 217, 1),
            ),
          ),
          ClipPath(
            clipper: InvertedCornerClipper(),
            child: Container(
              width: screensize,
              height: 80,
              color: const Color.fromRGBO(127, 199, 217, 0.7),
            ),
          ),
          ClipPath(
            clipper: InvertedCornerClipper(),
            child: Container(
              width: screensize,
              height: 110,
              color: const Color.fromRGBO(127, 199, 217, 0.5),
            ),
          ),
          SingleChildScrollView(
            child: SizedBox(
              width: screensize,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  // SizedBox(height: 5),
                  Container(
                    padding: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: kBase3Color),
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
                    margin: EdgeInsets.only(top: 10, left: 25, right: 25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            'Hi, $name',
                            style: TextStyle(
                              fontSize: titleFontSize,
                              fontWeight: FontWeight.bold,
                              color: kBase3Color,
                            ),
                          ),
                        ),
                        Center(
                          child: Text(
                            '#$id',
                            style: TextStyle(
                              fontSize: bigFontSize,
                              fontWeight: FontWeight.bold,
                              color: kBase3Color,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          width: screensize - 50,
                          padding: EdgeInsets.only(top: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                            color: Colors.white,
                          ),
                          child: Column(
                            children: editState
                                ? [
                                    _InfoElement(
                                      "Name",
                                      name,
                                      true,
                                      VariableID.name,
                                      onUpdate: updateVariable,
                                      key: ValueKey("name"),
                                    ),
                                    SizedBox(height: 10),
                                    _InfoElement(
                                      "Department",
                                      department,
                                      true,
                                      VariableID.dep,
                                      onUpdate: updateVariable,
                                      key: ValueKey("dep"),
                                    ),
                                    SizedBox(height: 10),
                                    _InfoElement(
                                      "Date of birth",
                                      dob,
                                      true,
                                      VariableID.date,
                                      onUpdate: updateVariable,
                                      key: ValueKey("date"),
                                    ),
                                    SizedBox(height: 10),
                                    _InfoElement(
                                      "Gender",
                                      gender,
                                      true,
                                      VariableID.gen,
                                      onUpdate: updateVariable,
                                      key: ValueKey("gen"),
                                    ),
                                    SizedBox(height: 10),
                                    _InfoElement(
                                      "Join date",
                                      joinDate,
                                      true,
                                      VariableID.join,
                                      onUpdate: updateVariable,
                                      finalLine: true,
                                      key: ValueKey("join"),
                                    ),
                                  ]
                                : [
                                    _InfoElement(
                                      "Department",
                                      department,
                                      false,
                                      VariableID.name,
                                    ),
                                    SizedBox(height: 10),
                                    _InfoElement(
                                      "Date of birth",
                                      dob,
                                      false,
                                      VariableID.date,
                                    ),
                                    SizedBox(height: 10),
                                    _InfoElement(
                                      "Gender",
                                      gender,
                                      false,
                                      VariableID.gen,
                                    ),
                                    SizedBox(height: 10),
                                    _InfoElement(
                                      "Join date",
                                      joinDate,
                                      false,
                                      VariableID.join,
                                      finalLine: true,
                                    ),
                                  ],
                          ),
                        ),
                        SizedBox(height: 5),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              if (editState) {
                                name = tempName;
                                department = tempDepartment;
                                dob = tempDob;
                                gender = tempGender;
                                joinDate = tempJoinDate;
                              }
                              editState = !editState;
                              print(editState);
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: editState ? Colors.yellow : kBase2Color,
                            ),
                            width: screensize - 50,
                            height: 40,
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(editState ? "Done" : "Edit Profile"),
                            ),
                          ),
                        ),
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
