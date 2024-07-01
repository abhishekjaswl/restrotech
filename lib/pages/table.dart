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
  List tables = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTables();
  }

  Future<void> fetchTables() async {
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
      if (jsonResponse['success']) {
        setState(() {
          tables = jsonResponse['data'];
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

  Future<void> addTable(number, capacity) async {
    context.read<IsLoadingData>().setIsLoading(true);
    var regBody = {
      'number': number,
      'capacity': capacity,
    };
    try {
      regBody.forEach((key, value) {
        if (value == null || value.toString().isEmpty) {
          throw ('Number and Capacity fields cannot be empty.');
        }
      });
      final response = await http.post(
        Uri.parse(table),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer ${Provider.of<CurrentUser>(context, listen: false).token}',
        },
        body: jsonEncode(regBody),
      );
      var jsonResponse = json.decode(response.body);
      if (jsonResponse['success']) {
        fetchTables();
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
      Navigator.pop(context);
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
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: CstmAppBar(),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Table List',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 4,
                      mainAxisSpacing: 4,
                      mainAxisExtent: 230,
                    ),
                    itemCount: tables.length,
                    itemBuilder: (_, index) =>
                        TableCard(tableItem: tables[index]),
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton.small(
        onPressed: () => {
          showModalBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            builder: (BuildContext context) {
              return AddTable(
                callback: addTable,
              );
            },
          )
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class TableCard extends StatelessWidget {
  final tableItem;
  const TableCard({super.key, required this.tableItem});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {
        if (tableItem['status'] == 'available')
          {
            showModalBottomSheet<void>(
              context: context,
              builder: (BuildContext context) {
                return AddGuest(
                  tableItem: tableItem,
                );
              },
            ),
          }
      },
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                'assets/images/table.png',
                height: 110,
              ),
            ),
            Text(tableItem['status'].toString().toUpperCase()),
            ListTile(
              title: Text(
                'Table ${tableItem['number'].toString()}',
                style: const TextStyle(fontSize: 18),
              ),
              subtitle: Text(
                'Capacity: ${tableItem['capacity'].toString()}',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddTable extends StatelessWidget {
  final Function callback;
  AddTable({super.key, required this.callback});

  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _capacityController = TextEditingController();

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
                CstmButton(
                    text: 'Add',
                    onPressed: () => callback(
                          _numberController.text.trim(),
                          _capacityController.text.trim(),
                        )),
              ],
            ),
          ),
        );
      },
    );
  }
}

class AddGuest extends StatefulWidget {
  final tableItem;
  const AddGuest({super.key, required this.tableItem});

  @override
  State<AddGuest> createState() => _AddGuestState();
}

class _AddGuestState extends State<AddGuest> {
  late int guestCount = int.parse(widget.tableItem['capacity']);
  late int guestCapacity = int.parse(widget.tableItem['capacity']);

  Future<void> addGuest() async {
    context.read<IsLoadingData>().setIsLoading(true);
    var regBody = {};
    try {
      final response = await http.post(
        Uri.parse(table),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer ${Provider.of<CurrentUser>(context, listen: false).token}',
        },
        body: jsonEncode(regBody),
      );
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
          Text(
            'Table ${widget.tableItem['number'].toString()}',
            style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
          ),
          Image.asset(
            'assets/images/table.png',
            height: 150,
          ),
          const Text(
            'Guests:',
            style: TextStyle(fontSize: 18),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                onPressed: () {
                  if (guestCount != 1) {
                    setState(() {
                      guestCount--;
                    });
                  }
                },
                child: const Icon(Icons.remove),
              ),
              Text(
                guestCount.toString(),
                textScaleFactor: 2,
              ),
              TextButton(
                onPressed: () {
                  if (guestCount < guestCapacity) {
                    setState(() {
                      guestCount++;
                    });
                  }
                },
                child: const Icon(Icons.add),
              ),
            ],
          ),
          CstmButton(text: 'Select and continue', onPressed: () => addGuest()),
        ],
      ),
    );
  }
}
