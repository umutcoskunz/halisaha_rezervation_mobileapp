import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ReservationScreen extends StatefulWidget {
  const ReservationScreen({super.key});

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  Map<String, dynamic>? fieldData;
  Map<String, dynamic>? user;
  String? selectedDay;
  String? selectedTime;
  bool isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is Map) {
      fieldData = Map<String, dynamic>.from(args['field'] ?? {});
      user = Map<String, dynamic>.from(args['user'] ?? {});
      debugPrint(
        "📦 Gelen field verisi: ${fieldData!['id']} - ${fieldData!['name']}",
      );
      debugPrint("👤 Gelen user verisi: ${user!['id']} - ${user!['username']}");
    } else {
      debugPrint("⚠️ Arguments null geldi!");
    }
  }

  Future<void> makeReservation() async {
    if (selectedDay == null || selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lütfen gün ve saat seçin ❗")),
      );
      return;
    }

    if (user == null || fieldData == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Kullanıcı veya saha verisi eksik ❌")),
      );
      return;
    }

    final userId = user!['id'];
    final fieldId = fieldData!['id'];
    debugPrint(
      "🟢 Gönderilen veriler → userId:$userId fieldId:$fieldId day:$selectedDay time:$selectedTime",
    );

    if (userId == null || fieldId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Eksik kullanıcı veya saha ID'si ❌")),
      );
      return;
    }

    setState(() => isLoading = true);

    final response = await http.post(
      Uri.parse('http://10.0.2.2:3000/reserve'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'userId': userId,
        'fieldId': fieldId,
        'day': selectedDay,
        'time': selectedTime,
      }),
    );

    setState(() => isLoading = false);

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Rezervasyon başarıyla oluşturuldu ✅")),
      );
      Navigator.pop(context);
    } else {
      final msg = jsonDecode(response.body)['message'] ?? "Bir hata oluştu ❌";
      debugPrint("🚨 Sunucu yanıtı: ${response.body}");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (fieldData == null) {
      return const Scaffold(
        body: Center(child: Text("Saha verisi bulunamadı ❌")),
      );
    }

    final availability =
        fieldData!['availability'] as Map<String, dynamic>? ?? {};

    return Scaffold(
      appBar: AppBar(
        title: Text(fieldData!['name'] ?? "Saha Detayı"),
        backgroundColor: const Color.fromARGB(255, 13, 49, 14),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Gün Seçin:",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: availability.keys.map((day) {
                final isSelected = selectedDay == day;
                return ChoiceChip(
                  label: Text(day),
                  selected: isSelected,
                  onSelected: (_) {
                    setState(() {
                      selectedDay = day;
                      selectedTime = null;
                    });
                  },
                  selectedColor: const Color.fromARGB(255, 13, 49, 14),
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 25),
            const Text(
              "Saat Seçin:",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),
            if (selectedDay == null)
              const Text("⏳ Önce bir gün seçin")
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: (availability[selectedDay] as Map<String, dynamic>)
                    .entries
                    .map((entry) {
                      final time = entry.key;
                      final available = entry.value == true;
                      final isSelected = selectedTime == time;

                      return ChoiceChip(
                        label: Text(time),
                        selected: isSelected,
                        onSelected: available
                            ? (_) {
                                setState(() {
                                  selectedTime = time;
                                });
                              }
                            : null,
                        selectedColor: const Color.fromARGB(255, 13, 49, 14),
                        backgroundColor: available
                            ? Colors.grey[200]
                            : Colors.red[100],
                        labelStyle: TextStyle(
                          color: available
                              ? (isSelected ? Colors.white : Colors.black)
                              : Colors.red,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      );
                    })
                    .toList(),
              ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: isLoading ? null : makeReservation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 13, 49, 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Rezervasyon Yap",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
