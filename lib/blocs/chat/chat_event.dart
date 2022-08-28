import 'package:afro_grids/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

abstract class ChatEvent extends Equatable{}

class FetchNextChatsEvent extends ChatEvent{
  final UserModel fromUser;
  final UserModel toUser;
  final DocumentSnapshot cursor;
  FetchNextChatsEvent({required this.fromUser, required this.toUser, required this.cursor});
  @override
  List<Object?> get props => [];

}

class GetChatListEvent extends ChatEvent{
  final UserModel user;
  GetChatListEvent({required this.user});
  @override
  List<Object?> get props => [];

}