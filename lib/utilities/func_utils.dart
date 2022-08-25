import "dart:math" as math;

class FuncUtils{
  static bool validateEmail(String email){
    return RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
        .hasMatch(email);
  }

  static String getRandomString({int length=7}){
    var strings = "abcdefghijklmnopqrstuvwxyz0123456789";
    String result = "";
    for(var i=0; i<length; i++){
      result += strings[math.Random().nextInt(strings.length)];
    }
    return result;
  }
}