import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_app/utils/config/config.dart';
import 'package:mobile_app/widgets/cstm_button.dart';
import 'package:mobile_app/widgets/cstm_textfield.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import '../providers/currentuser_provider.dart';
import '../providers/loading.dart';
import '../widgets/cstm_appbar.dart';
import '../widgets/cstm_snackbar.dart';

class TablePage extends StatefulWidget {
  const TablePage({super.key});

  @override
  State<TablePage> createState() => _TablePageState();
}

class _TablePageState extends State<TablePage> {
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
        Uri.parse(table),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer ${Provider.of<CurrentUser>(context, listen: false).token}',
        },
      );
      var jsonResponse = json.decode(response.body);
      print(jsonResponse);
      if (jsonResponse['success']) {
        setState(() {
          menuItems = jsonResponse['data'];
        });
      } else {
        _showErrorSnackbar(jsonResponse['message']);
      }
    } catch (e) {
      _showErrorSnackbar(e.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      CstmSnackBar(
        text: message,
        type: 'error',
      ),
    );
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
              child: GridView.builder(
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
              ),
            ),
      floatingActionButton: FloatingActionButton.small(
        onPressed: () => {
          showModalBottomSheet<void>(
            context: context,
            builder: (BuildContext context) {
              return const AddMenuItem();
            },
          )
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class MenuCard extends StatelessWidget {
  final menuItem;
  const MenuCard({super.key, required this.menuItem});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/images/table.png',
            height: 100,
          ),
          ListTile(
            title: Text(
              menuItem['number'].toString(),
            ),
            subtitle: Text(
              'Capacity: ${menuItem['capacity'].toString()}',
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

class AddMenuItem extends StatefulWidget {
  const AddMenuItem({super.key});

  @override
  State<AddMenuItem> createState() => _AddMenuItemState();
}

class _AddMenuItemState extends State<AddMenuItem> {
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _capacityController = TextEditingController();

  Future<void> addTable() async {
    context.read<IsLoadingData>().setIsLoading(true);
    var regBody = {
      'number': _numberController.text.trim(),
      'capacity': _capacityController.text.trim(),
    };
    try {
      final response = await http.post(Uri.parse(table),
          headers: {
            'Content-Type': 'application/json',
            'Authorization':
                'Bearer ${Provider.of<CurrentUser>(context, listen: false).token}',
          },
          body: jsonEncode(regBody));
      var jsonResponse = json.decode(response.body);
      if (jsonResponse['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          CstmSnackBar(
            text: jsonResponse['message'],
            type: 'success',
          ),
        );
      } else {
        _showErrorSnackbar(jsonResponse['message']);
      }
    } catch (e) {
      _showErrorSnackbar(e.toString());
    } finally {
      context.read<IsLoadingData>().setIsLoading(false);
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      CstmSnackBar(
        text: message,
        type: 'error',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Add Table',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          CstmTextField(
            text: 'Number',
            inputType: TextInputType.number,
            mainController: _numberController,
          ),
          CstmTextField(
            text: 'Capacity',
            inputType: TextInputType.number,
            mainController: _capacityController,
          ),
          CstmButton(text: 'Add', onPressed: () => addTable())
        ],
      ),
    );
  }
}
