// ignore_for_file: library_private_types_in_public_api, unused_field

import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:boatbook/providers/AuthProvider.dart';
import 'package:boatbook/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter_verification_code/flutter_verification_code.dart';
import 'package:provider/provider.dart';

class Verification extends StatefulWidget {
  final int userId;
  const Verification({Key? key, required this.userId}) : super(key: key);

  @override
  _VerificatoinState createState() => _VerificatoinState();
}

class _VerificatoinState extends State<Verification> {
  bool _isResendAgain = false;
  bool _isVerified = false;
  bool _isLoading = false;

  String _code = '';
  String? jwtToken;
  

  late Timer _timer;
  int _start = 60;
  int _currentIndex = 0;

  void resend() {
    setState(() {
      _isResendAgain = true;
    });

    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (timer) {
      setState(() {
        if (_start == 0) {
          _start = 60;
          _isResendAgain = false;
          timer.cancel();
        } else {
          _start--;
        }
      });
    });
  }

  verify() {
    setState(() {
      _isLoading = true;
    });
    print("verify function called");
    print(_code);
    print(widget.userId);

    verifyOtpOnServer(widget.userId, _code).then((bool isOtpValid) {
      const oneSec = Duration(milliseconds: 2000);
      _timer = Timer.periodic(oneSec, (timer) {
        setState(() {
          _isLoading = false;
          if (isOtpValid) {
            print("it is true");
            _isVerified = true;
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const HomeScreen(),
              ),
            );
          }
        });
      });
    });
  }

  Future<bool> verifyOtpOnServer(int userId, String enteredOtp) async {
    const url = 'http://192.168.1.5:8080/api/v1/auth/verify';

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final jwtToken = authProvider.jwtToken;

    print('JWT Token: $jwtToken');
    String userId = widget.userId.toString();
    print(userId);
    print(enteredOtp);

    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode({
        'userId': userId,
        'enteredOtp': enteredOtp,
      }),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $jwtToken',
      },
    );
    print(response.statusCode);
    print('Request Body: ${jsonEncode({
          'userId': widget.userId.toString(),
          'enteredOtp': enteredOtp
        })}');

    if (response.statusCode == 200) {
      print("T");
      return true;
    } else {
      print("F");
      return false;
    }
  }

  @override
  void initState() {
    Timer.periodic(const Duration(seconds: 5), (timer) {
      setState(() {
        _currentIndex++;

        if (_currentIndex == 3) _currentIndex = 0;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    

    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/done.jpg',
                    fit: BoxFit.cover,
                    width: 280,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  FadeInDown(
                      duration: const Duration(milliseconds: 500),
                      child: const Text(
                        "Verification",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      )),
                  const SizedBox(
                    height: 30,
                  ),
                  FadeInDown(
                    delay: const Duration(milliseconds: 500),
                    duration: const Duration(milliseconds: 500),
                    child: Text(
                      "Please enter the 4 digit code sent to the mobile number",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade500,
                          height: 1.5),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),

                  // Verification Code Input
                  FadeInDown(
                    delay: const Duration(milliseconds: 600),
                    duration: const Duration(milliseconds: 500),
                    child: VerificationCode(
                      length: 4,
                      textStyle:
                          const TextStyle(fontSize: 20, color: Colors.black),
                      underlineColor: Colors.black,
                      keyboardType: TextInputType.number,
                      underlineUnfocusedColor: Colors.black,
                      onCompleted: (value) {
                        setState(() {
                          _code = value;
                        });
                      },
                      onEditing: (value) {},
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),
                  FadeInDown(
                    delay: const Duration(milliseconds: 700),
                    duration: const Duration(milliseconds: 500),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't resive the OTP?",
                          style: TextStyle(
                              fontSize: 14, color: Colors.grey.shade500),
                        ),
                        TextButton(
                            onPressed: () {
                              if (_isResendAgain) return;
                              resend();
                            },
                            child: Text(
                              _isResendAgain
                                  ? "Try again in $_start"
                                  : "Resend",
                              style: const TextStyle(color: Colors.blueAccent),
                            ))
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  FadeInDown(
                    delay: const Duration(milliseconds: 800),
                    duration: const Duration(milliseconds: 500),
                    child: MaterialButton(
                      elevation: 0,
                      onPressed: _code.length < 4
                          ? () => {}
                          : () {
                              verify();
                            },
                      color: const Color.fromARGB(255, 0, 0, 0),
                      minWidth: MediaQuery.of(context).size.width * 0.8,
                      height: 50,
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.white,
                                strokeWidth: 3,
                                color: Colors.black,
                              ),
                            )
                          : _isVerified
                              ? const Icon(
                                  Icons.check_circle,
                                  color: Colors.white,
                                  size: 30,
                                )
                              : const Text(
                                  "Verify",
                                  style: TextStyle(color: Colors.white),
                                ),
                    ),
                  )
                ],
              )),
        ));
  }
}
