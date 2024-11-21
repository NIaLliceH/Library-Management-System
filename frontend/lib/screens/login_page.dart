import 'package:flutter/material.dart';
import 'package:frontend/api_service.dart';

import '../main.dart';

// Thai Hoa, do it :)
// này tui viết tạm để test api, ông thay lại bằng layout của ông nhé
// miễn sao gọi MainPage(user: user) để truyền data của user từ api cho MainPage là đc
class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _attemptLogin(BuildContext context) async {
    try {
      final user = await ApiService.loginStudent(_emailController.text, _passwordController.text);

      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainPage(user: user)),
        );
      }
    } catch(e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: () => _attemptLogin(context),
              child: const Text("Login"),
            ),
          ],
        ),
      ),
    );
  }
}