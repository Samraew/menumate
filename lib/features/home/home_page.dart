import 'package:flutter/material.dart';

import '../cart/cart_page.dart';
import '../support/support_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  int _selectedIndex = 1;

  // Kategori listesi (sağ menü)
  final List<String> _categories = const [
    "Fix Menü",
    "Kahvaltılar",
    "Specialler",
    "Salatalar",
    "Soğuk Mezeler",
    "Ara Sıcaklar",
    "Balıklar",
    "Et Izgaralar",
    "Tavuk Izgaralar",
    "Kavurma ve Güveçler",
    "Soğuk İçecekler",
    "Çaylar ve Kahveler",
    "Soğuk Kahveler",
    "Kokteyller",
  ];

  void _toast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  void _openLeftDrawer() => _scaffoldKey.currentState?.openDrawer();
  void _openRightDrawer() => _scaffoldKey.currentState?.openEndDrawer();

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      const CartPage(),
      _HomeContent(
        onOpenContact: _openLeftDrawer,
        onOpenCategoryMenu: _openRightDrawer, // istersen kullanma
      ),
      const SupportPage(),
      const _MenuPlaceholder(), // Menü sekmesine basınca drawer açıyoruz ama placeholder dursun
    ];

    return Scaffold(
      key: _scaffoldKey,

      // ✅ Sol iletişim menüsü
      drawer: _ContactDrawer(
        title: "MenuMate",
        onClose: () => Navigator.of(context).pop(),
      ),

      // ✅ Sağ kategori menüsü
      endDrawer: _CategoryDrawer(
        title: "Kategori Listesi",
        categories: _categories,
        onClose: () => Navigator.of(context).pop(),
        onSelect: (cat) {
          Navigator.of(context).pop();
          _toast("Kategori seçildi: $cat (demo)");
          // Sonra buradan kategori sayfasına gidersin
        },
      ),

      // Gövde (alt bar sabit kalıyor)
      body: pages[_selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFFF97316),
        unselectedItemColor: Colors.black.withOpacity(0.55),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            label: "Sepetim",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: "Ana Sayfa",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.support_agent_outlined),
            label: "Destek",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_outlined),
            label: "Menü",
          ),
        ],
        onTap: (index) {
          // ✅ Menü sekmesi: sayfa değiştirme, sağ drawer aç
          if (index == 3) {
            _openRightDrawer();
            return;
          }
          setState(() => _selectedIndex = index);
        },
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  final VoidCallback onOpenContact;
  final VoidCallback onOpenCategoryMenu;

  const _HomeContent({
    required this.onOpenContact,
    required this.onOpenCategoryMenu,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 8,
        leading: IconButton(
          onPressed: onOpenContact,
          icon: const Icon(Icons.menu),
        ),
        title: const Text(
          "MenuMate",
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 24),
        ),
        // ✅ Sağ üstte kategori butonu istemiyorsun: kaldırdım.
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Sıcak renkli duyuru kartı
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFFEDD5), Color(0xFFFED7AA)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFF97316).withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF97316),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.sentiment_satisfied_alt,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Görüşleriniz Çok Önemli!",
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                          color: Color(0xFF92400E),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Destek bölümünden bize yazabilirsiniz",
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFFB45309),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Arama barı
          TextField(
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search_outlined),
              hintText: "Yemek ara...",
              filled: true,
              fillColor: const Color(0xFFFFF7ED),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(
                  color: Color(0xFFEAAD6B),
                  width: 1.5,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(
                  color: const Color(0xFFF97316).withOpacity(0.35),
                  width: 1.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(
                  color: Color(0xFFF97316),
                  width: 2,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // En Çok Sipariş Edilenler
          const Text(
            "En Çok Sipariş Edilenler",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: Color(0xFF92400E),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 170,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: const [
                _FoodCard(
                  name: "Adana Kebap",
                  price: 280,
                  color: Color(0xFFFFFBEB),
                ),
                SizedBox(width: 12),
                _FoodCard(
                  name: "Karışık Izgara",
                  price: 420,
                  color: Color(0xFFFEF3C7),
                ),
                SizedBox(width: 12),
                _FoodCard(
                  name: "Künefe",
                  price: 160,
                  color: Color(0xFFFED7AA),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Şefin Önerileri
          const Text(
            "Şefin Önerileri",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: Color(0xFF92400E),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 170,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: const [
                _FoodCard(
                  name: "Mercimek Çorbası",
                  price: 90,
                  color: Color(0xFFFFFBEB),
                ),
                SizedBox(width: 12),
                _FoodCard(
                  name: "Special Steak",
                  price: 520,
                  color: Color(0xFFFEF3C7),
                ),
                SizedBox(width: 12),
                _FoodCard(
                  name: "Salata (Akdeniz)",
                  price: 140,
                  color: Color(0xFFFED7AA),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FoodCard extends StatelessWidget {
  final String name;
  final int price;
  final Color color;

  const _FoodCard({
    required this.name,
    required this.price,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFF97316).withOpacity(0.25),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -30,
            bottom: -30,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.restaurant_menu,
                    color: Color(0xFFF97316),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 14,
                        color: Color(0xFF92400E),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF97316),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "₺$price",
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Menü sekmesine basınca sağ drawer açılıyor.
/// Yine de body boş kalmasın diye küçük placeholder.
class _MenuPlaceholder extends StatelessWidget {
  const _MenuPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "Menü sekmesine basınca kategori listesi sağdan açılır.",
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _ContactDrawer extends StatelessWidget {
  final String title;
  final VoidCallback onClose;

  const _ContactDrawer({
    required this.title,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 10, 12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  IconButton(onPressed: onClose, icon: const Icon(Icons.close)),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(12),
                children: [
                  _InfoCard(
                    title: "Adres",
                    lines: [
                      "Kızılcaşehir Mah. Regülatör Cad.",
                      "No:273 Dimçayı, Alanya, Antalya",
                    ],
                  ),
                  _InfoCard(
                    title: "İletişim",
                    lines: [
                      "+90 532 452 77 07",
                      "info@menumate.com",
                    ],
                  ),
                  _InfoCard(
                    title: "Çalışma Saatleri",
                    lines: [
                      "Hafta içi: 09:00 - 00:00",
                      "Hafta sonu: 09:00 - 00:00",
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                "© 2026 MenuMate",
                style: TextStyle(color: Colors.black54),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final List<String> lines;

  const _InfoCard({
    required this.title,
    required this.lines,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
            const SizedBox(height: 8),
            ...lines.map((e) => Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Text(e),
                )),
          ],
        ),
      ),
    );
  }
}

class _CategoryDrawer extends StatelessWidget {
  final String title;
  final List<String> categories;
  final VoidCallback onClose;
  final void Function(String) onSelect;

  const _CategoryDrawer({
    required this.title,
    required this.categories,
    required this.onClose,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 310,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 10, 12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  IconButton(onPressed: onClose, icon: const Icon(Icons.close)),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(12),
                itemCount: categories.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, i) {
                  final c = categories[i];
                  return InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () => onSelect(c),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: const Color(0xFFF97316).withOpacity(0.25),
                        ),
                        color: const Color(0xFFFFF7ED),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              c,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w800),
                            ),
                          ),
                          const Icon(Icons.chevron_right),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
