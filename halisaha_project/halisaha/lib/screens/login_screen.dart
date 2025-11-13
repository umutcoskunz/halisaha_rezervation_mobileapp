import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String message = '';

  Future<void> login() async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:3000/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': emailController.text.trim(),
        'password': passwordController.text.trim(),
      }),
    );

    final data = json.decode(response.body);

    if (response.statusCode == 200) {
      setState(() {
        message = data['message'];
      });

      final user = data['user'];

      // Giriş başarılı → kullanıcıyı Home sayfasına gönder
      Future.delayed(const Duration(milliseconds: 600), () {
        Navigator.pushNamed(context, '/home', arguments: user);
      });
    } else {
      setState(() {
        message =
            data['message'] ?? "Giriş başarısız ❌ Lütfen bilgileri kontrol et.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 17, 78, 21),
              Color.fromARGB(255, 13, 49, 14),
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.sports_soccer, color: Colors.white, size: 70),
                const SizedBox(height: 15),
                const Text(
                  'Halı Saha Rezervasyon',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 50),

                // 📧 E-posta / kullanıcı adı / telefon alanı
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'E-posta / Kullanıcı Adı / Telefon',
                    prefixIcon: const Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // 🔒 Şifre
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Şifre',
                    prefixIcon: const Icon(Icons.lock),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // 🚪 Giriş Butonu
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 13, 49, 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: login,
                    child: const Text(
                      'Giriş Yap',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                // 🧾 Kayıt Ol bağlantısı
                TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/register'),
                  child: const Text(
                    'Hesabın yok mu? Kayıt ol',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),

                const SizedBox(height: 15),

                // 🔔 Geri bildirim mesajı
                if (message.isNotEmpty)
                  Text(
                    message,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
