import 'package:afro_grids/models/user_model.dart';

class LocalStorageModel{
  UserModel? user;
  List<String> _notifications = [];

  LocalStorageModel({this.user});

  String get getNextNotification{
    return _notifications.removeAt(0);
  }

  List<String>? get notifications{
    return _notifications.isEmpty? null: _notifications;
  }

  void addNotification(String value){
    _notifications.add(value);
  }


}