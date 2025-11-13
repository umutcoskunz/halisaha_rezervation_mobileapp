import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FieldsScreen extends StatefulWidget {
  const FieldsScreen({super.key});

  @override
  State<FieldsScreen> createState() => _FieldsScreenState();
}

class _FieldsScreenState extends State<FieldsScreen> {
  List<dynamic> fields = [];

  @override
  void initState() {
    super.initState();
    fetchFields();
  }

  Future<void> fetchFields() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:3000/fields'));
    if (response.statusCode == 200) {
      setState(() {
        fields = json.decode(response.body);
      });
    } else {
      throw Exception('Veri alınamadı');
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ModalRoute.of(context)?.settings.arguments as Map?;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sahalar'),
        backgroundColor: const Color.fromARGB(255, 13, 49, 14),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: fields.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: fields.length,
              itemBuilder: (context, index) {
                final field = fields[index];

                return Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Stack(
                      children: [
                        // 📸 Arka plan resmi
                        Image.asset(
                          'assets/images/${field['image']}',
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        // 🔳 Alt kısım koyulaştırma efekti
                        Container(
                          height: 180,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.black.withOpacity(0.5),
                                Colors.transparent,
                              ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          ),
                        ),
                        // 📋 Bilgi kutusu
                        Positioned(
                          bottom: 15,
                          left: 15,
                          right: 15,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    field['name'],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '${field['location']} • ${field['price']}₺/saat',
                                    style: const TextStyle(
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  // ✅ Kullanıcı + saha bilgisini birlikte gönderiyoruz
                                  Navigator.pushNamed(
                                    context,
                                    '/reserve',
                                    arguments: {'field': field, 'user': user},
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color.fromARGB(
                                    255,
                                    13,
                                    49,
                                    14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text(
                                  'Rezervasyon Yap!',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
