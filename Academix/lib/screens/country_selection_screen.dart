import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'home_screen.dart';

class CountrySelectionScreen extends StatefulWidget {
  const CountrySelectionScreen({super.key});

  @override
  State<CountrySelectionScreen> createState() => _CountrySelectionScreenState();
}

class _CountrySelectionScreenState extends State<CountrySelectionScreen> {
  List<dynamic> countries = [];
  List<dynamic> filteredCountries = [];
  String? selectedCountryName;
  int? selectedIndex; // Store the index of the selected country

  @override
  void initState() {
    super.initState();
    _fetchCountries();
  }

  Future<void> _fetchCountries() async {
    final response =
    await http.get(Uri.parse('https://restcountries.com/v3.1/all'));
    if (response.statusCode == 200) {final data = jsonDecode(response.body);
    setState(() {
      countries = data;
      filteredCountries = countries;
    });
    } else {
      throw Exception('Failed to download countries. Try again later');
    }
  }

  void _filterCountries(String query) {
    setState(() {
      filteredCountries = countries.where((country) {
        return country['name']['common']
            .toLowerCase()
            .contains(query.toLowerCase());
      }).toList();
      // Reset selectedIndex when filtering
      selectedIndex = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE5E5E5),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 70),
            const Text(
              'Choose your country',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 40,
                  fontFamily: 'Exo-semibold'),
            ),
            const SizedBox(height: 50),Padding(
              padding: const EdgeInsets.all(14),
              child: TextField(
                onChanged: _filterCountries,
                decoration: InputDecoration(
                  labelText: 'Search..',
                  labelStyle: const TextStyle(
                      fontSize: 26, fontFamily: 'Exo-regular'),
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
                ),
                style: const TextStyle(fontSize: 20),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredCountries.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              if (selectedIndex == index) {
                                selectedIndex = null;
                                selectedCountryName = null;
                              } else {
                                selectedIndex = index;
                                selectedCountryName = filteredCountries[index]['name']['common'];
                              }
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: selectedIndex == index
                                  ? const Color(0xFF5667FD)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              leading: Image.network(
                                filteredCountries[index]['flags']['png'],
                                width: 40,
                                height: 30,
                              ),
                              title: Text(
                                filteredCountries[index]['name']['common'],
                                style: const TextStyle(fontFamily: 'Exo-regular'),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Divider(
                        color: Color(0xFFE5E5E5),
                        thickness: 1,
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                if (selectedIndex != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomeScreen(
                          selectedCountryName: selectedCountryName),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Please choose the country')));
                }
              },
              style: ElevatedButton.styleFrom(
                padding:
                const EdgeInsets.symmetric(horizontal: 100, vertical: 14),
                backgroundColor: const Color(0xFF5667FD),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                'Next',
                style: TextStyle(fontSize: 30),
              ),
            ),
            const SizedBox(height: 70),
          ],
        ),
      ),
    );
  }
}