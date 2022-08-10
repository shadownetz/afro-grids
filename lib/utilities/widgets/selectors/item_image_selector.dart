import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../../blocs/device/device_bloc.dart';
import '../../../blocs/device/device_event.dart';
import '../../../blocs/device/device_state.dart';
import '../widgets.dart';


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
  DeviceBloc? deviceBlocProvider;
  List<XFile>? selectedImages;

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;

    return BlocProvider<DeviceBloc>(
      create: (context)=>DeviceBloc(),
      child: BlocConsumer<DeviceBloc, DeviceState>(
        listener: (context, state){
          if(state is NewImagesSelected){
            if(widget.onUpdated != null){
              widget.onUpdated!(state.images);
            }
          }
        },
        builder: (context, state){
          deviceBlocProvider = BlocProvider.of<DeviceBloc>(context);
          if(state is NewImagesSelected){
            selectedImages = state.images;
            if(selectedImages != null){
              if(selectedImages!.isNotEmpty){
                return itemImages(selectedImages!);
              }
            }
          }
          if(state is NewImagesUpdated){
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
            onTap: ()=>deviceBlocProvider!.add(ChooseImagesEvent()),
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
                        deviceBlocProvider!.add(RemoveItemFromImagesEvent(
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
            onPressed: ()=>deviceBlocProvider!.add(ChooseImagesEvent()),
            child: const Text("Update images", style: TextStyle(fontWeight: FontWeight.w500),))
      ],
    );
  }
}