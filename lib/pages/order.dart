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
            title: const Text('Pizza'),
            subtitle: const Text('Category: Mamma Mia'),
            trailing: Image.network(
              'https://www.nrn.com/sites/nrn.com/files/styles/article_featured_standard/public/Chick-fil-A%20Pizza%20Pie.jpg?itok=9pU42iU0',
              height: 100,
            ),
          ),
          Image.network(
            'https://www.nrn.com/sites/nrn.com/files/styles/article_featured_standard/public/Chick-fil-A%20Pizza%20Pie.jpg?itok=9pU42iU0',
            height: 100,
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
