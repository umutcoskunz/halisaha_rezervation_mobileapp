import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? userData;
  bool isLoading = true;

  Future<void> fetchUser(int id) async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:3000/get-user/$id'),
    );

    if (response.statusCode == 200) {
      setState(() {
        userData = json.decode(response.body);
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final user = ModalRoute.of(context)?.settings.arguments as Map?;
    if (user != null && user['id'] != null) {
      fetchUser(user['id']);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (userData == null) {
      return const Scaffold(
        body: Center(child: Text("Kullanıcı bulunamadı ❌")),
      );
    }

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 240, 240, 240),
      appBar: AppBar(
        title: const Text('Profilim'),
        backgroundColor: const Color.fromARGB(255, 13, 49, 14),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            const CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage(
                'https://cdn-icons-png.flaticon.com/512/147/147142.png',
              ),
              backgroundColor: Colors.white,
            ),
            const SizedBox(height: 20),
            Text(
              userData!['name'],
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 13, 49, 14),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              "${userData!['city']}, Türkiye",
              style: const TextStyle(color: Colors.grey),
            ),
            const Divider(height: 40, thickness: 1.2),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(
                      Icons.alternate_email,
                      color: Color.fromARGB(255, 13, 49, 14),
                    ),
                    title: Text(userData!['username']),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(
                      Icons.email,
                      color: Color.fromARGB(255, 13, 49, 14),
                    ),
                    title: Text(userData!['email']),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(
                      Icons.phone,
                      color: Color.fromARGB(255, 13, 49, 14),
                    ),
                    title: Text(userData!['phone']),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/edit_profile',
                  arguments: userData,
                );
              },
              icon: const Icon(Icons.edit),
              label: const Text('Profili Düzenle'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 13, 49, 14),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
