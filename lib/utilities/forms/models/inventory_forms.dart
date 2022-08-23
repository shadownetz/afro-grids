import 'package:afro_grids/models/inventory_model.dart';
import 'package:afro_grids/utilities/alerts.dart';
import 'package:afro_grids/utilities/currency.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:afro_grids/utilities/widgets/button_widget.dart';
import 'package:image_picker/image_picker.dart';

import '../../../main.dart';
import '../../widgets/selectors/item_image_selector.dart';

// Creation Form
class NewMultiServiceInventoryForm extends StatefulWidget {
  final void Function(InventoryModel inventory, List<XFile>? images) onComplete;
  const NewMultiServiceInventoryForm({Key? key, required this.onComplete}) : super(key: key);

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
                onUpdated: (imageList, [modOldURLS]){
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
              decoration: InputDecoration(
                  labelText: "Item Price",
                  hintText: "0.00",
                  prefix: Text(CurrencyUtil().currencySymbol(localStorage.user!.currency))
              ),
              validator: (value) {
                if (value == null || value.isEmpty || double.tryParse(value) == null) {
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
                    if(_itemImages == null){
                      Alerts(context).showToast("You need to upload one or more item images");
                    }
                    else if(_itemImages!.isEmpty){
                      Alerts(context).showToast("You need to upload one or more item images");
                    }
                    else {
                      var inventory = InventoryModel(
                          id: "",
                          createdBy: localStorage.user!.id,
                          createdAt: DateTime.now(),
                          name: itemNameController.text,
                          price: double.parse(itemPriceController.text),
                          currency: localStorage.user!.currency,
                          description: itemDescriptionController.text,
                          images: [],
                          visible: true
                      );
                      widget.onComplete(inventory, _itemImages);
                    }

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
  final InventoryModel inventory;
  final void Function(InventoryModel inventory, List<XFile>? images) onComplete;
  const UpdateMultiServiceInventoryForm({Key? key,required this.inventory, required this.onComplete}) : super(key: key);

  @override
  State<UpdateMultiServiceInventoryForm> createState() => _UpdateMultiServiceInventoryFormState();
}

class _UpdateMultiServiceInventoryFormState extends State<UpdateMultiServiceInventoryForm> {
  CarouselController carouselController = CarouselController();
  final _formKey = GlobalKey<FormState>();
  late TextEditingController itemNameController;
  late TextEditingController itemPriceController;
  late TextEditingController itemDescriptionController;
  List<XFile>? _itemImages = [];

  @override
  void initState() {
    itemNameController = TextEditingController(text: widget.inventory.name);
    itemPriceController = TextEditingController(text: widget.inventory.price.toString());
    itemDescriptionController = TextEditingController(text: widget.inventory.description);
    super.initState();
  }



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
                initialURLS: widget.inventory.images,
                onUpdated: (imageList, [modOldURLS]){
                  _itemImages = imageList;
                  if(modOldURLS != null){
                    widget.inventory.images = modOldURLS;
                  }
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
              decoration: InputDecoration(
                  labelText: "Item Price",
                  hintText: "0.00",
                  prefix: Text(CurrencyUtil().currencySymbol(localStorage.user!.currency))
              ),
              validator: (value) {
                if (value == null || value.isEmpty || double.tryParse(value) == null) {
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
                    if(_itemImages == null && widget.inventory.images.isEmpty){
                      Alerts(context).showToast("You need to upload one or more item images");
                    }
                    else {
                      widget.inventory.name = itemNameController.text;
                      widget.inventory.description = itemDescriptionController.text;
                      widget.inventory.price = double.parse(itemPriceController.text);
                      widget.onComplete(widget.inventory, _itemImages);
                    }
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.save, size: 20,),
                    SizedBox(width: 10,),
                    Text("Update item", style: TextStyle(fontSize: 20,),)
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
  final InventoryModel? inventory;
  final void Function(InventoryModel inventory) onComplete;


  const UpdateSingleServiceInventoryForm({Key? key, this.inventory, required this.onComplete}) : super(key: key);

  @override
  State<UpdateSingleServiceInventoryForm> createState() => _UpdateSingleServiceInventoryFormState();
}

class _UpdateSingleServiceInventoryFormState extends State<UpdateSingleServiceInventoryForm> {
  final _formKey = GlobalKey<FormState>();
  var itemDescriptionController = TextEditingController();

  @override
  void initState() {
    if(widget.inventory != null){
      itemDescriptionController.text = widget.inventory!.description;
    }
    super.initState();
  }

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
              maxLines: 10,
              maxLength: 1000,
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
                    InventoryModel inventory;
                    if(widget.inventory != null){
                      inventory = InventoryModel.copyWith(widget.inventory!);
                      inventory.description = itemDescriptionController.text;
                    }else{
                      inventory = InventoryModel(
                          id: "",
                          createdBy: localStorage.user!.id,
                          createdAt: DateTime.now(),
                          name: "",
                          price: 0,
                          currency: localStorage.user!.currency,
                          description: itemDescriptionController.text,
                          images: [],
                          visible: true
                      );
                    }
                    widget.onComplete(inventory);
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
