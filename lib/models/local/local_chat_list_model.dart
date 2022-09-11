import 'package:afro_grids/models/chat/chat_info_model.dart';

import '../user/user_chat_info_model.dart';
import '../user/user_model.dart';

class LocalChatListModel{
  UserModel user;
  ChatInfoModel chatMeta;
  UserChatInfoModel chatInfo;

  LocalChatListModel({
    required this.user,
    required this.chatMeta,
    required this.chatInfo
  });

}