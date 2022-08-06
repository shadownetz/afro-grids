import 'dart:io';

import 'package:afro_grids/blocs/inventory/inventory_bloc.dart';
import 'package:afro_grids/blocs/inventory/inventory_event.dart';
import 'package:afro_grids/utilities/class_constants.dart';
import 'package:afro_grids/utilities/widgets/widgets.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../blocs/inventory/inventory_state.dart';

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

class NewInventoryForm extends StatefulWidget {
  const NewInventoryForm({Key? key}) : super(key: key);

  @override
  State<NewInventoryForm> createState() => _NewInventoryFormState();
}

class _NewInventoryFormState extends State<NewInventoryForm> {
  CarouselController carouselController = CarouselController();
  List<XFile>? _itemImages = [];


  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
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

        ],
      ),
    );
  }
}

class ItemImageSelector extends StatefulWidget {
  /// returns file urls when new images is selected
  final void Function(List<XFile>? fileURLs)? onUpdated;

  const ItemImageSelector({
    Key? key,
    this.onUpdated
  }) : super(key: key);

  @override
  State<ItemImageSelector> createState() => _ItemImageSelectorState();
}

class _ItemImageSelectorState extends State<ItemImageSelector> {
  final CarouselController _carouselController = CarouselController();
  InventoryBloc? inventoryBlocProvider;
  List<XFile>? selectedImages;

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;

    return BlocProvider<InventoryBloc>(
      create: (context)=>InventoryBloc(),
      child: BlocConsumer<InventoryBloc, InventoryState>(
        listener: (context, state){
          if(state is NewInventoryItemImagesSelected){
            if(widget.onUpdated != null){
              widget.onUpdated!(state.images);
            }
          }
        },
        builder: (context, state){
          inventoryBlocProvider = BlocProvider.of<InventoryBloc>(context);
          if(state is NewInventoryItemImagesSelected){
            selectedImages = state.images;
            if(selectedImages != null){
              if(selectedImages!.isNotEmpty){
                return itemImages(selectedImages!);
              }
            }
          }
          if(state is NewInventoryItemImagesUpdated){
            selectedImages = state.images;
            if(selectedImages!.isNotEmpty){
              return itemImages(selectedImages!);
            }
          }

          if(selectedImages != null){
            if(selectedImages!.isNotEmpty){
              return itemImages(selectedImages!);
            }
          }
          return GestureDetector(
            onTap: ()=>inventoryBlocProvider!.add(ChooseNewInventoryItemImages()),
            child: Container(
              width: deviceWidth-20,
              height: 170,
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  image: const DecorationImage(
                    image: AssetImage("assets/icons/cart.png"),
                    fit: BoxFit.contain,
                  ),
                  boxShadow: [
                    boxShadow2()
                  ]
              ),
              child: Container(
                alignment: Alignment.center,
                width: deviceWidth-20,
                height: 100,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(0, 0, 0, 0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.image, color: Colors.white,size: 20,),
                    SizedBox(width: 10,),
                    Text("click to upload item images", style: TextStyle(color: Colors.white, fontSize: 20),)
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget itemImages(List<XFile> images){
    final deviceWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        SizedBox(
          height: 200,
          child: CarouselSlider(
            carouselController: _carouselController,
            items: images.map((imageFile){
              return Container(
                  width: deviceWidth-20,
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: FileImage(File(imageFile.path)),
                        fit: BoxFit.contain,
                      ),
                      boxShadow: [
                        boxShadow1()
                      ]
                  ),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: ElevatedButton(
                      onPressed: (){
                        inventoryBlocProvider!.add(RemoveInventoryImageFromSelection(
                            image: imageFile,
                            images: images
                        ));
                      },
                      style: ElevatedButton.styleFrom(
                          elevation: 3,
                          shape: CircleBorder(),
                          primary: Colors.redAccent,
                          onPrimary: Colors.white
                      ),
                      child: Icon(Icons.delete_forever_rounded),
                    ),
                  )
              );
            }).toList(),
            options: CarouselOptions(
              autoPlay: true,
              height: double.infinity,
              viewportFraction: 1,
              enableInfiniteScroll: false,
            ),
          ),
        ),
        ElevatedButton(
            onPressed: ()=>inventoryBlocProvider!.add(ChooseNewInventoryItemImages()),
            child: const Text("Update images", style: TextStyle(fontWeight: FontWeight.w500),))
      ],
    );
  }
}