import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController nameCtrl;
  late TextEditingController usernameCtrl;
  late TextEditingController emailCtrl;
  late TextEditingController phoneCtrl;
  late TextEditingController cityCtrl;
  late int userId;

  String? selectedCity;

  // Türkiye şehir listesi
  final List<String> cities = [
    'Adana',
    'Adıyaman',
    'Afyonkarahisar',
    'Ağrı',
    'Amasya',
    'Ankara',
    'Antalya',
    'Artvin',
    'Aydın',
    'Balıkesir',
    'Bilecik',
    'Bingöl',
    'Bitlis',
    'Bolu',
    'Burdur',
    'Bursa',
    'Çanakkale',
    'Çankırı',
    'Çorum',
    'Denizli',
    'Diyarbakır',
    'Edirne',
    'Elazığ',
    'Erzincan',
    'Erzurum',
    'Eskişehir',
    'Gaziantep',
    'Giresun',
    'Gümüşhane',
    'Hakkari',
    'Hatay',
    'Isparta',
    'Mersin',
    'İstanbul',
    'İzmir',
    'Kars',
    'Kastamonu',
    'Kayseri',
    'Kırklareli',
    'Kırşehir',
    'Kocaeli',
    'Konya',
    'Kütahya',
    'Malatya',
    'Manisa',
    'Kahramanmaraş',
    'Mardin',
    'Muğla',
    'Muş',
    'Nevşehir',
    'Niğde',
    'Ordu',
    'Rize',
    'Sakarya',
    'Samsun',
    'Siirt',
    'Sinop',
    'Sivas',
    'Tekirdağ',
    'Tokat',
    'Trabzon',
    'Tunceli',
    'Şanlıurfa',
    'Uşak',
    'Van',
    'Yozgat',
    'Zonguldak',
    'Aksaray',
    'Bayburt',
    'Karaman',
    'Kırıkkale',
    'Batman',
    'Şırnak',
    'Bartın',
    'Ardahan',
    'Iğdır',
    'Yalova',
    'Karabük',
    'Kilis',
    'Osmaniye',
    'Düzce',
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final user = ModalRoute.of(context)?.settings.arguments as Map?;
    userId = user?['id'];
    nameCtrl = TextEditingController(text: user?['name']);
    usernameCtrl = TextEditingController(text: user?['username']);
    emailCtrl = TextEditingController(text: user?['email']);
    phoneCtrl = TextEditingController(text: user?['phone']);
    cityCtrl = TextEditingController(text: user?['city']);
    selectedCity = user?['city'];
  }

  Future<void> saveProfile() async {
    final response = await http.put(
      Uri.parse('http://10.0.2.2:3000/edit-user/$userId'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'name': nameCtrl.text,
        'username': usernameCtrl.text,
        'email': emailCtrl.text,
        'phone': phoneCtrl.text,
        'city': cityCtrl.text,
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil başarıyla güncellendi ✅')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Bir hata oluştu ❌')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profili Düzenle'),
        backgroundColor: const Color.fromARGB(255, 13, 49, 14),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(
                labelText: 'Ad Soyad',
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: usernameCtrl,
              decoration: const InputDecoration(
                labelText: 'Kullanıcı Adı',
                prefixIcon: Icon(Icons.alternate_email),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: emailCtrl,
              decoration: const InputDecoration(
                labelText: 'E-posta',
                prefixIcon: Icon(Icons.email),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: phoneCtrl,
              decoration: const InputDecoration(
                labelText: 'Telefon',
                prefixIcon: Icon(Icons.phone),
              ),
            ),
            const SizedBox(height: 15),

            // Şehir dropdown
            DropdownButtonFormField<String>(
              value: selectedCity,
              items: cities.map((city) {
                return DropdownMenuItem(value: city, child: Text(city));
              }).toList(),
              decoration: const InputDecoration(
                labelText: 'Şehir',
                prefixIcon: Icon(Icons.location_city),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  selectedCity = value!;
                  cityCtrl.text = value;
                });
              },
            ),

            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: saveProfile,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 13, 49, 14),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text(
                'Kaydet',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
