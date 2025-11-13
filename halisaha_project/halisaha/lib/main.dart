import 'package:flutter/material.dart';

// 📂 Ekran importları
import 'package:halisaha/screens/login_screen.dart';
import 'package:halisaha/screens/register_screen.dart';
import 'package:halisaha/screens/home_screen.dart';
import 'package:halisaha/screens/fields_screen.dart';
import 'package:halisaha/screens/reservation_screen.dart';
import 'package:halisaha/screens/profile_screen.dart';
import 'package:halisaha/screens/edit_profile_screen.dart';
import 'package:halisaha/screens/my_reservations_screen.dart';

void main() {
  runApp(const HaliSahaApp());
}

class HaliSahaApp extends StatelessWidget {
  const HaliSahaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Halı Saha Rezervasyon',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),

      // 🏁 Uygulama açılış rotası
      initialRoute: '/login',

      // 🌍 Tüm sayfa rotaları
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/fields': (context) => const FieldsScreen(),
        '/reserve': (context) => const ReservationScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/edit_profile': (context) => const EditProfileScreen(),
        '/my_reservations': (context) => const MyReservationsScreen(),
      },
    );
  }
}
