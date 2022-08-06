import 'package:afro_grids/utilities/colours.dart';
import 'package:afro_grids/utilities/forms/account_forms.dart';
import 'package:flutter/material.dart';


class AddInventoryScreen extends StatefulWidget {
  const AddInventoryScreen({Key? key}) : super(key: key);

  @override
  State<AddInventoryScreen> createState() => _AddInventoryScreenState();
}

class _AddInventoryScreenState extends State<AddInventoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colours.tertiary,
      appBar: AppBar(
        title: const Text("New Inventory"),
      ),
      body: Column(
        children: const [
          NewInventoryForm()
        ],
      ),
    );
  }
}
