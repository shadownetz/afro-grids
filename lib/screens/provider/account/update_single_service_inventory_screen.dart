import 'package:afro_grids/utilities/colours.dart';
import 'package:flutter/material.dart';

import '../../../utilities/forms/account/inventory_forms.dart';


class UpdateSingleServiceInventoryScreen extends StatefulWidget {
  const UpdateSingleServiceInventoryScreen({Key? key}) : super(key: key);

  @override
  State<UpdateSingleServiceInventoryScreen> createState() => _UpdateSingleServiceInventoryScreenState();
}

class _UpdateSingleServiceInventoryScreenState extends State<UpdateSingleServiceInventoryScreen> {
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
            UpdateSingleServiceInventoryForm()
          ],
        ),
      )
    );
  }
}
