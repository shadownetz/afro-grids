import 'package:afro_grids/blocs/chat/chat_bloc.dart';
import 'package:afro_grids/blocs/chat/chat_event.dart';
import 'package:afro_grids/main.dart';
import 'package:afro_grids/models/local/local_chat_list_model.dart';
import 'package:afro_grids/screens/user/chat/view_chat_screen.dart';
import 'package:afro_grids/utilities/colours.dart';
import 'package:afro_grids/utilities/type_extensions.dart';
import 'package:afro_grids/utilities/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../../blocs/chat/chat_state.dart';
import '../../../utilities/alerts.dart';


class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colours.tertiary,
      appBar: AppBar(
        leading: const BackButton(color: Colors.white,),
        title: const Text("Chats"),
      ),
      body: CustomLoadingOverlay(
        widget: BlocProvider<ChatBloc>(
          create: (context)=>ChatBloc()..add(GetChatListEvent(user: localStorage.user!)),
          child: BlocConsumer<ChatBloc, ChatState>(
            listener: (context, state){
              if(state is ChatLoadingState){
                context.loaderOverlay.show();
              }else{
                context.loaderOverlay.hide();
              }
              if(state is ChatErrorState){
                Alerts(context).showToast(state.message);
              }
            },
            builder: (context, state){
              if(state is ChatLoadedState){
                if(state.chatsList != null){
                  if(state.chatsList!.isNotEmpty){
                    return buildChatList(state.chatsList!);
                  }
                }
              }
              return Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: const Text("You have not started any chat", style: TextStyle(fontSize: 20, color: Colors.grey),),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget buildChatList(List<LocalChatListModel> chatLists){
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      height: deviceHeight,
      width: deviceWidth,
      child: ListView.separated(
        itemBuilder: (context, msgIndex){
          final chat = chatLists[msgIndex];
          return ListTile(
            leading: RoundImage(
                fit: BoxFit.cover,
                image: (chat.user.avatar.isNotEmpty? NetworkImage(chat.user.avatar): const AssetImage("assets/avatars/woman.png")) as ImageProvider
            ),
            title: Text(chat.user.name, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),),
            subtitle: Text(chat.meta.lastMsg, style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w500, overflow: TextOverflow.ellipsis),),
            trailing: Text(chat.meta.lastMsgTimestamp.toDateTimeStr(), style: const TextStyle(color: Colors.grey),),
            onTap: ()=>Navigator.of(context).push(createRoute(ViewChatScreen(user: chat.user))),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const Divider();
        },
        itemCount: chatLists.length,
      ),
    );
  }
}
