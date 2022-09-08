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

class PreviewMediaScreen extends StatefulWidget {
  final List<String> files;
  const PreviewMediaScreen({Key? key, required this.files}) : super(key: key);

  @override
  State<PreviewMediaScreen> createState() => _PreviewMediaScreenState();
}

class _PreviewMediaScreenState extends State<PreviewMediaScreen> {
  final CarouselController carouselController = CarouselController();
  DeviceBloc? _deviceBloc;

  late List<String> _files;

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
        title: const Text("Preview media"),
        centerTitle: true,
      ),
      body: SizedBox(
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
                  image: NetworkImage(file),
                  fit: BoxFit.contain
              ),
            ),
          ),
        ],
      );
    }).toList();
  }
}
