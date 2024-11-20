import 'package:flutter/material.dart';
class AuthPage extends StatefulWidget {
  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  String _username = '';
  String _password = '';
  bool _obsecureText = true;

  void _login() {
    print('Username: $_username');
    print('Password: $_password');
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obsecureText = !_obsecureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: Container(
              color: Color(0xFF365486),
              height: 50,
              width: double.infinity,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'BKLIB',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: Color(0xFF0F1035),
                    ),
                  ),
                ],
              )),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Login',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 60,
                  color: Color(0xFF365486),
                ),
              ),
              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: Color.fromARGB(58, 164, 195, 253),
                  borderRadius: BorderRadius.circular(
                      16.0), // Adjust the radius for more or less curvature
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 15.0, right: 15.0, top: 15.0, bottom: 6),
                      child: SizedBox(
                        height: 50,
                        width: 300,
                        child: TextFormField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'username',
                            prefixIcon: Icon(Icons.person),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _username = value;
                            });
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 15.0, right: 15.0, top: 6.0, bottom: 15.0),
                      child: SizedBox(
                        height: 50,
                        width: 300,
                        child: TextFormField(
                          obscureText: _obsecureText,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'password',
                            prefixIcon: Icon(Icons.key),
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
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 15.0, right: 15.0, top: 10.0, bottom: 15.0),
                      child: SizedBox(
                        width: 250,
                        height: 40,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              textStyle: const TextStyle(fontSize: 20),
                              backgroundColor: Color(0xFF7FC7D9),
                            ),
                            onPressed: () {
                              _login();
                            },
                            child: Text(
                              'Login',
                              style: TextStyle(color: Color(0xFF365486)),
                            )),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class AuthPageNewVersion extends StatefulWidget {
  @override
  State<AuthPageNewVersion> createState() => _AuthPageNewVersionState();
}

class _AuthPageNewVersionState extends State<AuthPageNewVersion> {
    String _username = '';
    String _password = '';
    bool _obsecureText = true;

    void _login() {
      print('Username: $_username');
      print('Password: $_password');
    }

    void _togglePasswordVisibility() {
      setState(() {
        _obsecureText = !_obsecureText;
      });
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
                    image: AssetImage('assets/background.jpg'), fit: BoxFit.fill),
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
                                    image: AssetImage('assets/logo.png'),
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
                    alignment:Alignment.topLeft,
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
                                _username = value;
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
                          _login();
                        },
                        child: Text(
                          'Login',
                          style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                        )),
                  ),
                SizedBox(height: 20),
            TextButton(
              child: Text('Forget password?',
              style: TextStyle(
                color: const Color.fromARGB(255, 167, 167, 167),
                fontStyle: FontStyle.italic,
              ),),
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
