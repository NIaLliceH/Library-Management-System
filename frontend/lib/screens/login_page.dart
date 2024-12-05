import 'package:flutter/material.dart';
import 'package:frontend/api_service.dart';
import 'package:frontend/models/user.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _email = '';
  String _password = '';
  bool _obsecureText = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obsecureText = !_obsecureText;
    });
  }

  void login() async {
    print('Pressed login');
    try {
      User user = await ApiService.loginStudent(_email, _password);
      print('Login successful: $user');
    } catch (e) {
      print('Error during login: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 700,
            width: 500,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/background.jpg'), fit: BoxFit.fill),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 15,
                ),
                Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 70.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 30,
                          ),
                          Text(
                            'BKLIB',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 65,
                              color: Color.fromARGB(255, 255, 255, 255),
                            ),
                          ),
                          Container(
                            height: 90,
                            width: 120,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('assets/images/logo.png'),
                                  fit: BoxFit.fill),
                            ),
                          )
                        ],
                      ),
                    )),
                SizedBox(
                  height: 150,
                ),
                Container(
                  alignment: Alignment.topLeft,
                  width: 360,
                  child: Text(
                    'Welcome back!',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 30,
                      color: Color.fromARGB(255, 17, 19, 61),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Container(
                  padding: EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(255, 170, 170, 170),
                          blurRadius: 14.0,
                          offset: Offset(0, 9),
                        )
                      ]),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 310,
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: const Color.fromARGB(
                                        255, 219, 219, 219)))),
                        child: TextFormField(
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'username',
                            hintStyle: TextStyle(
                                fontSize: 15,
                                color: Color.fromARGB(255, 201, 201, 201)),
                            prefixIcon: Icon(Icons.person),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _email = value;
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 310,
                          child: TextFormField(
                            obscureText: _obsecureText,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintStyle: TextStyle(
                                  fontSize: 15,
                                  color: Color.fromARGB(255, 201, 201, 201)),
                              hintText: 'password',
                              prefixIcon: Icon(Icons.lock),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obsecureText
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                                onPressed: _togglePasswordVisibility,
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                _password = value;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 28),
                Container(
                  width: 330,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(9),
                    color: Color.fromARGB(255, 85, 139, 255),
                  ),
                  child: TextButton(
                      style: TextButton.styleFrom(
                        textStyle: const TextStyle(fontSize: 25),
                      ),
                      onPressed: () {
                        login();
                      },
                      child: Text(
                        'Login',
                        style: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255)),
                      )),
                ),
                SizedBox(height: 20),
                TextButton(
                  child: Text(
                    'Forget password?',
                    style: TextStyle(
                      color: const Color.fromARGB(255, 167, 167, 167),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  onPressed: () {
                    print('Forget password pressed');
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}