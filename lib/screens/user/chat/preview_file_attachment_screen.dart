import 'dart:io';

import 'package:afro_grids/blocs/device/device_bloc.dart';
import 'package:afro_grids/blocs/device/device_event.dart';
import 'package:afro_grids/utilities/services/navigation_service.dart';
import 'package:afro_grids/utilities/widgets/button_widget.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../blocs/device/device_state.dart';

class PreviewFileAttachmentScreen extends StatefulWidget {
  final List<XFile> files;
  const PreviewFileAttachmentScreen({Key? key, required this.files}) : super(key: key);

  @override
  State<PreviewFileAttachmentScreen> createState() => _PreviewFileAttachmentScreenState();
}

class _PreviewFileAttachmentScreenState extends State<PreviewFileAttachmentScreen> {
  final CarouselController carouselController = CarouselController();
  DeviceBloc? _deviceBloc;

  late List<XFile> _files;

  @override
  void initState() {
    _files = widget.files;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(0, 0, 0, 0.5),
      appBar: AppBar(
        leading: CloseButton(
          color: Colors.white,
          onPressed: (){
            NavigationService.exitPage(null);
          },
        ),
        title: const Text("Preview images"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          BlocProvider<DeviceBloc>(
            create: (context)=>DeviceBloc(),
            child: BlocConsumer<DeviceBloc, DeviceState>(
              listener: (context, state){
                if(state is NewImagesUpdated){
                  if(state.images.isNotEmpty){
                    setState(() {
                      _files = state.images;
                    });
                  }else{
                    NavigationService.exitPage(null);
                  }
                }
              },
              builder: (context, state){
                _deviceBloc = BlocProvider.of<DeviceBloc>(context);
                return SizedBox(
                  width: deviceWidth,
                  height: deviceHeight,
                  child: CarouselSlider(
                    carouselController: carouselController,
                    items: buildFileItem(),
                    options: CarouselOptions(
                      autoPlay: true,
                      height: double.infinity,
                      viewportFraction: 1,
                      enableInfiniteScroll: false,
                    ),
                  ),
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ElevatedButton(
                style: buttonSmStyle(),
                onPressed: ()=>NavigationService.exitPage(_files),
                child: const Text("Confirm")
            ),
          )
        ],
      ),
    );
  }

  List<Widget> buildFileItem(){
    return _files.map((file){
      return Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: FileImage(File(file.path)),
                  fit: BoxFit.contain
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(top: 10, right: 10),
              child: RoundSMButton(
                child: const Icon(Icons.delete),
                onPressed: () {
                  _deviceBloc!.add(RemoveItemFromImagesEvent(images: _files, image: file));
                },
              ),
            ),
          )
        ],
      );
    }).toList();
  }
}
