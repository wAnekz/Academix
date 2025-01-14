import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final String? selectedCountryName;

  const HomeScreen({Key? key, this.selectedCountryName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Selected Country: $selectedCountryName',
        style: TextStyle(fontSize: 26),),
      ),
    );
  }
}

