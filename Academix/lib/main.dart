import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Set the home screen to the WelcomeScreen
      home: const WelcomeScreen(),
    );
  }
}

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
                fontWeight: FontWeight.w400,
                height: 2,
              ),
            ),
            const SizedBox(height: 16),

            const Text(
              'Discover universities tailored just for you.\n'
                  '    Sign in for a personalized experience',
              style: TextStyle(
                color: Color(0xFF636D77),
                fontSize: 22,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 100),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignInScreen())
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
                style: TextStyle(fontSize: 30),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
          children: [
            const SizedBox(height: 40,),
            const Image(
              image: AssetImage('assets/images/signIn.png'),
              height: 400,
              width: 500,
            ),

            const SizedBox(height: 60,),

            const Align(
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

            const SizedBox(height: 10,),

            TextFormField(
              decoration: InputDecoration(
                  labelText: 'name@example.com',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white
              ),
            ),

            const SizedBox(height: 30,),

            const Align(
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

            const SizedBox(height: 10,),

            TextField(
              obscureText: !_isPasswordVisible,
              decoration: InputDecoration(
                labelText: 'Enter here',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                  icon: Icon(
                    _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
