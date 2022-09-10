import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import '../../models/local/local_chat_list_model.dart';

abstract class ChatState extends Equatable{}

class ChatInitialState extends ChatState{
  @override
  List<Object?> get props =>[];

}

class ChatLoadingState extends ChatState{
  @override
  List<Object?> get props =>[];

}

class ChatLoadedState extends ChatState{
  final QuerySnapshot? chats;
  final List<LocalChatListModel>? chatsList;
  ChatLoadedState({this.chats, this.chatsList});
  @override
  List<Object?> get props =>[];

}

class FetchedUnreadMsgState extends ChatState{
  final int unreadCount;
  FetchedUnreadMsgState(this.unreadCount);
  @override
  List<Object?> get props =>[];

}

class ChatErrorState extends ChatState{
  final String message;
  ChatErrorState(this.message);
  @override
  List<Object?> get props =>[];

}