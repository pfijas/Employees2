import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Models/Dinning.dart';
import '../Models/Itemname.dart';
import '../Models/Provider/ReorderUsingProvider.dart';

class ItemsTab extends StatefulWidget {
  final int tabIndex;
  @override
  final List<Items>? items;
  final int? selectedCategoryId;
  final void Function(SelectedItems) onItemAdded;
  final void Function(double) removeItemCallback;


  const ItemsTab({super.key, 
    required this.tabIndex,
    this.items,
    this.selectedCategoryId,
    required this.onItemAdded,
    required this.removeItemCallback,
  });

  @override
  _ItemsTabState createState() => _ItemsTabState();
}

class _ItemsTabState extends State<ItemsTab> {
  int _sinoCounter = 0;
  List<SelectedItems> selectedItemsList = [];

  @override
  Widget build(BuildContext context) {
    final selectedItemsProvider = Provider.of<SelectedItemsProvider>(context);

    if (widget.tabIndex == 2) {
      List<Items> selectedCatItems = (widget.items ?? [])
          .where((item) => item.catId == widget.selectedCategoryId)
          .toList();

      return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          crossAxisSpacing: 3.0,
          mainAxisSpacing: 3.0,
        ),
        itemCount: selectedCatItems.length,
        itemBuilder: (context, index) {
          return InkWell(
            // Inside the _ItemsTabState class
            onTap: () {
              setState(() {
                String itemName = selectedCatItems[index].name ?? '';
                double itemRate = selectedCatItems[index].sRate ?? 0.0;
                String Printer =selectedCatItems[index].printer??'';
                num itemId = selectedCatItems[index].itemId ?? 0.0;
                // bool itemExists =
                //     selectedItemsList.any((item) => item.name == itemName);
                // if (itemExists) {
                //   SelectedItems existingItem = selectedItemsProvider
                //       .selectedItemsList
                //       .firstWhere((item) => item.itemId == itemId);
                //   existingItem.quantity += 1;
                //   existingItem.itemtotal =
                //       existingItem.quantity * existingItem.sRate;
                // } else {
                  SelectedItems selectedItems = SelectedItems(
                    name: itemName,
                    sRate: itemRate,
                    itemId: itemId.toInt(),
                    quantity: 1,
                    itemtotal: 1 * itemRate,
                      extraNote: '',
                      SINO: '${++_sinoCounter}',
                     printer:Printer
                  );
                  selectedItemsProvider.addItem(selectedItems);
                  widget.onItemAdded(selectedItems);
                  print("fffffffffffffffffffff$selectedItems");
              });
            },
            child: Card(
              elevation: 3,
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Column(
                      children: [
                        Text(
                          selectedCatItems[index].name ?? '',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    // Add more widgets here for additional details or actions
                  ],
                ),
              ),
            ),
          );
        },
      );
    } else {
      return const CircularProgressIndicator();
    }
  }
}



