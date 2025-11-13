import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // login ekranından gelen kullanıcı bilgisi
    final user = ModalRoute.of(context)?.settings.arguments as Map?;
    final userName = user?['username'] ?? "Misafir";

    final cities = ["İstanbul", "Kocaeli", "Ankara", "Antalya", "Eskişehir"];

    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F3),
      appBar: AppBar(
        title: Text(
          'Halı Saha Rezervasyon',
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 13, 49, 14),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 🏞️ Üst banner
            Container(
              height: 220,
              width: double.infinity,
              decoration: const BoxDecoration(color: Colors.black12),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'assets/images/gecebanner.jpg',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Text(
                          "⚠️ Görsel bulunamadı (assets/images/gecebanner.jpg)",
                          style: TextStyle(color: Colors.white70),
                          textAlign: TextAlign.center,
                        ),
                      );
                    },
                  ),
                  Container(
                    color: Colors.black.withOpacity(0.4),
                    alignment: Alignment.center,
                    child: Text(
                      "⚽️ Maç Keyfi Burada Başlar!",
                      style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // 👋 Hoş geldin mesajı
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Hoş geldin, $userName 👋",
                style: GoogleFonts.montserrat(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 13, 49, 14),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // 📝 Açıklama kısmı
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Uygulamamız sayesinde müsait sahaları anında görüntüleyebilir, "
                "ekibinize uygun saatleri seçip saniyeler içinde rezervasyon yapabilirsiniz. "
                "Futbol tutkunlarına özel, kolay ve hızlı bir sistem!",
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  height: 1.6,
                  color: Colors.grey[800],
                ),
                textAlign: TextAlign.justify,
              ),
            ),

            const SizedBox(height: 35),

            // 📍 Şehir kartları
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Aktif Olduğumuz Şehirler",
                style: GoogleFonts.montserrat(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: const Color.fromARGB(255, 13, 49, 14),
                ),
              ),
            ),

            const SizedBox(height: 15),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: cities.map((city) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withOpacity(0.2),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                      border: Border.all(
                        color: const Color.fromARGB(255, 13, 49, 14),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: Colors.green,
                          size: 22,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          city,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 45),

            // ⚽️ Rezervasyon butonu
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/fields',
                    arguments: user, // ✅ kullanıcıyı taşıyoruz
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 13, 49, 14),
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 30,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 5,
                ),
                child: Text(
                  'Rezervasyon Oluştur',
                  style: GoogleFonts.montserrat(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),

      // ⚙️ Drawer menü
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 13, 49, 14),
              ),
              child: Center(
                child: Text(
                  '⚽ Hızlı Menü',
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            // 🏠 Ana Sayfa
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Ana Sayfa'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/home', arguments: user);
              },
            ),
            // ⚽ Sahalar
            ListTile(
              leading: const Icon(Icons.sports_soccer),
              title: const Text('Sahalar'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(
                  context,
                  '/fields',
                  arguments: user,
                ); // ✅ düzeltildi
              },
            ),

            // 👤 Profilim
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profilim'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/profile', arguments: user);
              },
            ),
            // 📅 Rezervasyonlarım
            ListTile(
              leading: const Icon(Icons.calendar_month),
              title: const Text('Rezervasyonlarım'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(
                  context,
                  '/my_reservations',
                  arguments: user, // ✅ kullanıcı bilgisini gönderiyoruz
                );
              },
            ),
            // 🚪 Çıkış Yap
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Çıkış Yap'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
    );
  }
}
