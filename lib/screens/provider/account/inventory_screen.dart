import 'package:afro_grids/screens/provider/account/add_inventory_screen.dart';
import 'package:afro_grids/utilities/colours.dart';
import 'package:afro_grids/utilities/forms/account_forms.dart';
import 'package:afro_grids/utilities/widgets/widgets.dart';
import 'package:flutter/material.dart';

import '../../../models/inventory_model.dart';
import '../../../utilities/class_constants.dart';
import '../../../utilities/widgets/provider_widgets.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({Key? key}) : super(key: key);

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colours.tertiary,
      appBar: AppBar(
        title: const Text("Inventory"),
      ),
      body: Container(
        width: deviceWidth,
        height: deviceHeight,
        padding: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 0),
        // margin: EdgeInsets.only(bottom: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text("Category", style: TextStyle(fontSize: 17),),
                  const UpdateServiceCategoryForm(),
                  Text("Service Type", style: TextStyle(fontSize: 17),),
                  const UpdateServiceTypeForm()
                ],
              ),
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("showing 26 of 26 items"),
                  PopupMenuButton(
                      position: PopupMenuPosition.under,
                      icon: const Icon(Icons.filter_list),
                      onSelected: (String item){
                        print(item);
                      },
                      itemBuilder: (context){
                        return [
                          const PopupMenuItem<String>(
                              enabled: false,
                              child: Text("Date")
                          ),
                          const PopupMenuItem<String>(
                              value: "date_asc",
                              child: Text("ascending")
                          ),
                          const PopupMenuItem<String>(
                              value: "date_desc",
                              child: Text("descending")
                          ),
                          const PopupMenuItem<String>(
                              enabled: false,
                              child: Text("Price")
                          ),
                          const PopupMenuItem<String>(
                              value: "price_asc",
                              child: Text("ascending")
                          ),
                          const PopupMenuItem<String>(
                              value: "price_desc",
                              child: Text("descending")
                          )
                        ];
                      }
                  )
                ],
              ),
              InventoryView(
                items:  [
                  InventoryModel(id: "", createdBy: "", createdAt: DateTime.now(), name: "Strawberries", price: 5000, currency: Currency.ngn, description: "Sizes XL&M", images: ["https://picsum.photos/id/1080/200/300","https://picsum.photos/id/119/200/300", "https://picsum.photos/id/133/200/300"], visible: true),
                  InventoryModel(id: "", createdBy: "", createdAt: DateTime.now(), name: "Apple MacBook", price: 150000, currency: Currency.ngn, description: "Refurbished", images: ["https://picsum.photos/id/119/200/300"], visible: true),
                  InventoryModel(id: "", createdBy: "", createdAt: DateTime.now(), name: "Cars", price: 250000, currency: Currency.ngn, description: "Working condition", images: ["https://picsum.photos/id/133/200/300"], visible: true),
                  InventoryModel(id: "", createdBy: "", createdAt: DateTime.now(), name: "Skate Board", price: 3500, currency: Currency.ngn, description: "Antique (the best)", images: ["https://picsum.photos/id/157/200/300"], visible: true),
                  InventoryModel(id: "", createdBy: "", createdAt: DateTime.now(), name: "Strawberries", price: 5000, currency: Currency.ngn, description: "Sizes XL&M", images: ["https://picsum.photos/id/1080/200/300"], visible: true),
                  InventoryModel(id: "", createdBy: "", createdAt: DateTime.now(), name: "Apple MacBook", price: 150000, currency: Currency.ngn, description: "Refurbished", images: ["https://picsum.photos/id/119/200/300"], visible: true),
                  InventoryModel(id: "", createdBy: "", createdAt: DateTime.now(), name: "Cars", price: 250000, currency: Currency.ngn, description: "Working condition", images: ["https://picsum.photos/id/133/200/300"], visible: true),
                  InventoryModel(id: "", createdBy: "", createdAt: DateTime.now(), name: "Skate Board", price: 3500, currency: Currency.ngn, description: "Antique (the best)", images: ["https://picsum.photos/id/157/200/300"], visible: true),
                ],
                onClick: (item){
                  // showModalBottomSheet(
                  //     context: context,
                  //     isScrollControlled: true,
                  //     backgroundColor: Colors.transparent,
                  //     builder: (context)=>ViewItemScreen(inventory: item)
                  // );
                },
              )
            ],
          ),
        ),
      ),
      floatingActionButton: ElevatedButton(
        onPressed: ()=>Navigator.of(context).push(createRoute(const AddInventoryScreen())),
        style: ElevatedButton.styleFrom(
            elevation: 5,
            minimumSize: Size(50, 50),
            primary: Colours.secondary,
            onPrimary: Colours.primary,
            shape:CircleBorder()
        ),
        child: Icon(Icons.add),
      ),
    );
  }
}
