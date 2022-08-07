import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:afro_grids/utilities/widgets/button_widget.dart';
import 'package:image_picker/image_picker.dart';

import 'account_forms.dart';

// Creation Form
class NewMultiServiceInventoryForm extends StatefulWidget {
  const NewMultiServiceInventoryForm({Key? key}) : super(key: key);

  @override
  State<NewMultiServiceInventoryForm> createState() => _NewMultiServiceInventoryFormState();
}

class _NewMultiServiceInventoryFormState extends State<NewMultiServiceInventoryForm> {
  CarouselController carouselController = CarouselController();
  final _formKey = GlobalKey<FormState>();
  var itemNameController = TextEditingController();
  var itemPriceController = TextEditingController();
  var itemDescriptionController = TextEditingController();
  List<XFile>? _itemImages = [];



  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;

    return Container(
      height: deviceHeight,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ItemImageSelector(
                onUpdated: (imageList){
                  _itemImages = imageList;
                },
              ),
            ),
            TextFormField(
              controller: itemNameController,
              cursorHeight: 20,
              decoration: const InputDecoration(
                  labelText: "Item Name",
                  hintText: "enter item name"
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a valid item name';
                }
                return null;
              },
            ),
            TextFormField(
              controller: itemPriceController,
              cursorHeight: 20,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  labelText: "Item Price",
                  hintText: "0.00",
                  prefix: Text("₦")
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a valid price';
                }
                return null;
              },
            ),
            TextFormField(
              controller: itemDescriptionController,
              cursorHeight: 20,
              maxLines: 5,
              maxLength: 500,
              decoration: const InputDecoration(
                labelText: "Item Description",
                hintText: "e.g available in sizes XL,M&L",
              ),
            ),
            const SizedBox(height: 50,),
            ElevatedButton(
                style: buttonPrimaryMdStyle(),
                onPressed: (){
                  if(_formKey.currentState!.validate()){
                    //
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.save, size: 20,),
                    SizedBox(width: 10,),
                    Text("Save item", style: TextStyle(fontSize: 20,),)
                  ],
                )
            )
          ],
        ),
      ),
    );
  }
}


// Update Form
class UpdateMultiServiceInventoryForm extends StatefulWidget {
  const UpdateMultiServiceInventoryForm({Key? key}) : super(key: key);

  @override
  State<UpdateMultiServiceInventoryForm> createState() => _UpdateMultiServiceInventoryFormState();
}

class _UpdateMultiServiceInventoryFormState extends State<UpdateMultiServiceInventoryForm> {
  CarouselController carouselController = CarouselController();
  final _formKey = GlobalKey<FormState>();
  var itemNameController = TextEditingController();
  var itemPriceController = TextEditingController();
  var itemDescriptionController = TextEditingController();
  List<XFile>? _itemImages = [];



  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;

    return Container(
      height: deviceHeight,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ItemImageSelector(
                onUpdated: (imageList){
                  _itemImages = imageList;
                },
              ),
            ),
            TextFormField(
              controller: itemNameController,
              cursorHeight: 20,
              decoration: const InputDecoration(
                  labelText: "Item Name",
                  hintText: "enter item name"
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a valid item name';
                }
                return null;
              },
            ),
            TextFormField(
              controller: itemPriceController,
              cursorHeight: 20,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  labelText: "Item Price",
                  hintText: "0.00",
                  prefix: Text("₦")
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a valid price';
                }
                return null;
              },
            ),
            TextFormField(
              controller: itemDescriptionController,
              cursorHeight: 20,
              maxLines: 5,
              maxLength: 500,
              decoration: const InputDecoration(
                labelText: "Item Description",
                hintText: "e.g available in sizes XL,M&L",
              ),
            ),
            const SizedBox(height: 50,),
            ElevatedButton(
                style: buttonPrimaryMdStyle(),
                onPressed: (){
                  if(_formKey.currentState!.validate()){
                    //
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.save, size: 20,),
                    SizedBox(width: 10,),
                    Text("Save changes", style: TextStyle(fontSize: 20,),)
                  ],
                )
            )
          ],
        ),
      ),
    );
  }
}

class UpdateSingleServiceInventoryForm extends StatefulWidget {
  const UpdateSingleServiceInventoryForm({Key? key}) : super(key: key);

  @override
  State<UpdateSingleServiceInventoryForm> createState() => _UpdateSingleServiceInventoryFormState();
}

class _UpdateSingleServiceInventoryFormState extends State<UpdateSingleServiceInventoryForm> {
  final _formKey = GlobalKey<FormState>();
  var itemDescriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;

    return Container(
      height: deviceHeight,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: itemDescriptionController,
              cursorHeight: 20,
              maxLines: 20,
              maxLength: 2000,
              decoration: const InputDecoration(
                labelText: "Item Description",
                hintText: "e.g available in sizes XL,M&L",
              ),
            ),
            const SizedBox(height: 50,),
            ElevatedButton(
                style: buttonPrimaryMdStyle(),
                onPressed: (){
                  if(_formKey.currentState!.validate()){
                    //
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.save, size: 20,),
                    SizedBox(width: 10,),
                    Text("Save changes", style: TextStyle(fontSize: 20,),)
                  ],
                )
            )
          ],
        ),
      ),
    );
  }
}
