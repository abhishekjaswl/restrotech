import 'package:avatars/avatars.dart';
import 'package:flutter/material.dart';

import '../widgets/cstm_appbar.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: CstmAppBar(),
      ),
      body: ListView.builder(
        shrinkWrap: true,
        itemBuilder: (_, index) => const OrderCard(),
        itemCount: 5,
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  const OrderCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Text('Order #69420'),
            subtitle: const Text(
              '05 Feb 2023, 08:28 PM',
              style: TextStyle(
                color: Colors.black38,
              ),
            ),
            trailing: Avatar(
              sources: [
                if (true)
                  NetworkSource(
                      'https://sm.ign.com/ign_nordic/cover/a/avatar-gen/avatar-generations_prsz.jpg')
              ],
              shape: AvatarShape.circle(25),
              name: 'user name',
            ),
          ),
          ListTile(
            title: const Text('Vegetable Mixups'),
            subtitle: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Vegetable Fritters with Egg',
                  style: TextStyle(color: Colors.black38, fontSize: 15),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '520',
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                    Text(
                      'Qty: 1',
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                  ],
                )
              ],
            ),
            leading: Avatar(
              sources: [
                if (true)
                  NetworkSource(
                      'https://www.nrn.com/sites/nrn.com/files/styles/article_featured_standard/public/Chick-fil-A%20Pizza%20Pie.jpg?itok=9pU42iU0')
              ],
              border: Border.all(
                color: Theme.of(context).colorScheme.primary,
                width: 1,
              ),
              shape: AvatarShape.circle(50),
              name: 'food name',
            ),
          ),
          const Divider(
            indent: 20,
            endIndent: 20,
          ),
          ButtonBar(
            alignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'X2 Items',
                style: TextStyle(color: Colors.black38, fontSize: 15),
              ),
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.red, width: 2.0),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.red),
                      onPressed: () {
                        // Perform some action
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.green, width: 2.0),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.check,
                        color: Colors.green,
                      ),
                      onPressed: () {
                        // Perform some action
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
