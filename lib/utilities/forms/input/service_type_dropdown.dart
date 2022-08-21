import 'package:flutter/material.dart';

import '../../class_constants.dart';
import '../../colours.dart';

class ServiceTypeDropdown extends StatefulWidget {
  final String? initialValue;
  final void Function(String value)? onChanged;
  const ServiceTypeDropdown({Key? key, this.onChanged, this.initialValue}) : super(key: key);

  @override
  State<ServiceTypeDropdown> createState() => _ServiceTypeDropdownState();
}

class _ServiceTypeDropdownState extends State<ServiceTypeDropdown> {
  String serviceType = ServiceType.multiple;

  @override
  void initState() {
    if(widget.initialValue != null){
      serviceType = widget.initialValue!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
        dropdownColor: Colours.tertiary,
        value: serviceType,
        isExpanded: true,
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