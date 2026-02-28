import 'package:flutter/material.dart';

class SupportPage extends StatelessWidget {
  const SupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          const Card(
            child: ListTile(
              leading: Icon(Icons.support_agent),
              title: Text("Destek"),
              subtitle: Text("Sık sorulan sorular + AI asistan (yakında)"),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView(
              children: [
                _faqTile(context, "Alerjen bilgisi var mı?",
                    "Ürün detay sayfasında alerjenler gösterilecek."),
                _faqTile(context, "Siparişim ne zaman gelir?",
                    "Sipariş durumu ekranından takip edebilirsin."),
                _faqTile(context, "Ödeme nasıl yapılır?",
                    "Kredi kartı / dijital cüzdan / temassız (MVP: simülasyon)."),
              ],
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: FilledButton.tonal(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text(
                          "AI sohbet ekranını sonraki sprintte ekliyoruz.")),
                );
              },
              child: const Text("AI Asistanı Aç (yakında)"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _faqTile(BuildContext context, String q, String a) {
    return Card(
      child: ExpansionTile(
        title: Text(q),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [Text(a)],
      ),
    );
  }
}
