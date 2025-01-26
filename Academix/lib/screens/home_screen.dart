import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'web_site.dart';
import 'package:flutter/gestures.dart';
import 'sign_in_screen.dart';
import 'country_selection_screen.dart';


class HomeScreen extends StatefulWidget {

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> universities = [];
  List<dynamic> filteredUniversities = [];
  bool isLoading = true;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getUserData().then((userData) {
      final userCountry = userData['country'] ?? 'Unknown';
      fetchUniversities(userCountry);
    });
  }


  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterUniversities() {
    setState(() {
      if (_searchController.text.isEmpty) {
        filteredUniversities = universities; // Если поле пустое, показываем все университеты
      } else {
        filteredUniversities = universities.where((university) {
          return university['name']
              .toLowerCase()
              .contains(_searchController.text.toLowerCase()); // Фильтруем по названию
        }).toList();
      }
    });
  }

  Future<void> fetchUniversities(String userCountry) async {
    final url =
        'http://universities.hipolabs.com/search?country=${Uri.encodeComponent(userCountry)}';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          universities = json.decode(response.body);
          filteredUniversities = universities;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load universities');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error fetching data: $e'),
      ));
    }
  }


  Future<Map<String, String>> _getUserData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists && userDoc.data() != null) {
          final data = userDoc.data()!;
          return {
            'name': data['name'] as String,
            'country': data['country'] as String,
          };
        } else {
          return {'name': 'User not found', 'country': 'Country not found'};
        }
      } else {
        return {'name': 'Not authenticated', 'country': 'Not authenticated'};
      }
    } catch (e) {
      print('Error fetching user data: $e');
      return {'name': 'Error', 'country': 'Error'};
    }
  }

  void _handleListItemTap(dynamic university) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UniversityWebView(university: university),
      ),
    );
  }

  void _showBottomSheet(BuildContext context, String name,) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.5,
            color: Colors.white,
            child: Center(
              child: Column(
                children: [
                  SizedBox(height: 16,),
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('assets/images/account.png'),
                  ),
                  SizedBox(height: 10,),
                  Text(
                    name,
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 42,
                      fontFamily: 'Exo-regular',
                    ),
                  ),
                  SizedBox(height: 50,),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const CountrySelectionScreen()));
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
                      'Change country',
                      style: TextStyle(fontSize: 26, fontFamily: 'Exo-semibold'),
                    ),
                  ),
                  SizedBox(height: 30,),
                  RichText(
                    text: TextSpan(
                      text: "",
                      children: [
                        TextSpan(
                          text: "Sign out",
                          style: const TextStyle(
                              color: Color(0xFF5667FD),
                              fontWeight: FontWeight.w400,
                              fontSize: 26,
                              fontFamily: 'Exo-regular'
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async{
                              try {
                                //пробуем выходить из акка
                                await FirebaseAuth.instance.signOut();
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(builder: (context) => const SignInScreen()),
                                      (route) => false,
                                );
                              }
                              catch (e) {
                                // Обработка ошибок
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error signing out: $e')),
                                );
                              }
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE5E5E5),
      body: FutureBuilder<Map<String, String>>(
        future: _getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final userData = snapshot.data!;
            final userName = userData['name'] as String;
            final userCountry = userData['country'] as String;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 50),
                          Text(
                            'Hello,',
                            style: TextStyle(
                              fontSize: 46,
                              fontFamily: 'Exo-regular',
                            ),
                          ),
                          Text(
                            userName,
                            style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 42,
                              fontFamily: 'Exo-regular',
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          _showBottomSheet(context, userName,);
                        },
                        child: CircleAvatar(
                          radius: 40,
                          backgroundImage: AssetImage('assets/images/account.png'),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: SizedBox(
                    child: TextField(
                      controller: _searchController,  // Привязка к контроллеру
                      decoration: InputDecoration(
                        labelText: 'Search your university',
                        labelStyle: const TextStyle(
                          fontSize: 24,
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
                            child: IconButton(
                              onPressed: _filterUniversities,
                              icon: const Icon(Icons.search_sharp, size: 30,),
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      style: const TextStyle(fontSize: 26),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Popular in',
                        style: TextStyle(
                          fontSize: 34,
                          fontFamily: 'Exo-regular',
                        ),
                      ),
                      Text(
                        userCountry,
                        style: TextStyle(
                          fontSize: 42,
                          fontFamily: 'Exo-semibold',
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredUniversities.length,
                    itemBuilder: (context, index) {
                      final university = filteredUniversities[index];
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListTile(
                                title: Text(
                                  university['name'] ?? 'N/A',
                                  style: const TextStyle(
                                      fontFamily: 'Exo-regular', fontSize: 24),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(university['country'] ?? 'N/A'),
                                    Text(
                                      university['web_pages'] != null &&
                                          university['web_pages']
                                              .isNotEmpty
                                          ? university['web_pages'][0]
                                          : 'N/A',
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  _handleListItemTap(university);
                                },
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
              ],
            );
          } else {
            return Center(child: Text('No user data available'));
          }
        },
      ),
    );
  }
}
