import 'package:afro_grids/utilities/services/navigation_service.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../../models/chat/chat_model.dart';

class ViewChatContentScreen extends StatefulWidget {
  final ChatModel chat;
  const ViewChatContentScreen({Key? key, required this.chat}) : super(key: key);

  @override
  State<ViewChatContentScreen> createState() => _ViewChatContentScreenState();
}

class _ViewChatContentScreenState extends State<ViewChatContentScreen> {
  final CarouselController carouselController = CarouselController();

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
            NavigationService.exitPage();
          },
        ),
        title: const Text("Image"),
        centerTitle: true,
      ),
      body: Container(
        width: deviceWidth,
        height: deviceHeight,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(widget.chat.content),
                fit: BoxFit.contain
            ),
          )
      ),
    );
  }
}
