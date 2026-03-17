import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../cart/cart_service.dart';

class CategoryMenuPage extends StatefulWidget {
  final String categoryName;

  const CategoryMenuPage({
    super.key,
    required this.categoryName,
  });

  @override
  State<CategoryMenuPage> createState() => _CategoryMenuPageState();
}

class _CategoryMenuPageState extends State<CategoryMenuPage> {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref("menu");
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> _allItems = [];
  bool _loading = true;
  String _searchText = "";

  @override
  void initState() {
    super.initState();
    loadMenu();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> loadMenu() async {
    try {
      final snapshot = await _dbRef.get();

      if (!snapshot.exists) {
        setState(() {
          _loading = false;
        });
        return;
      }

      final data = snapshot.value;
      List<Map<String, dynamic>> loadedItems = [];

      if (data is List) {
        for (final item in data) {
          if (item != null) {
            loadedItems.add(Map<String, dynamic>.from(item));
          }
        }
      } else if (data is Map) {
        data.forEach((key, value) {
          if (value != null) {
            loadedItems.add(Map<String, dynamic>.from(value));
          }
        });
      }

      setState(() {
        _allItems = loadedItems;
        _loading = false;
      });
    } catch (e) {
      debugPrint("HATA: $e");
      setState(() {
        _loading = false;
      });
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case "Fix Menü":
        return Icons.restaurant_menu;
      case "Kahvaltılar":
        return Icons.free_breakfast;
      case "Specialler":
        return Icons.star_outline;
      case "Salatalar":
        return Icons.eco_outlined;
      case "Soğuk Mezeler":
        return Icons.tapas_outlined;
      case "Ara Sıcaklar":
        return Icons.local_fire_department_outlined;
      case "Balıklar":
        return Icons.set_meal_outlined;
      case "Et Izgaralar":
        return Icons.outdoor_grill;
      case "Tavuk Izgaralar":
        return Icons.lunch_dining_outlined;
      case "Kavurma ve Güveçler":
        return Icons.soup_kitchen_outlined;
      case "Soğuk İçecekler":
        return Icons.local_drink_outlined;
      case "Çaylar ve Kahveler":
        return Icons.coffee_outlined;
      case "Soğuk Kahveler":
        return Icons.icecream_outlined;
      case "Kokteyller":
        return Icons.wine_bar_outlined;
      default:
        return Icons.fastfood_outlined;
    }
  }

  String _getDescription(Map<String, dynamic> item) {
    final name = item["name"]?.toString() ?? "";
    final category = item["category"]?.toString() ?? "";

    return "$name, $category kategorisinde yer alan lezzetli seçeneklerimizden biridir. Ürün detay açıklaması ve görsel alanı daha sonra buraya eklenebilir.";
  }

  void _showProductSheet(BuildContext context, Map<String, dynamic> item) {
    final String name = item["name"]?.toString() ?? "Ürün";
    final String category = item["category"]?.toString() ?? "";
    final String price = item["price"]?.toString() ?? "0";
    final IconData icon = _getCategoryIcon(category);
    final String description = _getDescription(item);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
          decoration: const BoxDecoration(
            color: Color(0xFFF8F4FA),
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(28),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Wrap(
              children: [
                Center(
                  child: Container(
                    width: 48,
                    height: 5,
                    margin: const EdgeInsets.only(bottom: 18),
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 74,
                      height: 74,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFEDD5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        icon,
                        color: const Color(0xFFF97316),
                        size: 36,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF2F2A33),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFEDD5),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              category,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF9A4311),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "₺$price",
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFFF97316),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  "Açıklama",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF2F2A33),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: Color(0xFF5B5560),
                  ),
                ),
                const SizedBox(height: 22),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFFF97316),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    onPressed: () {
                      final int parsedPrice = int.tryParse(price) ?? 0;

                      CartService.instance.addItem(
                        name: name,
                        category: category,
                        price: parsedPrice,
                      );

                      Navigator.pop(context);

                      ScaffoldMessenger.of(this.context).showSnackBar(
                        SnackBar(
                          content: Text("$name sepete eklendi"),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    child: const Text(
                      "Sepete Ekle",
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredItems = _allItems.where((item) {
      final categoryMatch = item["category"] == widget.categoryName;
      final name = item["name"]?.toString().toLowerCase() ?? "";
      final searchMatch = name.contains(_searchText.toLowerCase());

      return categoryMatch && searchMatch;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F4FA),
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        backgroundColor: const Color(0xFFF8F4FA),
        surfaceTintColor: Colors.transparent,
        title: Text(
          widget.categoryName,
          style: const TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 22,
            color: Color(0xFF2F2A33),
          ),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F1F1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() {
                          _searchText = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: "${widget.categoryName} içinde ara...",
                        prefixIcon: const Icon(Icons.search_outlined),
                        suffixIcon: _searchText.isNotEmpty
                            ? IconButton(
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() {
                                    _searchText = "";
                                  });
                                },
                                icon: const Icon(Icons.close),
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 18,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: filteredItems.isEmpty
                      ? Center(
                          child: Text(
                            _searchText.isEmpty
                                ? "${widget.categoryName} kategorisinde ürün bulunamadı."
                                : "Aramana uygun ürün bulunamadı.",
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color(0xFF5B5560),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                          itemCount: filteredItems.length,
                          itemBuilder: (context, index) {
                            final item = filteredItems[index];
                            final String name =
                                item["name"]?.toString() ?? "Ürün";
                            final String category =
                                item["category"]?.toString() ?? "";
                            final String price =
                                item["price"]?.toString() ?? "0";

                            return Container(
                              margin: const EdgeInsets.only(bottom: 14),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(22),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 54,
                                      height: 54,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFFEDD5),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Icon(
                                        _getCategoryIcon(category),
                                        color: const Color(0xFFF97316),
                                        size: 28,
                                      ),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            name,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w900,
                                              color: Color(0xFF2F2A33),
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            category,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Color(0xFF6B6670),
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            "₺$price",
                                            style: const TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w800,
                                              color: Color(0xFFF97316),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF4EAFE),
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      child: IconButton(
                                        onPressed: () =>
                                            _showProductSheet(context, item),
                                        icon: const Icon(
                                          Icons.info_outline,
                                          color: Color(0xFF7C3AED),
                                        ),
                                        tooltip: "Ürün Detayı",
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
