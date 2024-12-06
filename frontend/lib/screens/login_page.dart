import 'package:flutter/material.dart';
import 'package:frontend/api_service.dart';
import 'package:frontend/auth_service.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/globals.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _email = 'khanh@hcmut.edu.vn'; // testing
  String _password = '123';

  // String _email = '';
  // String _password = '';
  bool _obscuredText = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscuredText = !_obscuredText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(30),
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/background2.jpg'),
                fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              // app name and logo
              Padding(
                padding: const EdgeInsets.only(top: 100.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // app name
                    Text(
                      'BKLIB',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 60,
                        color: Colors.white,
                      ),
                    ),
                    // app logo
                    Container(
                      height: 90,
                      width: 100,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/images/logo.png'),
                            fit: BoxFit.fill),
                      ),
                    )
                  ],
                ),
              ),
              // welcome message
              Container(
                padding: const EdgeInsets.only(top: 150.0),
                alignment: Alignment.topLeft,
                child: Text(
                  'Welcome back!',
                  style: TextStyle(
                    fontSize: 25,
                    color: kBase4,
                  ),
                ),
              ),
              // login form
              Container(
                margin: EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 14.0,
                        offset: Offset(0, 9),
                      )
                    ]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // username input
                    Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: Colors.black.withOpacity(0.2),
                              )
                          )
                      ),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'email',
                          hintStyle: TextStyle(
                              color: Color.fromARGB(255, 201, 201, 201),
                          ),
                          prefixIcon: Icon(Icons.person),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _email = value;
                          });
                        },
                      ),
                    ),
                    // password input
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        obscureText: _obscuredText,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                              color: Color.fromARGB(255, 201, 201, 201)
                          ),
                          hintText: 'password',
                          prefixIcon: Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscuredText
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
                  ],
                ),
              ),
              // submit button -> call loginStudent()
              TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: loginButton,
                    minimumSize: Size(200, 50),
                  ),
                  onPressed: () async {
                    try {
                      final user = await ApiService.loginStudent(_email, _password);
                      thisUser = user;
                      await AuthService.saveLoginState(true);
                      if (context.mounted) {
                        Navigator.pushReplacementNamed(context, '/');
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar( // !!! AlertDialog
                            content: Text(e.toString()),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
                  child: Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white
                    ),
                  )),
              // forget password
              TextButton(
                child: Text(
                  'Forget password?',
                  style: TextStyle(
                    color: placeholderText,
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
      ),
    );
  }
}