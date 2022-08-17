import 'package:afro_grids/models/local/local_message_model.dart';
import 'package:afro_grids/models/message_info_model.dart';
import 'package:afro_grids/screens/user/chat/view_chat_screen.dart';
import 'package:afro_grids/utilities/colours.dart';
import 'package:afro_grids/utilities/widgets/widgets.dart';
import 'package:flutter/material.dart';

import '../../../models/message_model.dart';


class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  List<LocalMessageModel> localMessages = [
    LocalMessageModel(
        userId: 'Peter Parker',
        messages: [
          MessageModel(id: "", createdBy: "jude", type: "TEXT", content: "Hello", createdAt: DateTime.now()),
          MessageModel(id: "", createdBy: "afro", type: "TEXT", content: "Hello", createdAt: DateTime.now()),
          MessageModel(id: "", createdBy: "afro", type: "TEXT", content: "Hello", createdAt: DateTime.now()),
          MessageModel(id: "", createdBy: "jude", type: "TEXT", content: "Hello", createdAt: DateTime.now()),
          MessageModel(id: "", createdBy: "jude", type: "TEXT", content: "Hello", createdAt: DateTime.now()),
          MessageModel(id: "", createdBy: "afro", type: "TEXT", content: "Hello", createdAt: DateTime.now()),
        ],
        meta: MessageInfoModel(
            id: '',
            unread: 0
        )
    ),

  ];

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colours.tertiary,
      appBar: AppBar(
        title: const Text("Chats"),
      ),
      body: Container(
        height: deviceHeight,
        width: deviceWidth,
        child: ListView.separated(
          itemBuilder: (context, msgIndex){
            final message = localMessages[msgIndex];
            return ListTile(
              leading: RoundImage(image: const AssetImage("assets/avatars/woman.png")),
              title: Text(message.userId, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),),
              subtitle: Text(message.messages.last.content, style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w500, overflow: TextOverflow.ellipsis),),
              trailing: Text('${message.messages.last.createdAt}', style: const TextStyle(color: Colors.grey),),
              onTap: ()=>Navigator.of(context).push(createRoute(ViewChatScreen(chat: message))),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return const Divider();
          },
          itemCount: localMessages.length,
        ),
      ),
    );
  }
}
