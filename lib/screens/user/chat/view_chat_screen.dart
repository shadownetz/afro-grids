import 'dart:async';

import 'package:afro_grids/blocs/chat/chat_bloc.dart';
import 'package:afro_grids/blocs/device/device_bloc.dart';
import 'package:afro_grids/blocs/device/device_event.dart';
import 'package:afro_grids/main.dart';
import 'package:afro_grids/models/chat_model.dart';
import 'package:afro_grids/models/user_model.dart';
import 'package:afro_grids/repositories/chat_repo.dart';
import 'package:afro_grids/screens/user/chat/preview_files_screen.dart';
import 'package:afro_grids/screens/user/chat/view_chat_content_screen.dart';
import 'package:afro_grids/utilities/alerts.dart';
import 'package:afro_grids/utilities/class_constants.dart';
import 'package:afro_grids/utilities/colours.dart';
import 'package:afro_grids/utilities/type_extensions.dart';
import 'package:afro_grids/utilities/widgets/button_widget.dart';
import 'package:afro_grids/utilities/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../blocs/device/device_state.dart';
import '../../../utilities/services/navigation_service.dart';

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
  final ScrollController _scrollController = ScrollController(initialScrollOffset: 1000);
  late Stream<QuerySnapshot> _messageStream;
  ChatBloc? chatBloc;
  DocumentSnapshot? currentCursor;
  bool loading = false;
  bool chatInitialized = false;
  bool showAttachFileIcon = true;
  DateTime timeAgoStamp = DateTime.now();

  @override
  void dispose() {
    _scrollController.dispose();
    chatController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _messageStream = ChatRepo().getChatsStream(localStorage.user!.id, widget.user.id);
    _scrollController.addListener(() {
      setState(() {}); // update timeago timestamp
      if (_scrollController.position.atEdge) {
        bool atTop = _scrollController.position.pixels == 0;
        if (atTop) {
          fetchNextChat();
        }
      }
    });
    chatController.addListener(() {
      setState(() {
        showAttachFileIcon = chatController.text.isEmpty;
      });
    });

    super.initState();
  }

  void fetchNextChat()async{
    if(currentCursor != null){
      setState(()=>loading=true);
      var querySnapshot = await ChatRepo().fetchChats(
        fromId: localStorage.user!.id,
        toId: widget.user.id,
        cursor: currentCursor!,
      );
      setState(()=>loading=false);
      setNextChats(querySnapshot);
    }
  }

  void setNextChats(QuerySnapshot nChats){
    if(nChats.docs.isNotEmpty){
      var newChats = nChats.docs.map((doc) =>
          ChatModel.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>))
          .toList();
      newChats = newChats.where((chat) => chats.indexWhere((chat2)=>chat2.id==chat.id) < 0).toList();
      for(var chat in newChats){
        chats.insert(0, chat);
      }
      currentCursor = nChats.docs.last;
    }else{
      currentCursor = null;
    }
  }

  void setChats(QuerySnapshot newChats){
    var chats2 = newChats.docs.map((doc) =>
        ChatModel.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>))
        .toList();
    chats2 = chats2.where((chat) => chats.indexWhere((chat2)=>chat2.id==chat.id) < 0).toList();
    chats.addAll(chats2.reversed);
    if(!chatInitialized){ // only set cursor once because subsequent update will reflect in app
      if(newChats.docs.isNotEmpty){
        currentCursor = newChats.docs.last;
      }
    }
    if(!chatInitialized){
      chatInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colours.tertiary,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: const BackButton(color: Colors.white),
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
          FavoriteButton(user: widget.user)
        ],
      ),
      body: AnimatedContainer(
        width: deviceWidth,
        height: (deviceHeight!-20),
        margin: const EdgeInsets.only(top: 20),
        duration: const Duration(milliseconds: 500),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
            boxShadow: [boxShadow1()]
        ),
        child: StreamBuilder(
            stream: _messageStream,
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
              if (snapshot.hasError) {
                return const Text('we were unable to load your chat history');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SpinKitRotatingCircle(
                  size: 20,
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
              setChats(snapshot.data!);
              return Stack(
                children: [
                  // new message loading indicator
                  loading ?
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      height: 50,
                      margin: const EdgeInsets.only(top: 10),
                      child: const SpinKitRing(
                        color: Colours.primary,
                        size: 20,
                        lineWidth: 3,
                      ),
                    ),
                  ):
                  const SizedBox(),
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
                        width: 100,
                        height: 25,
                        constraints: const BoxConstraints(maxWidth: 150, maxHeight: 30),
                        alignment: Alignment.center,
                        child: Text(timeago.format(timeAgoStamp)),
                      ),
                    ),
                  ),
                  // messages section
                  SafeArea(
                      child: Container(
                        margin: const EdgeInsets.only(top: 50),
                        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 80),
                        child: ListView.builder(
                          controller: _scrollController,
                          shrinkWrap: true,
                          itemCount: chats.length,
                          itemBuilder: (context, idx){
                            var chat = chats[idx];
                            timeAgoStamp = chat.createdAt;
                            if(chat.createdBy == widget.user.id){
                              return buildReceiverChatBox(chat);
                            }else{
                              return buildSenderChatBox(chat);
                            }
                          },
                        ),
                      )
                  ),
                  // message type area
                  buildMsgTypeArea()
                ],
              );
            }
        ),
      ),
    );
  }


  Widget buildReceiverChatBox(ChatModel chat){
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 7,),
          Card(
            elevation: 2,
            color: Colours.primary,
            margin: const EdgeInsets.only(left: 0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7)
            ),
            child: Container(
              width: deviceWidth!/2.2,
              padding: const EdgeInsets.all(10),
              child: buildChatContent(chat: chat, isReceiver: true),
            ),
          ),
          const SizedBox(height: 7,),
          Text(chat.createdAt.toTimeStr(), style: TextStyle(color: Colors.grey),)
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
          const SizedBox(height: 7,),
          Card(
            elevation: 2,
            color: Colours.tertiary,
            surfaceTintColor: Colours.tertiary,
            margin: const EdgeInsets.only(left: 0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7)
            ),
            child: Container(
              width: deviceWidth!/2.2,
              padding: const EdgeInsets.all(10),
              child: buildChatContent(chat: chat, isReceiver: false),
            ),
          ),
          const SizedBox(height: 7,),
          Text(chat.createdAt.toTimeStr(), style: const TextStyle(color: Colors.grey),)
        ],
      ),
    );
  }
  Widget buildMsgTypeArea(){
    final alerts =  Alerts(context);
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.all(10),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            showAttachFileIcon?
            BlocProvider(
                create: (context)=>DeviceBloc(),
              child: BlocConsumer<DeviceBloc, DeviceState>(
                listener: (context, state)async{
                  if(state is NewImagesSelected){
                    List<XFile>? files = await NavigationService.toPage(PreviewFilesScreen(files: state.images!,));
                    if(files != null){
                      try{
                        ChatModel newChat = ChatModel(
                            id: "",
                            createdBy: localStorage.user!.id,
                            type: ChatType.image,
                            content: "",
                            createdAt: DateTime.now(),
                            createdFor: widget.user.id
                        );
                        alerts.showLoadingDialog(title: "Uploading images", message: "Please wait");
                        await ChatRepo(chat: newChat).sendMessageFiles(files);
                        notifySentMsgListener();
                      }catch(e){
                        alerts.showToast(e.toString(), duration: const Duration(seconds: 5));
                      }finally{
                        NavigationService.exitPage(); // close loading modal
                      }
                    }
                  }
                },
                builder: (context, state){
                  return IconButton(
                      onPressed: ()async{
                        BlocProvider.of<DeviceBloc>(context).add(ChooseImagesEvent());
                      },
                      color: Colours.secondary,
                      icon: const Icon(Icons.attach_file)
                  );
                },
              ),
            ):
            const SizedBox(),
            Expanded(
                flex: 2,
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
                )
            ),
            ElevatedButton(
                onPressed: ()async{
                  if(chatController.text.isNotEmpty){
                    ChatModel newChat = ChatModel(
                        id: "",
                        createdBy: localStorage.user!.id,
                        type: ChatType.text,
                        content: chatController.text,
                        createdAt: DateTime.now(),
                        createdFor: widget.user.id
                    );
                    ChatRepo(chat: newChat).sendMessage();
                    notifySentMsgListener();
                  }
                },
                style: ElevatedButton.styleFrom(
                    alignment: Alignment.center,
                    backgroundColor: Colours.primary,
                    foregroundColor: Colors.white,
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

  Widget buildChatContent({required ChatModel chat, required bool isReceiver}){

    if(chat.type == ChatType.text){
      if(isReceiver){
        return Text(
          chat.content,
          style: const TextStyle(color: Colors.white, fontSize: 15),
        );
      }else{
        return Text(
          chat.content,
          style: const TextStyle(fontSize: 15),
        );
      }
    }
    if(chat.type == ChatType.image){
      return GestureDetector(
        onTap: (){
          NavigationService.toPage(ViewChatContentScreen(chat: chat,));
        },
        child: Container(
          height: 200,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                  image: NetworkImage(chat.content),
                  fit: BoxFit.cover
              )
          ),
        ),
      );
    }
    return const SizedBox();
  }

  void notifySentMsgListener(){
    chatController.clear();
    _scrollController.jumpTo(5000*(chats.length/25));
    setState(()=>showAttachFileIcon = true);
  }
}
