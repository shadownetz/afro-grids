import 'package:afro_grids/utilities/colours.dart';
import 'package:flutter/material.dart';

import '../../../utilities/forms/account/inventory_forms.dart';


class UpdateMultipleServiceInventoryScreen extends StatefulWidget {
  const UpdateMultipleServiceInventoryScreen({Key? key}) : super(key: key);

  @override
  State<UpdateMultipleServiceInventoryScreen> createState() => _UpdateMultipleServiceInventoryScreenState();
}

class _UpdateMultipleServiceInventoryScreenState extends State<UpdateMultipleServiceInventoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colours.tertiary,
      appBar: AppBar(
        title: const Text("Update Inventory"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: const [
            UpdateMultiServiceInventoryForm()
          ],
        ),
      )
    );
  }
}
