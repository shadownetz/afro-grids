import 'package:afro_grids/models/service_model.dart';
import 'package:afro_grids/utilities/alerts.dart';
import 'package:afro_grids/utilities/forms/input/service_category_dropdown.dart';
import 'package:flutter/material.dart';

import '../../widgets/button_widget.dart';

class AddServiceForm extends StatefulWidget {
  final Function(ServiceModel service) onComplete;
  const AddServiceForm({
    Key? key,
    required this.onComplete
  }) : super(key: key);

  @override
  State<AddServiceForm> createState() => _AddServiceFormState();
}

class _AddServiceFormState extends State<AddServiceForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _serviceCategoryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _nameController,
              cursorHeight: 20,
              validator: (value){
                if(value != null){
                  if(value.isNotEmpty){
                    return null;
                  }
                }
                return "Enter a valid service name";
              },
              decoration: const InputDecoration(
                labelText: "Service name",
                hintText: "Minter",
              ),
            ),
            const SizedBox(height: 10,),
            ServiceCategoryDropdown(
                onSelected: (categoryId){
                  _serviceCategoryController.text = categoryId;
                }
            ),
            const SizedBox(height: 50,),
            ElevatedButton(
                style: buttonPrimarySmStyle(),
                onPressed: (){
                  if(_formKey.currentState!.validate()){
                    if(_serviceCategoryController.text.isNotEmpty){
                      widget.onComplete(
                        ServiceModel(
                            id: "",
                            name: _nameController.text,
                            serviceCategoryId: _serviceCategoryController.text,
                            createdAt: DateTime.now()
                        )
                      );
                    }else{
                      Alerts(context).showToast("Select a service category");
                    }
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.save, size: 20,),
                    SizedBox(width: 10,),
                    Text("Save", style: TextStyle(fontSize: 20,),)
                  ],
                )
            )
          ],
        )
    );
  }
}
