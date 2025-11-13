import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameController = TextEditingController();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  String? selectedCity;
  String message = '';

  // Türkiye şehir listesi
  final List<String> cities = [
    "Adana",
    "Adıyaman",
    "Afyonkarahisar",
    "Ağrı",
    "Aksaray",
    "Amasya",
    "Ankara",
    "Antalya",
    "Ardahan",
    "Artvin",
    "Aydın",
    "Balıkesir",
    "Bartın",
    "Batman",
    "Bayburt",
    "Bilecik",
    "Bingöl",
    "Bitlis",
    "Bolu",
    "Burdur",
    "Bursa",
    "Çanakkale",
    "Çankırı",
    "Çorum",
    "Denizli",
    "Diyarbakır",
    "Düzce",
    "Edirne",
    "Elazığ",
    "Erzincan",
    "Erzurum",
    "Eskişehir",
    "Gaziantep",
    "Giresun",
    "Gümüşhane",
    "Hakkari",
    "Hatay",
    "Iğdır",
    "Isparta",
    "İstanbul",
    "İzmir",
    "Kahramanmaraş",
    "Karabük",
    "Karaman",
    "Kars",
    "Kastamonu",
    "Kayseri",
    "Kırıkkale",
    "Kırklareli",
    "Kırşehir",
    "Kilis",
    "Kocaeli",
    "Konya",
    "Kütahya",
    "Malatya",
    "Manisa",
    "Mardin",
    "Mersin",
    "Muğla",
    "Muş",
    "Nevşehir",
    "Niğde",
    "Ordu",
    "Osmaniye",
    "Rize",
    "Sakarya",
    "Samsun",
    "Siirt",
    "Sinop",
    "Sivas",
    "Şanlıurfa",
    "Şırnak",
    "Tekirdağ",
    "Tokat",
    "Trabzon",
    "Tunceli",
    "Uşak",
    "Van",
    "Yalova",
    "Yozgat",
    "Zonguldak",
  ];

  Future<void> register() async {
    if (selectedCity == null) {
      setState(() => message = "Lütfen bir şehir seçin!");
      return;
    }

    final response = await http.post(
      Uri.parse('http://10.0.2.2:3000/register'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'name': nameController.text.trim(),
        'username': usernameController.text.trim(),
        'email': emailController.text.trim(),
        'password': passwordController.text.trim(),
        'phone': phoneController.text.trim(),
        'city': selectedCity,
      }),
    );

    final data = json.decode(response.body);
    setState(() {
      message = data['message'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kayıt Ol'),
        backgroundColor: const Color.fromARGB(255, 13, 49, 14),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Ad Soyad',
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: usernameController,
                decoration: const InputDecoration(
                  labelText: 'Kullanıcı Adı',
                  prefixIcon: Icon(Icons.alternate_email),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'E-posta',
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Şifre',
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Telefon',
                  prefixIcon: Icon(Icons.phone),
                ),
              ),
              const SizedBox(height: 15),

              // Şehir seçimi (Dropdown)
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Şehir Seçiniz',
                  prefixIcon: Icon(Icons.location_city),
                  border: OutlineInputBorder(),
                ),
                value: selectedCity,
                items: cities.map((city) {
                  return DropdownMenuItem(value: city, child: Text(city));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCity = value;
                  });
                },
              ),
              const SizedBox(height: 25),

              ElevatedButton(
                onPressed: register,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 13, 49, 14),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text(
                  'Kayıt Ol',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              const SizedBox(height: 15),
              Text(
                message,
                style: TextStyle(
                  color: message.contains('başarılı')
                      ? Colors.green
                      : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
