import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'sign_in_screen.dart';
import 'package:academix/data_provider.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _isPasswordVisible = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();



  Future<void> _signUp() async {
    if (_nameController.text.isEmpty || _emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please fill all fields')));
      return;
    }

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      final dataProvider = Provider.of<DataProvider>(context, listen: false);
      dataProvider.name = _nameController.text.trim().toString();

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SignInScreen()),
      );



    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message ?? 'Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE5E5E5),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              const Image(
                image: AssetImage('assets/images/sign_up.png'),
                height: 300,
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: CustomTextField(
                  labelText: 'Name',
                  hintText: 'Your name',
                  controller: _nameController,
                  suffixIcon: const Icon(Icons.account_circle)
                ),
              ),

              const SizedBox(height: 30,),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: CustomTextField(
                  labelText: 'Email address',
                  hintText: 'name@example.com',
                  controller: _emailController,
                  suffixIcon: const Icon(Icons.mail),
                ),
              ),

              const SizedBox(height: 30),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: CustomTextField(
                  labelText: 'Password',
                  hintText: 'Enter here',
                  obscureText: !_isPasswordVisible,
                  controller: _passwordController,
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
              ),

              const SizedBox(height: 60),

              ElevatedButton(
                onPressed: _signUp,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 14),
                  backgroundColor: const Color(0xFF5667FD),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  'Sign Up',
                  style: TextStyle(fontSize: 28, fontFamily: 'Exo-semibold'),
                ),
              ),
              const SizedBox(height: 22),
              RichText(
                text: TextSpan(
                  text: "You have an account? ",
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 22,
                    fontFamily: 'Exo-regular'
                  ),
                  children: [
                    TextSpan(
                      text: "Sign in",
                      style: const TextStyle(
                        color: Color(0xFF5667FD),
                        fontWeight: FontWeight.w400,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const SignInScreen()),
                          );
                        },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}