import 'package:flutter/material.dart';
import '../../data/mock_grocery_repository.dart';
import '../../models/grocery.dart';
import 'grocery_form.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  String _searchQuery = '';

  void onCreate() async {
    Grocery? newGrocery = await Navigator.push<Grocery>(
      context,
      MaterialPageRoute(builder: (context) => const GroceryForm()),
    );

    if (newGrocery != null) {
      setState(() {
        dummyGroceryItems.add(newGrocery);
      });
    }
  }

  List<Grocery> get filteredGroceries {
    return dummyGroceryItems
        .where((g) =>
            g.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Your Groceries'),
          actions: [
            IconButton(onPressed: onCreate, icon: const Icon(Icons.add)),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.local_grocery_store), text: 'Groceries'),
              Tab(icon: Icon(Icons.search), text: 'Search'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ListView.builder(
              itemCount: dummyGroceryItems.length,
              itemBuilder: (context, index) {
                return GroceryTile(grocery: dummyGroceryItems[index]);
              },
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: 'Search grocery',
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredGroceries.length,
                    itemBuilder: (context, index) {
                      return GroceryTile(
                        grocery: filteredGroceries[index],
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class GroceryTile extends StatelessWidget {
  const GroceryTile({super.key, required this.grocery});

  final Grocery grocery;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 15,
        height: 15,
        color: grocery.category.color,
      ),
      title: Text(grocery.name),
      trailing: Text(grocery.quantity.toString()),
    );
  }
}
