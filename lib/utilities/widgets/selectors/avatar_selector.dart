import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../blocs/device/device_bloc.dart';
import '../../../blocs/device/device_event.dart';
import '../../../blocs/device/device_state.dart';
import '../widgets.dart';

class AvatarSelector extends StatefulWidget {
  final void Function(XFile? imageFile)? onUpdated;

  const AvatarSelector({Key? key, this.onUpdated}) : super(key: key);

  @override
  State<AvatarSelector> createState() => _AvatarSelectorState();
}

class _AvatarSelectorState extends State<AvatarSelector> {
  DeviceBloc? deviceBlocProvider;
  XFile? selectedImage;

  @override
  Widget build(BuildContext context) {

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
            return _avatar(selectedImage!);
          }
          return Column(
            children: [
              GestureDetector(
                onTap: ()=>deviceBlocProvider!.add(ChooseImageEvent()),
                child: Stack(
                  children: [
                    roundImage(
                        image: const AssetImage("assets/avatars/man.png"),
                        width: 130,
                        height: 130
                    ),
                    Container(
                      height: 130,
                      width: 130,
                      decoration: const BoxDecoration(
                          color: Color.fromRGBO(0, 0, 0, 0.5),
                          shape: BoxShape.circle
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.image, color: Colors.white,),
                          SizedBox(width: 5,),
                          Text("update", style: TextStyle(color: Colors.white),)
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _avatar(XFile image){

    return Column(
      children: [
        GestureDetector(
          onTap: ()=>deviceBlocProvider!.add(ChooseImageEvent()),
          child: roundImage(
              image: FileImage(File(image.path)),
              width: 130,
              height: 130,
              hasShadow: true,
              fit: BoxFit.cover
          ),
        )
      ],
    );
  }
}