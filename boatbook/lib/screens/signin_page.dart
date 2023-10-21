// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:boatbook/components/button.dart';
import 'package:boatbook/components/textfield.dart';
import 'package:boatbook/components/square_tile.dart';
import 'package:boatbook/providers/AuthProvider.dart';
import 'package:boatbook/screens/signup_page.dart';
import 'package:boatbook/utilities/verification.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  String? jwtToken;
  // text editing controllers
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  // sign user in method
  void signUserIn(BuildContext context) async {
    // final authProvider = Provider.of<AuthProvider>(context, listen: false);
    // final jwtToken = authProvider.jwtToken;

    // print(jwtToken);
    String url = "http://192.168.1.5:8080/api/v1/auth/authenticate";
    String userEmailOrUserName = usernameController.text.trim();
    String password = passwordController.text.trim();
    final hashedPassword = "";
    print(hashedPassword);

    Map<String, String> requestBody = {
      'email': userEmailOrUserName,
      'password': password
    };

    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      final userId = jsonResponse['userId'] as int;
      final String? jwtToken = jsonResponse['token'];

      print("Auth success");
      print("UserId: $userId");
      print("JWT: $jwtToken");
      if (jwtToken != null) {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        authProvider.setJwtToken(jwtToken);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Verification(
              userId: userId,
            ),
          ),
        );
      }
    } else if (response.statusCode == 401) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Authentication Failed'),
              content:
                  const Text('Invalid username or password. Please try again.'),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("OK"))
              ],
            );
          });
    } else {
      print('Unexpected status code: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: FadeInDown(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),

                  // logo
                  const Icon(
                    Icons.lock,
                    size: 100,
                  ),

                  const SizedBox(height: 50),

                  // welcome back, you've been missed!
                  Text(
                    'Welcome back you\'ve been missed!',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 17,
                    ),
                  ),

                  const SizedBox(height: 25),

                  // username textfield
                  Textfield1(
                    controller: usernameController,
                    hintText: 'Username',
                    obscureText: false,
                  ),

                  const SizedBox(height: 10),

                  // password textfield
                  Textfield1(
                    controller: passwordController,
                    hintText: 'Password',
                    obscureText: true,
                  ),

                  const SizedBox(height: 10),

                  // forgot password?
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Forgot Password?',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  // sign in button
                  Button(
                    text: 'Sign In',
                    onPressed: () => signUserIn(context),
                  ),

                  const SizedBox(height: 50),

                  // or continue with
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Colors.grey[400],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            'Or continue with',
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 50),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SquareTile(imagePath: 'assets/images/google.png'),
                      SizedBox(width: 25),
                      SquareTile(imagePath: 'assets/images/facebook.png')
                    ],
                  ),

                  const SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Not a member?',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignUpPage()));
                        },
                        child: const Hero(
                          tag: 'registerButton',
                          child: Material(
                            color: Colors.transparent,
                            child: Text(
                              'Register now',
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
