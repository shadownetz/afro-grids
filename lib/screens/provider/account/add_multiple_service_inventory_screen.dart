import 'package:afro_grids/utilities/colours.dart';
import 'package:flutter/material.dart';

import '../../../utilities/forms/account/inventory_forms.dart';


class AddMultipleServiceInventoryScreen extends StatefulWidget {
  const AddMultipleServiceInventoryScreen({Key? key}) : super(key: key);

  @override
  State<AddMultipleServiceInventoryScreen> createState() => _AddMultipleServiceInventoryScreenState();
}

class _AddMultipleServiceInventoryScreenState extends State<AddMultipleServiceInventoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colours.tertiary,
      appBar: AppBar(
        title: const Text("New Inventory"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: const [
            NewMultiServiceInventoryForm()
          ],
        ),
      )
    );
  }
}
