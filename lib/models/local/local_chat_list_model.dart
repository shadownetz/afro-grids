import 'package:afro_grids/models/chat_info_model.dart';

import '../chat_model.dart';
import '../user_model.dart';

class LocalChatListModel{
  UserModel user; //  change to user model
  ChatInfoModel meta;

  LocalChatListModel({
    required this.user,
    required this.meta
  });

}