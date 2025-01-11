import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'sign_up_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE5E5E5),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),

            const Image(
              image: AssetImage('assets/images/signIn.png'),
              height: 400,
              width: 500,
            ),

            const SizedBox(height: 60),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Email address',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 22,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),


            const SizedBox(height: 10),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: TextFormField(
                decoration: InputDecoration(
                  labelText:'name@example.com',
                  border: InputBorder.none,

                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),

                  filled: true,
                  fillColor: Colors.white,
                  
                  suffixIcon: Icon(Icons.mail)
                ),
                style: const TextStyle(fontSize: 22),
              ),
            ),


            const SizedBox(height: 30),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Password',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 22,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: TextField(
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  labelText: 'Enter here',
                  border: InputBorder.none,

                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),

                  filled: true,
                  fillColor: Colors.white,

                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },

                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                  ),
                ),
                style: const TextStyle(fontSize: 22),
              ),

            ),


            const SizedBox(height: 50),

            ElevatedButton(
              onPressed: () {
                // ЧТО ДЕЛАТЬ ПРИ КНОПКЕ sign in


              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 14),
                backgroundColor: const Color(0xFF5667FD),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                'Sign in',
                style: TextStyle(fontSize: 30),
              ),
            ),

            const SizedBox(height: 40),

            RichText(
              text: TextSpan(
                text: "Don't have an account? ",
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 22,
                  fontWeight: FontWeight.w400
                ),
                children: [
                  TextSpan(
                    text: "Sign up",
                    style: const TextStyle(
                      color: Color(0xFF5667FD),
                      fontWeight: FontWeight.w400,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const SignUpScreen()),
                        );
                      },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
