import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService{

  late final Future<SharedPreferences> _prefs;

  SharedPreferencesService(): _prefs = SharedPreferences.getInstance();

  Future<void> setAppInit(bool value) async {
    SharedPreferences prefs = await _prefs;
    prefs.setBool("appInit", value);
  }

  Future<bool?> getAppInit() async {
    SharedPreferences prefs = await _prefs;
    return prefs.getBool("appInit");
  }

}