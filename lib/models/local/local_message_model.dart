import 'package:afro_grids/models/message_info_model.dart';

import '../message_model.dart';

class LocalMessageModel{
  String userId; //  change to user model
  List<MessageModel> messages;
  MessageInfoModel meta;

  LocalMessageModel({
    required this.userId,
    required this.messages,
    required this.meta
  });
}