import 'package:afro_grids/models/local/local_message_model.dart';
import 'package:afro_grids/utilities/colours.dart';
import 'package:afro_grids/utilities/widgets/widgets.dart';
import 'package:flutter/material.dart';

class ViewChatScreen extends StatefulWidget {
  final LocalMessageModel chat;
  const ViewChatScreen({Key? key, required this.chat}) : super(key: key);

  @override
  State<ViewChatScreen> createState() => _ViewChatScreenState();
}

class _ViewChatScreenState extends State<ViewChatScreen> {
  var chatController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colours.tertiary,
      appBar: AppBar(
        title: Row(
          children: [
            roundImage(
                width: 40,
                height: 40,
                image: const AssetImage("assets/avatars/woman.png")
            ),
            const SizedBox(width: 10,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.chat.userId, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),
                const Text("available", style: TextStyle(fontSize: 17, color: Colors.white54),)
              ],
            )
          ],
        ),
        actions: [
          IconButton(
              onPressed: ()=>{},
              icon: const Icon(Icons.star_border)
          )
        ],
      ),
      body: Stack(
        children: [
          Container(
            width: deviceWidth,
            height: (deviceHeight-20),
            margin: const EdgeInsets.only(top: 20),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                boxShadow: [boxShadow1()]
            ),
            child: Stack(
              children: [
                // message timestamp indicator
                Align(
                  alignment: Alignment.topCenter,
                  child: Card(
                    elevation: 3,
                    color: Colours.secondary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)
                    ),
                    child: Container(
                      width: 80,
                      height: 25,
                      alignment: Alignment.center,
                      child: const Text("Today"),
                    ),
                  ),
                ),
                // messages section
                Container(
                  margin: const EdgeInsets.only(top: 40),
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      // first chat
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Card(
                              elevation: 2,
                              color: Colours.primary,
                              margin: EdgeInsets.only(left: 0),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(7)
                              ),
                              child: Container(
                                width: deviceWidth/2.2,
                                padding: const EdgeInsets.all(10),
                                child: Text(
                                  "Hi i am heading to the mall this afternoon",
                                  style: TextStyle(color: Colors.white, fontSize: 15),
                                ),
                              ),
                            ),
                            SizedBox(height: 7,),
                            Text("11.12", style: TextStyle(color: Colors.grey),)
                          ],
                        ),
                      ),
                      // second chat
                      Align(
                        alignment: Alignment.centerRight,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Card(
                              elevation: 2,
                              color: Colours.tertiary,
                              surfaceTintColor: Colours.tertiary,
                              margin: EdgeInsets.only(left: 0),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(7)
                              ),
                              child: Container(
                                width: deviceWidth/2.2,
                                padding: const EdgeInsets.all(10),
                                child: Text(
                                  "Hi i am heading to the mall this afternoon",
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                            ),
                            SizedBox(height: 7,),
                            Text("11.12", style: TextStyle(color: Colors.grey),)
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                // message type area
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          width: deviceWidth-100,
                          child: TextField(
                            controller: chatController,
                            cursorHeight: 20,
                            textInputAction: TextInputAction.send,
                            decoration: InputDecoration(
                                hintText: "Message",
                                filled: true,
                                fillColor: const Color.fromRGBO(240, 240, 240, 1),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(20)
                                )
                            ),
                            onSubmitted: (value){},
                          ),
                        ),
                        ElevatedButton(
                            onPressed: (){},
                            style: ElevatedButton.styleFrom(
                              alignment: Alignment.center,
                              primary: Colours.primary,
                              onPrimary: Colors.white,
                              minimumSize: const Size(50, 50),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50)
                                )
                            ),
                            child: const Icon(Icons.send)
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
