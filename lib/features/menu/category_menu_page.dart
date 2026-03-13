import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    final filteredItems = _allItems.where((item) {
      final categoryMatch = item["category"] == widget.categoryName;
      final name = item["name"]?.toString().toLowerCase() ?? "";
      final searchMatch = name.contains(_searchText.toLowerCase());

      return categoryMatch && searchMatch;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryName),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        _searchText = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: "${widget.categoryName} içinde ara...",
                      prefixIcon: const Icon(Icons.search),
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
                    ),
                  ),
                ),
                Expanded(
                  child: filteredItems.isEmpty
                      ? Center(
                          child: Text(
                            _searchText.isEmpty
                                ? "${widget.categoryName} kategorisinde ürün bulunamadı."
                                : "Aramaya uygun ürün bulunamadı.",
                            style: const TextStyle(fontSize: 16),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: filteredItems.length,
                          itemBuilder: (context, index) {
                            final item = filteredItems[index];

                            return Card(
                              child: ListTile(
                                title: Text(
                                  item["name"].toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(item["category"].toString()),
                                trailing: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "₺${item["price"]}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    FilledButton.tonal(
                                      onPressed: () {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              "${item["name"]} sepete eklendi",
                                            ),
                                          ),
                                        );
                                      },
                                      child: const Text("Ekle"),
                                    )
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
