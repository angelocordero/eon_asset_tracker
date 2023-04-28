import 'package:eon_asset_tracker/screens/home_screen.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  static final TextEditingController usernameController =
      TextEditingController();
  static final TextEditingController passwordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('User Login'),
                  usernameField(),
                  passwordField(),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return const HomeScreen();
                            },
                          ),
                        );
                      },
                      child: const Text('Login')),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget usernameField() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('Username: '),
        const SizedBox(
          width: 30,
        ),
        SizedBox(
          width: 150,
          child: TextField(
            controller: usernameController,
          ),
        ),
      ],
    );
  }

  Widget passwordField() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('Password: '),
        const SizedBox(
          width: 30,
        ),
        SizedBox(
          width: 150,
          child: TextField(
            controller: passwordController,
          ),
        ),
      ],
    );
  }
}
