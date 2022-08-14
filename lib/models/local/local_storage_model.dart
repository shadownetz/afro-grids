import 'package:afro_grids/models/user_model.dart';

class LocalStorageModel{
  UserModel? user;
  List<String> _notifications = [];

  LocalStorageModel({this.user});

  String? get getNextNotification{
    if(_notifications.isNotEmpty){
      return _notifications.removeAt(0);
    }
    return null;
  }

  void addNotification(String value){
    _notifications.add(value);
  }


}