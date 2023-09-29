import 'package:animate_do/animate_do.dart';
import 'package:boatbook/components/button.dart';
import 'package:boatbook/components/textfield.dart';
import 'package:boatbook/components/square_tile.dart';
import 'package:boatbook/screens/signup_page.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  // text editing controllers
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  // sign user in method
  void signUserIn() {}

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
                    onPressed: signUserIn,
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
                                  builder: (context) => SignUpPage()));
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
