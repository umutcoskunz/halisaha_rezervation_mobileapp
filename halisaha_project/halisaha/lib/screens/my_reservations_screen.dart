import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MyReservationsScreen extends StatefulWidget {
  const MyReservationsScreen({super.key});

  @override
  State<MyReservationsScreen> createState() => _MyReservationsScreenState();
}

class _MyReservationsScreenState extends State<MyReservationsScreen> {
  late int userId;
  List<dynamic> reservations = [];
  bool loading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    Map<String, dynamic> user = {};
    if (args != null && args is Map<String, dynamic>) {
      user = args;
    }
    userId = user['id'] ?? 0;
    _fetchReservations();
  }

  Future<void> _fetchReservations() async {
    setState(() => loading = true);
    try {
      final res = await http.get(
        Uri.parse('http://10.0.2.2:3000/reservations/$userId'),
      );
      if (res.statusCode == 200) {
        reservations = jsonDecode(res.body) as List<dynamic>;
      } else {
        reservations = [];
      }
    } catch (_) {
      reservations = [];
    }
    setState(() => loading = false);
  }

  Color _statusColor(String s) {
    switch (s) {
      case 'confirmed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Rezervasyonlarım"),
        backgroundColor: const Color.fromARGB(255, 13, 49, 14),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : reservations.isEmpty
          ? const Center(child: Text("Aktif rezervasyonunuz bulunmuyor."))
          : RefreshIndicator(
              onRefresh: _fetchReservations,
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: reservations.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, i) {
                  final r = reservations[i] as Map<String, dynamic>;
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(14),
                      leading: CircleAvatar(
                        radius: 26,
                        backgroundColor: const Color.fromARGB(255, 13, 49, 14),
                        child: const Icon(
                          Icons.sports_soccer,
                          color: Colors.white,
                        ),
                      ),
                      title: Text(
                        r['fieldName'] ?? '-',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text("Şehir: ${r['location']}"),
                          Text("Gün/Saat: ${r['day']} • ${r['time']}"),
                          Text("Ücret: ${r['price']}₺ / saat"),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: _statusColor(
                                    r['status'] ?? 'pending',
                                  ).withOpacity(.15),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  (r['status'] ?? 'pending')
                                      .toString()
                                      .toUpperCase(),
                                  style: TextStyle(
                                    color: _statusColor(
                                      r['status'] ?? 'pending',
                                    ),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "Oluşturma: ${(r['createdAt'] ?? '').toString().replaceFirst('T', ' ').split('.').first}",
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
