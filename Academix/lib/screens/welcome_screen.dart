import 'package:flutter/material.dart';
import 'sign_up_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE5E5E5),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Image(
              image: AssetImage('assets/images/welcome.png'),
              height: 400,
              width: 400,
            ),
            const SizedBox(height: 20),

            const Text(
              'Welcome to Academix!',
              style: TextStyle(
                color: Colors.black,
                fontSize: 36,
                height: 2,
                fontFamily: 'Exo-semibold'
              ),
            ),
            const SizedBox(height: 16),

            const Text(
              'Discover universities tailored just for you.\n'
                  '    Sign in for a personalized experience',
              style: TextStyle(
                color: Color(0xFF636D77),
                fontSize: 22,
                fontFamily: 'Exo-regular'
              ),
            ),
            const SizedBox(height: 50),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignUpScreen())
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 14),
                backgroundColor: const Color(0xFF5667FD),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                'Let\'s go!',
                style: TextStyle(fontSize: 30, fontFamily: 'Exo-semibold'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}