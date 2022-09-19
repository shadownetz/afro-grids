import 'dart:io';
import "dart:math" as math;

import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

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

  static void openEmailURL({required String to, required String subject, required String message}) {
    String? encodeQueryParameters(Map<String, String> params) {
      return params.entries
          .map((e) =>
      '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&');
    }

    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: to,
      query: encodeQueryParameters(<String, String>{
        'subject': subject,
        'body': message
      }),
    );
    launchUrl(emailLaunchUri);
  }
  static void openWebURL(String url) async {
    List<String> tmpUrl = url.split(":");
    if(tmpUrl.first != 'http' || tmpUrl.first != 'https'){
      tmpUrl.insert(0, "http://");
    }
    url = tmpUrl.join("");
    await openUrl(Uri.parse(url));
  }
  static void openWhatsappURL({required String phoneNumber, required String message})async{
    String whatsappURL = "whatsapp://send?phone=$phoneNumber&text=$message";
    if (Platform.isIOS) {
      whatsappURL = "https://wa.me/$phoneNumber?text=${Uri.parse(message)}";
    }
    await openUrl(Uri.parse(whatsappURL));
  }
  static Future<void> openUrl(Uri url)async{
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

}