import 'package:flutter/material.dart';

import '../cart/cart_page.dart';
import '../support/support_page.dart';
import '../menu/category_menu_page.dart';

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

          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => CategoryMenuPage(categoryName: cat),
            ),
          );
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
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Logo + başlık alanı
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFF97316).withOpacity(0.18),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.restaurant_menu,
                  color: Color(0xFFF97316),
                  size: 30,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  "Ne yemek istersin?",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF92400E),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // Arama alanı
          TextField(
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search_outlined),
              hintText: "Yemek ara...",
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: const BorderSide(
                  color: Color(0xFFF97316),
                  width: 1.5,
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),

          // Günün önerisi / öne çıkan kart
          Container(
            height: 185,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: const LinearGradient(
                colors: [
                  Color(0xFFFFF7ED),
                  Color(0xFFFFEDD5),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFF97316).withOpacity(0.14),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF97316),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            "🔥 Bugünün Önerisi",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          "Trüf Mantarlı Pizza",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF7C2D12),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "Bol malzemeli, özel soslu ve fırından yeni çıktı.",
                          style: TextStyle(
                            color: Color(0xFF9A3412),
                            fontSize: 13,
                          ),
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            const Text(
                              "₺210",
                              style: TextStyle(
                                decoration: TextDecoration.lineThrough,
                                color: Colors.black45,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              "₺179",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFFF97316),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                "15-20 dk",
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                  color: Color(0xFF92400E),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.75),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: const Icon(
                      Icons.local_pizza,
                      size: 70,
                      color: Color(0xFFF97316),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Haftanın en çok bakılanları
          const Text(
            "Haftanın En Çok Bakılanları",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: Color(0xFF7C2D12),
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 245,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: const [
                _FoodCard(
                  name: "Adana Kebap",
                  price: 280,
                  rating: 4.8,
                  time: "15-20 dk",
                  icon: Icons.lunch_dining,
                ),
                SizedBox(width: 14),
                _FoodCard(
                  name: "Karışık Izgara",
                  price: 420,
                  rating: 4.9,
                  time: "20-25 dk",
                  icon: Icons.restaurant,
                ),
                SizedBox(width: 14),
                _FoodCard(
                  name: "Künefe",
                  price: 160,
                  rating: 4.7,
                  time: "10-15 dk",
                  icon: Icons.icecream,
                ),
              ],
            ),
          ),
          const SizedBox(height: 26),

          // Şefin önerileri
          const Text(
            "Şefin Önerileri",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: Color(0xFF7C2D12),
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 245,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: const [
                _FoodCard(
                  name: "Mercimek Çorbası",
                  price: 90,
                  rating: 4.6,
                  time: "10-15 dk",
                  icon: Icons.soup_kitchen,
                ),
                SizedBox(width: 14),
                _FoodCard(
                  name: "Special Steak",
                  price: 520,
                  rating: 4.9,
                  time: "20-30 dk",
                  icon: Icons.set_meal,
                ),
                SizedBox(width: 14),
                _FoodCard(
                  name: "Akdeniz Salata",
                  price: 140,
                  rating: 4.5,
                  time: "8-12 dk",
                  icon: Icons.eco,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _FoodCard extends StatelessWidget {
  final String name;
  final int price;
  final double rating;
  final String time;
  final IconData icon;

  const _FoodCard({
    required this.name,
    required this.price,
    required this.rating,
    required this.time,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Üst görsel alanı
          Container(
            height: 125,
            decoration: BoxDecoration(
              color: const Color(0xFFFFEDD5),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(22),
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  right: 12,
                  top: 12,
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.favorite_border,
                      color: Color(0xFFF97316),
                    ),
                  ),
                ),
                Center(
                  child: Icon(
                    icon,
                    size: 62,
                    color: const Color(0xFFF97316),
                  ),
                ),
              ],
            ),
          ),

          // Alt bilgi alanı
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF7C2D12),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(
                      Icons.star,
                      size: 16,
                      color: Colors.amber,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      rating.toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Icon(
                      Icons.access_time,
                      size: 16,
                      color: Color(0xFF9CA3AF),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      time,
                      style: const TextStyle(
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text(
                      "₺$price",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFFF97316),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF97316),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.add_shopping_cart_outlined,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

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
