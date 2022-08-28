import 'package:afro_grids/main.dart';
import 'package:afro_grids/models/chat_model.dart';
import 'package:afro_grids/models/user_model.dart';
import 'package:afro_grids/repositories/chat_repo.dart';
import 'package:afro_grids/utilities/colours.dart';
import 'package:afro_grids/utilities/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ViewChatScreen extends StatefulWidget {
  final UserModel user;
  const ViewChatScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<ViewChatScreen> createState() => _ViewChatScreenState();
}

class _ViewChatScreenState extends State<ViewChatScreen> {
  var chatController = TextEditingController();
  double? deviceHeight;
  double? deviceWidth;
  List<ChatModel> chats = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.atEdge) {
        bool isBottom = _scrollController.position.pixels == 0;
        if (!isBottom) {
          // fetch next chats if all items are not loaded
        }
      }
    });

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colours.tertiary,
      appBar: AppBar(
        title: Row(
          children: [
            RoundImage(
                width: 40,
                height: 40,
                fit: BoxFit.cover,
                image: (widget.user.avatar.isNotEmpty?
                NetworkImage(widget.user.avatar):
                const AssetImage("assets/avatars/woman.png")) as ImageProvider
            ),
            const SizedBox(width: 10,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.user.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),
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
            height: (deviceHeight!-20),
            margin: const EdgeInsets.only(top: 20),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                boxShadow: [boxShadow1()]
            ),
            child: StreamBuilder(
                stream: ChatRepo().getChatsStream(localStorage.user!.id, widget.user.id),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                  if (snapshot.hasError) {
                    return const Text('we were unable to load your chat history');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return SpinKitRotatingCircle(
                      size: 50,
                      itemBuilder: (BuildContext context, int index) {
                        return const DecoratedBox(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colours.primary,
                          ),
                        );
                      },
                    );
                  }
                  var chats2 = snapshot.data!
                      .docs.map((doc) =>
                      ChatModel.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>))
                      .toList();
                  chats2 = chats2.where((chat) => !chats.contains(chat)).toList();
                  for(var chat in chats2){
                    chats.insert(0, chat);
                  }
                  return Stack(
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
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: ListView.builder(
                          controller: _scrollController,
                          shrinkWrap: true,
                          itemCount: chats.length,
                          itemBuilder: (context, idx){
                            var chat = chats[idx];
                            if(chat.createdBy == widget.user.id){
                              return buildReceiverChatBox(chat);
                            }else{
                              return buildSenderChatBox(chat);
                            }
                          },
                        ),
                      ),
                      // message type area
                      buildMsgTypeArea()
                    ],
                  );
                }
            ),
          )
        ],
      ),
    );
  }


  Widget buildReceiverChatBox(ChatModel chat){
    return Align(
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
              width: deviceWidth!/2.2,
              padding: const EdgeInsets.all(10),
              child: Text(
                chat.content,
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),
          ),
          SizedBox(height: 7,),
          Text("11.12", style: TextStyle(color: Colors.grey),)
        ],
      ),
    );
  }

  Widget buildSenderChatBox(ChatModel chat){
    return Align(
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
              width: deviceWidth!/2.2,
              padding: const EdgeInsets.all(10),
              child: Text(
                chat.content,
                style: TextStyle(fontSize: 15),
              ),
            ),
          ),
          SizedBox(height: 7,),
          Text("11.12", style: TextStyle(color: Colors.grey),)
        ],
      ),
    );
  }
  Widget buildMsgTypeArea(){
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              width: deviceWidth!-100,
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
    );
  }
}
