import 'package:flutter/material.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          const Card(
            child: ListTile(
              leading: Icon(Icons.shopping_cart),
              title: Text("Sepet (demo)"),
              subtitle: Text("Şimdilik sabit örnek ürünler gösteriliyor."),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView(
              children: const [
                _CartItemTile(name: "Adana Kebap", price: 280, qty: 1),
                _CartItemTile(name: "Ayran", price: 40, qty: 2),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Toplam"),
                      Text("₺360",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  "Sipariş alındı (demo). Mutfak paneline düşecek!")),
                        );
                      },
                      child: const Text("Sipariş Ver"),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CartItemTile extends StatelessWidget {
  final String name;
  final int price;
  final int qty;

  const _CartItemTile({
    required this.name,
    required this.price,
    required this.qty,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(name),
        subtitle: Text("₺$price"),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.remove)),
            Text("$qty"),
            IconButton(onPressed: () {}, icon: const Icon(Icons.add)),
          ],
        ),
      ),
    );
  }
}
