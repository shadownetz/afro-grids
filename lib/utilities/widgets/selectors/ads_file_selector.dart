import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../blocs/device/device_bloc.dart';
import '../../../blocs/device/device_event.dart';
import '../../../blocs/device/device_state.dart';
import '../widgets.dart';

class AdsFileSelector extends StatefulWidget {
  final String? value;
  final void Function(XFile? imageFile)? onUpdated;

  const AdsFileSelector({Key? key, this.onUpdated, this.value}) : super(key: key);

  @override
  State<AdsFileSelector> createState() => _AdsFileSelectorState();
}

class _AdsFileSelectorState extends State<AdsFileSelector> {
  DeviceBloc? deviceBlocProvider;
  XFile? selectedImage;

  @override
  Widget build(BuildContext context) {
    var deviceWidth = MediaQuery.of(context).size.width;

    return BlocProvider<DeviceBloc>(
      create: (context)=>DeviceBloc(),
      child: BlocConsumer<DeviceBloc, DeviceState>(
        listener: (context, state){
          if(state is NewImageSelected){
            if(widget.onUpdated != null){
              widget.onUpdated!(state.image);
            }
          }
        },
        builder: (context, state){
          deviceBlocProvider = BlocProvider.of<DeviceBloc>(context);
          if(state is NewImageSelected){
            selectedImage = state.image;
          }
          if(selectedImage != null){
            return _adsFile(selectedImage!);
          }
          return Column(
            children: [
              GestureDetector(
                onTap: ()=>deviceBlocProvider!.add(ChooseImageEvent()),
                child: Container(
                  width: deviceWidth-20,
                  height: 200,
                  margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: (widget.value != null? NetworkImage(widget.value!): const AssetImage("assets/icons/ads.png")) as ImageProvider,
                        fit: BoxFit.contain,
                      ),
                      boxShadow: [
                        boxShadow1()
                      ]
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _adsFile(XFile image){
    var deviceWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        GestureDetector(
          onTap: ()=>deviceBlocProvider!.add(ChooseImageEvent()),
          child:
          Container(
            width: deviceWidth-20,
            height: 200,
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: FileImage(File(image.path)),
                  fit: BoxFit.contain,
                ),
                boxShadow: [
                  boxShadow1()
                ]
            ),
          ),
        )
      ],
    );
  }
}