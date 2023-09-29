// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:ffi';

import 'package:animate_do/animate_do.dart';
import 'package:boatbook/components/button.dart';
import 'package:boatbook/components/square_tile.dart';
import 'package:boatbook/models/user.dart';
import 'package:boatbook/screens/phone_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();

  User user = User("", "", "");
  String url = "http://192.168.1.4:8080/api/v1/users/signup1";

  Future save() async {
    var res = await http.post(Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userName': user.name,
          'userEmail': user.email,
          'userPassword': user.password
        }));

    print(res.body);
    print(res.statusCode);
    // ignore: unnecessary_null_comparison
    if (res.statusCode == 200) {
      print("Inside res loop");
      final String? userIdString = res.body;
      if (userIdString != null) {
        print("inside userIdString loop");
        final int userId = int.tryParse(userIdString) ?? 0;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RegisterWithPhoneNumber(userId: userId),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: FadeInDown(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 50),

                    const Text(
                      'Create an Account',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 50),

                    // username textfield
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: TextFormField(
                        controller: TextEditingController(text: user.name),
                        obscureText: false,
                        onChanged: (val) {
                          user.name = val;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'User Name is Empty';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.black.withOpacity(0.13)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade400),
                          ),
                          fillColor: Colors.white,
                          filled: true,
                          hintText: 'UserName',
                          hintStyle: TextStyle(color: Colors.grey.shade500),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: TextFormField(
                        controller: TextEditingController(text: user.email),
                        obscureText: false,
                        onChanged: (val) {
                          user.email = val;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Email is Empty';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.black.withOpacity(0.13)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade400),
                          ),
                          fillColor: Colors.white,
                          filled: true,
                          hintText: 'Email',
                          hintStyle: TextStyle(color: Colors.grey.shade500),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // password textfield
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: TextFormField(
                        controller: TextEditingController(text: user.password),
                        obscureText: true,
                        onChanged: (val) {
                          user.password = val;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Password is Empty';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.black.withOpacity(0.13)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade400),
                          ),
                          fillColor: Colors.white,
                          filled: true,
                          hintText: 'Password',
                          hintStyle: TextStyle(color: Colors.grey.shade500),
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    // sign in button
                    Button(
                      text: 'Sign Up',
                      onPressed: () {
                        final FormState? formState = _formKey.currentState;
                        if (formState != null && formState.validate()) {
                          save();
                        }
                      },
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
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
                        // google button
                        SquareTile(imagePath: 'assets/images/google.png'),

                        SizedBox(width: 25),

                        // facebook button
                        SquareTile(imagePath: 'assets/images/facebook.png')
                      ],
                    ),

                    const SizedBox(height: 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already a member?',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            'Login now',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
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
      ),
    );
  }
}
