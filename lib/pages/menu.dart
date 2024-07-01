import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:mobile_app/utils/config/config.dart';
import 'package:mobile_app/widgets/cstm_button.dart';
import 'package:mobile_app/widgets/cstm_textfield.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import '../providers/currentuser_provider.dart';
import '../providers/loading.dart';
import '../widgets/cstm_appbar.dart';
import '../widgets/cstm_snackbar.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  List<String> categories = [
    'All',
    'Starter',
    'Main Course',
    'Drinks',
    'Dessert'
  ];
  String selectedCategory = 'All';
  List menuItems = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchMenuItems();
  }

  Future<void> fetchMenuItems() async {
    try {
      final response = await http.get(
        Uri.parse(menu),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer ${Provider.of<CurrentUser>(context, listen: false).token}',
        },
      );
      var jsonResponse = json.decode(response.body);
      if (jsonResponse['success']) {
        setState(() {
          menuItems = jsonResponse['data'];
        });
      } else {
        var jsonResponse = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          CstmSnackBar(
            text: jsonResponse['message'],
            type: 'error',
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        CstmSnackBar(
          text: e.toString(),
          type: 'error',
        ),
      );
    } finally {
      isLoading = false;
    }
  }

  Future<void> createMenuWithPhoto(
    String name,
    String description,
    String price,
    String category,
    String estimatedTime,
    XFile photo,
  ) async {
    context.read<IsLoadingData>().setIsLoading(true);
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          'Bearer ${Provider.of<CurrentUser>(context, listen: false).token}',
    };

    try {
      final request = http.MultipartRequest('POST', Uri.parse(menu))
        ..headers.addAll(headers)
        ..fields['name'] = name
        ..fields['description'] = description
        ..fields['price'] = price.toString()
        ..fields['category'] = category
        ..fields['estimatedTime'] = estimatedTime
        ..files.add(await http.MultipartFile.fromPath('file', photo.path));

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await http.Response.fromStream(response);
        final data = json.decode(responseData.body);
        if (data['success']) {
          fetchMenuItems();
          ScaffoldMessenger.of(context).showSnackBar(
            CstmSnackBar(
              text: data['message'],
              type: 'success',
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            CstmSnackBar(
              text: data['message'],
              type: 'error',
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          CstmSnackBar(
            text: response.reasonPhrase!,
            type: 'error',
          ),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        CstmSnackBar(
          text: error.toString(),
          type: 'error',
        ),
      );
    } finally {
      Navigator.pop(context);
      context.read<IsLoadingData>().setIsLoading(false);
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
      floatingActionButton: FloatingActionButton.small(
        onPressed: () => {
          showModalBottomSheet<void>(
            isScrollControlled: true,
            context: context,
            builder: (BuildContext context) {
              return AddMenuItem(
                callback: createMenuWithPhoto,
              );
            },
          )
        },
        child: const Icon(Icons.add),
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
  final List menuItems;

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
        mainAxisExtent: 200,
      ),
      itemBuilder: (_, index) => MenuCard(menuItem: menuItems[index]),
      itemCount: menuItems.length,
    );
  }
}

class MenuCard extends StatelessWidget {
  final menuItem;

  const MenuCard({super.key, required this.menuItem});

  String getImageUrl() {
    String imageUrl = menuItem['photo'];
    int index = imageUrl.indexOf("localhost:8000/") + "localhost:8000/".length;
    String fileName = imageUrl.substring(index);
    return url + fileName;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.network(
            getImageUrl(),
            height: 100,
            fit: BoxFit.fitWidth,
          ),
          ListTile(
            title: Text(
              menuItem['name'],
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              'Category: ${menuItem['category']}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // ButtonBar(
          //   alignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     TextButton(
          //       onPressed: () {
          //         // Perform some action
          //       },
          //       child: const Icon(Icons.add),
          //     ),
          //     const Text(
          //       '4',
          //       textScaleFactor: 2,
          //     ),
          //     TextButton(
          //       onPressed: () {
          //         // Perform some action
          //       },
          //       child: const Icon(Icons.remove),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }
}

class AddMenuItem extends StatefulWidget {
  final Function callback;
  const AddMenuItem({super.key, required this.callback});

  @override
  State<AddMenuItem> createState() => _AddMenuItemState();
}

class _AddMenuItemState extends State<AddMenuItem> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  XFile? _photo;

  Future<XFile?> pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    return image;
  }

  void _pickImage() async {
    final image = await pickImage();
    setState(() {
      _photo = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      builder: (context, scrollController) {
        return SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                const Text(
                  'Add Menu Item',
                  style: TextStyle(fontSize: 25),
                ),
                ElevatedButton(
                  onPressed: _pickImage,
                  child: const Text('Pick Image'),
                ),
                if (_photo != null) Image.file(File(_photo!.path)),
                CstmTextField(
                  text: 'Name',
                  inputType: TextInputType.text,
                  mainController: _nameController,
                ),
                CstmTextField(
                  text: 'Description',
                  inputType: TextInputType.text,
                  mainController: _descriptionController,
                ),
                CstmTextField(
                  text: 'Price',
                  inputType: TextInputType.number,
                  mainController: _priceController,
                ),
                CstmTextField(
                  text: 'Category',
                  inputType: TextInputType.text,
                  mainController: _categoryController,
                ),
                CstmTextField(
                  text: 'Estimate Time',
                  inputType: TextInputType.number,
                  mainController: _timeController,
                ),
                CstmButton(
                  text: 'Add',
                  onPressed: () => {
                    if (_nameController.text.trim().isEmpty ||
                        _descriptionController.text.trim().isEmpty ||
                        _priceController.text.trim().isEmpty ||
                        _categoryController.text.trim().isEmpty ||
                        _timeController.text.trim().isEmpty ||
                        _photo == null)
                      {}
                    else
                      {
                        widget.callback(
                          _nameController.text.trim(),
                          _descriptionController.text.trim(),
                          _priceController.text.trim(),
                          _categoryController.text.trim(),
                          _timeController.text.trim(),
                          _photo,
                        ),
                      }
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
