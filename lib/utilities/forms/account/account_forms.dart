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
  final void Function(String value)? onChanged;
  const UpdateServiceTypeForm({Key? key, this.onChanged}) : super(key: key);

  @override
  State<UpdateServiceTypeForm> createState() => _UpdateServiceTypeFormState();
}

class _UpdateServiceTypeFormState extends State<UpdateServiceTypeForm> {
  String serviceType = ServiceType.multiple;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
        value: serviceType,
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
        onChanged: (value){
          setState((){
            serviceType = value!;
          });
          if(widget.onChanged != null){
            widget.onChanged!(value!);
          }
        }
    );
  }
}
