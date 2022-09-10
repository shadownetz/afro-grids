import 'package:afro_grids/blocs/chat/chat_bloc.dart';
import 'package:afro_grids/blocs/chat/chat_event.dart';
import 'package:afro_grids/main.dart';
import 'package:afro_grids/models/local/local_chat_list_model.dart';
import 'package:afro_grids/screens/user/chat/view_chat_screen.dart';
import 'package:afro_grids/utilities/colours.dart';
import 'package:afro_grids/utilities/services/navigation_service.dart';
import 'package:timeago/timeago.dart' as timeago;
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

  ChatBloc? _chatBloc;
  List<LocalChatListModel>? _chatList;

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
              if(_chatList == null){
                if(state is ChatLoadingState){
                  context.loaderOverlay.show();
                }else{
                  context.loaderOverlay.hide();
                }
              }
              if(state is ChatErrorState){
                Alerts(context).showToast(state.message);
              }
              if(state is ChatLoadedState){
                if(state.chatsList != null) {
                  setState(()=>_chatList=state.chatsList);
                }
              }
            },
            builder: (context, state){
              _chatBloc = BlocProvider.of<ChatBloc>(context);
              if(_chatList != null){
                if(_chatList!.isNotEmpty){
                  return buildChatList(_chatList!);
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
            isThreeLine: true,
            leading: RoundImage(
                fit: BoxFit.cover,
                image: (chat.user.avatar.isNotEmpty? NetworkImage(chat.user.avatar): const AssetImage("assets/avatars/woman.png")) as ImageProvider
            ),
            title: Text(chat.user.name, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),),
            subtitle: Text(chat.chatMeta.lastMsg, style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w500, overflow: TextOverflow.ellipsis),),
            trailing: Column(
              children: [
                Text(timeago.format(chat.chatMeta.lastMsgTimestamp), style: const TextStyle(color: Colors.grey),),
                const SizedBox(height: 6,),
                BlocProvider(
                  key: Key("${DateTime.now().millisecondsSinceEpoch}"),
                  create: (context)=>ChatBloc()..add(GetUnreadMessages(sender: localStorage.user!, receiver: chat.user, lastReadMsgId: chat.chatInfo.lastReadMessageId)),
                  child: BlocBuilder<ChatBloc, ChatState>(
                      builder: (context, state){
                        if(state is FetchedUnreadMsgState){
                          if(state.unreadCount > 0){
                            return  Container(
                              width: 20,
                              height: 20,
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colours.secondary
                              ),
                              child: Text("${state.unreadCount}", style: const TextStyle(fontWeight: FontWeight.bold),),
                            );
                          }
                        }
                        return const SizedBox();
                      }
                  ),
                ),
              ],
            ),
            onTap: ()async{
              await NavigationService.toPage(ViewChatScreen(user: chat.user));
              _chatBloc!.add(GetChatListEvent(user: localStorage.user!));
            },
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
