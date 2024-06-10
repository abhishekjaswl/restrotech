import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../services/auth_service.dart';
import '../widgets/cstm_appbar.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final AuthService authService = AuthService();
  List<String> categories = [
    'All',
    'Starter',
    'Main Course',
    'Drinks',
    'Dessert'
  ];
  String selectedCategory = 'All';
  List<MenuItem> menuItems = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchMenuItems();
  }

  Future<void> fetchMenuItems() async {
    try {
      final response = await http.get(
          Uri.parse('https://66670cb7a2f8516ff7a6169f.mockapi.io/restro/menu'));
      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        setState(() {
          menuItems =
              jsonResponse.map((item) => MenuItem.fromJson(item)).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load menu items');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print(e);
    }
  }

  void selectCategory(String category) {
    setState(() {
      selectedCategory = category;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: CstmAppBar(),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  CategoryList(
                    categories: categories,
                    selectedCategory: selectedCategory,
                    onCategorySelect: selectCategory,
                  ),
                  MenuGrid(menuItems: menuItems),
                ],
              ),
            ),
    );
  }
}

class CategoryList extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final ValueChanged<String> onCategorySelect;

  const CategoryList({
    Key? key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFE0DDDD),
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (BuildContext context, int index) {
          String category = categories[index];
          return Padding(
            padding: const EdgeInsets.all(10),
            child: GestureDetector(
              onTap: () => onCategorySelect(category),
              child: Container(
                padding: const EdgeInsets.all(10),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selectedCategory == category
                      ? const Color(0xFFFFAD39)
                      : const Color(0xFFC0C0C0),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  category.toUpperCase(),
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class MenuGrid extends StatelessWidget {
  final List<MenuItem> menuItems;

  const MenuGrid({Key? key, required this.menuItems}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
        mainAxisExtent: 250,
      ),
      itemBuilder: (_, index) => MenuCard(menuItem: menuItems[index]),
      itemCount: menuItems.length,
    );
  }
}

class MenuCard extends StatelessWidget {
  final MenuItem menuItem;

  const MenuCard({super.key, required this.menuItem});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.network(
            menuItem.imageUrl,
            height: 100,
          ),
          ListTile(
            title: Text(
              menuItem.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              'Category: ${menuItem.category}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  // Perform some action
                },
                child: const Icon(Icons.add),
              ),
              const Text(
                '4',
                textScaleFactor: 2,
              ),
              TextButton(
                onPressed: () {
                  // Perform some action
                },
                child: const Icon(Icons.remove),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MenuItem {
  final String title;
  final String category;
  final String imageUrl;

  MenuItem({
    required this.title,
    required this.category,
    required this.imageUrl,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      title: json['title'],
      category: json['category'],
      imageUrl: json['imageUrl'],
    );
  }
}
