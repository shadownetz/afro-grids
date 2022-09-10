import 'package:afro_grids/blocs/chat/chat_event.dart';
import 'package:afro_grids/blocs/chat/chat_state.dart';
import 'package:afro_grids/models/chat_model.dart';
import 'package:afro_grids/repositories/chat_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState>{
  ChatBloc(): super(ChatInitialState()){
    on<FetchNextChatsEvent>(_onFetchNextChatsEvent);
    on<GetChatListEvent>(_onGetChatListEvent);
    on<GetUnreadMessages>(_onGetUnreadMessages);
  }

  void _onFetchNextChatsEvent(FetchNextChatsEvent event, Emitter<ChatState> emit)async{
    emit(ChatLoadingState());
    try{
      var chats = await ChatRepo()
          .fetchChats(
          fromId: event.fromUser.id,
          toId: event.toUser.id,
          cursor: event.cursor,
          limit: 25
      );
      emit(ChatLoadedState(chats: chats));
    }catch(e){
      emit(ChatErrorState(e.toString()));
    }
  }

  void _onGetChatListEvent(GetChatListEvent event, Emitter<ChatState> emit)async{
    emit(ChatLoadingState());
    try{
      var chats = await ChatRepo().getChatList(event.user.id);
      emit(ChatLoadedState(chatsList: chats));
    }catch(e){
      emit(ChatErrorState(e.toString()));
    }
  }

  void _onGetUnreadMessages(GetUnreadMessages event, Emitter<ChatState> emit) async{
    try{
      DocumentSnapshot? lastReadMessageSnapshot;
      if(event.lastReadMsgId.isNotEmpty){
        lastReadMessageSnapshot = await ChatRepo().getMessageDoc(
            ChatRepo.generateChatId(event.receiver.id, event.sender.id),
            event.lastReadMsgId
        );
        if(!lastReadMessageSnapshot.exists){
          lastReadMessageSnapshot = null;
        }
      }
      int unreadMsgs = 0;
      if(lastReadMessageSnapshot != null){
        var querySnaps = await ChatRepo().getUnreadMessages(
            senderId: event.sender.id,
            receiverId: event.receiver.id,
            lastUnreadMsg: lastReadMessageSnapshot
        );
        unreadMsgs = querySnaps.docs
            .map((e) => ChatModel.fromFirestore(e as DocumentSnapshot<Map<String, dynamic>>))
            .where((e) => e.createdBy != event.sender.id)
            .length;
      }else{
        var querySnaps = await ChatRepo().getUnreadMessages(
            senderId: event.sender.id,
            receiverId: event.receiver.id,
        );
        unreadMsgs = querySnaps.docs
            .map((e) => ChatModel.fromFirestore(e as DocumentSnapshot<Map<String, dynamic>>))
            .where((e) => e.createdBy != event.sender.id)
            .length;
      }

      emit(FetchedUnreadMsgState(unreadMsgs));
    }catch(e){
      debugPrint(e.toString());
      // emit(ChatErrorState(e.toString()));
    }
  }

}