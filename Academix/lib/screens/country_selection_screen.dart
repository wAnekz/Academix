import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_screen.dart';
import 'dart:async';


class CountrySelectionScreen extends StatefulWidget {
  const CountrySelectionScreen({super.key});

  @override
  _CountrySelectionScreenState createState() => _CountrySelectionScreenState();
}

class _CountrySelectionScreenState extends State<CountrySelectionScreen> {
  List<dynamic> countries = [];
  List<dynamic> filteredCountries = [];
  String? selectedCountryName;
  int? selectedIndex;
  String? userId;

  @override
  void initState() {
    super.initState();
    _fetchCountries();
    _getUserId();  // Получаем userId при инициализации
  }

  // Получаем текущий userId через фаербэйс
  Future<void> _getUserId() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        userId = user.uid;
      });
      _fetchUserData(user.uid);
    }
  }

  // Загружаем данные пользователя из Firestore
  Future<void> _fetchUserData(String userId) async {
    try {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    } catch (e) {
      throw Exception('Error fetching user data: $e');
    }
  }

  // Загрузка списка стран через API
  Future<void> _fetchCountries() async {
    final response = await http.get(Uri.parse('https://restcountries.com/v3.1/all'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
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
                fontSize: 34,
                fontFamily: 'Exo-regular',
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.all(14),
              child: TextField(
                onChanged: _filterCountries,
                decoration: InputDecoration(
                  labelText: 'Search..',
                  labelStyle: const TextStyle(
                    fontSize: 26,
                    fontFamily: 'Exo-regular',
                  ),
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
                  suffixIcon: Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFF5667FD),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.search_sharp,
                        size: 34,
                        color: Colors.white,
                      ),
                    ),
                  ),
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
                                style: const TextStyle(fontFamily: 'Exo-regular', fontSize: 20),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Divider(
                        color: Color(0xFFE5E5E5),
                        thickness: 1,
                        height: 10,
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () async {
                if (selectedIndex != null && userId != null) {
                  try {
                    // Сохраняем страну в Firestore
                    await FirebaseFirestore.instance.collection('users').doc(userId).update({
                      'country': selectedCountryName,
                    });

                    // Переход на другой экран
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeScreen(
                        ),
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to save country: $e')),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please choose a country')),
                  );
                }
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
                'Next',
                style: TextStyle(fontSize: 32),
              ),
            ),
            const SizedBox(height: 70),
          ],
        ),
      ),
    );
  }
}
