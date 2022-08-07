import 'package:afro_grids/screens/provider/account/add_multiple_service_inventory_screen.dart';
import 'package:afro_grids/screens/provider/account/update_single_service_inventory_screen.dart';
import 'package:afro_grids/screens/provider/account/view_multiple_service_inventory_screen.dart';
import 'package:afro_grids/utilities/colours.dart';
import 'package:afro_grids/utilities/forms/account/account_forms.dart';
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
  String viewMode = ServiceType.multiple;

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
        padding: const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 0),
        // margin: EdgeInsets.only(bottom: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Category", style: TextStyle(fontSize: 17),),
                  const UpdateServiceCategoryForm(),
                  const Text("Service Type", style: TextStyle(fontSize: 17),),
                  UpdateServiceTypeForm(
                    onChanged: (value){
                      setState((){
                        viewMode = value;
                      });
                    },
                  )
                ],
              ),
              const SizedBox(height: 20,),
              AnimatedCrossFade(
                  firstChild: multipleServiceItemsUI(),
                  secondChild: singleServiceItemUI(),
                  crossFadeState: viewMode==ServiceType.multiple?CrossFadeState.showFirst: CrossFadeState.showSecond,
                  duration: const Duration(milliseconds: 500)
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: AnimatedCrossFade(
          firstChild: floatingAction1(),
          secondChild: floatingAction2(),
          crossFadeState: viewMode==ServiceType.multiple?CrossFadeState.showFirst: CrossFadeState.showSecond,
          duration: const Duration(milliseconds: 500)
      ),
    );
  }

  Widget floatingAction1(){
    return ElevatedButton(
      onPressed: ()=>Navigator.of(context).push(createRoute(const AddMultipleServiceInventoryScreen())),
      style: ElevatedButton.styleFrom(
          elevation: 2,
          minimumSize: const Size(50, 50),
          primary: Colours.secondary,
          onPrimary: Colours.primary,
          shape:const CircleBorder()
      ),
      child: const Icon(Icons.add),
    );
  }
  Widget floatingAction2(){
    return ElevatedButton(
      onPressed: ()=>Navigator.of(context).push(createRoute(const UpdateSingleServiceInventoryScreen())),
      style: ElevatedButton.styleFrom(
          elevation: 2,
          minimumSize: const Size(50, 50),
          primary: Colours.secondary,
          onPrimary: Colours.primary,
          shape:const CircleBorder()
      ),
      child: const Icon(Icons.edit_outlined),
    );
  }
  Widget multipleServiceItemsUI(){
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("showing 26 of 26 items"),
            PopupMenuButton(
                position: PopupMenuPosition.under,
                icon: const Icon(Icons.filter_list),
                onSelected: (String item){
                  // print(item);
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
            showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context)=>ViewMultipleServiceInventoryScreen(inventory: item)
            );
          },
        )
      ],
    );
  }

  Widget singleServiceItemUI(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text("Description", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),),
        SizedBox(height: 20,),
        Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla duis massa nisl lectus urna integer blandit est sit. Ipsum ut mus scelerisque malesuada. Dapibus consequat aliquam mattis orci amet orci fames sit hendrerit. Neque aliquam, porta nunc consequat, tincidunt pulvinar. Mollis elit odio sit eleifend sit. Lectus neque dignissim ornare ipsum. Elit proin urna, eget commodo justo. Dictum eget fermentum magna rhoncus urna. Amet sed gravida vitae non curabitur varius. In non scelerisque arcu a, elementum. Facilisis ut eget vel a luctus pellentesque purus. Maecenas ut ornare urna condimentum. Justo tellus vel tellus, elit dolor mi. Varius gravida pretium sed elit lectus quis eget a, lacus.")
      ],
    );
  }
}
