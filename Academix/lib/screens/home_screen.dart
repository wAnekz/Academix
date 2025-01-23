import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:academix/data_provider.dart';

class HomeScreen extends StatefulWidget {
  final String selectedCountryName;

  HomeScreen({required this.selectedCountryName});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> universities = [];
  List<dynamic> filteredUniversities = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUniversities().then((_) {
      setState(() {
        filteredUniversities = universities;});
    });
  }

  Future<void> fetchUniversities() async {
    final url =
        'http://universities.hipolabs.com/search?country=${Uri.encodeComponent(widget.selectedCountryName)}';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          universities = json.decode(response.body);
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
    if (universities.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('There is no universities in this country'),
      ));
    }
  }

  void _filterUniversities(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredUniversities = universities;

      } else {
        filteredUniversities = universities.where((university) {
          return university['name']
              .toLowerCase()
              .contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFE5E5E5), // Background color
      body: Column(
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
                    SizedBox(height: 70),
                    Text(
                      'Hello,',
                      style: TextStyle(
                        fontSize: 40,
                        fontFamily: 'Exo-regular',
                      ),
                    ),
                    Text(
                      '${dataProvider.name}',
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 42,
                        fontFamily: 'Exo-semibold',
                      ),
                    ),
                  ],
                ),
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage('assets/images/account.png'),
                ),
              ],
            ),
          ),
          SizedBox(height: 16,),
          Padding(
            padding: const EdgeInsets.all(14),
            child: SizedBox(
              child: TextField(
                onChanged: _filterUniversities,
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
                  filled: true,fillColor: Colors.white,
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
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredUniversities.length,
              itemBuilder: (context, index) {
                final university = filteredUniversities[index];
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          title: Text(
                            university['name'] ?? 'N/A',
                            style: const TextStyle(
                                fontFamily: 'Exo-regular',
                                fontSize: 20),
                          ),
                          subtitle: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text(university['country'] ?? 'N/A'),
                              Text(
                                university['web_pages'] != null &&
                                    university['web_pages']
                                        .isNotEmpty
                                    ? university['web_pages'][0]
                                    : 'N/A',
                                style:
                                TextStyle(color: Colors.blue),
                              ),
                            ],
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
              },),
          ),
        ],
      ),
    );
  }
}