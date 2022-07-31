import 'package:afro_grids/utilities/class_constants.dart';
import 'package:flutter/material.dart';

class UpdateServiceCategoryForm extends StatefulWidget {
  const UpdateServiceCategoryForm({Key? key}) : super(key: key);

  @override
  State<UpdateServiceCategoryForm> createState() => _UpdateServiceCategoryFormState();
}

class _UpdateServiceCategoryFormState extends State<UpdateServiceCategoryForm> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
        value: "fashion",
        items: const [
          DropdownMenuItem(
              value: 'fashion',
              child: Text("fashion")
          ),
          DropdownMenuItem(
              value: 'finance',
              child: Text("finance")
          )
        ],
        onChanged: (value){}
    );
  }
}

class UpdateServiceTypeForm extends StatefulWidget {
  const UpdateServiceTypeForm({Key? key}) : super(key: key);

  @override
  State<UpdateServiceTypeForm> createState() => _UpdateServiceTypeFormState();
}

class _UpdateServiceTypeFormState extends State<UpdateServiceTypeForm> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
        value: ServiceType.multiple,
        items: [
          DropdownMenuItem(
              value: ServiceType.multiple,
              child: Text(ServiceType.multiple.toLowerCase())
          ),
          DropdownMenuItem(
              value: ServiceType.single,
              child: Text(ServiceType.single.toLowerCase())
          )
        ],
        onChanged: (value){}
    );
  }
}
