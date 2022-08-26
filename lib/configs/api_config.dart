import 'package:afro_grids/utilities/credentials.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class APIConfig{
  static bool testMode = true;
  final String _TEST_API_ENDPOINT="${dotenv.env['DEV_DOMAIN']!}/v1";
  final String _PROD_API_ENDPOINT="${dotenv.env['PROD_DOMAIN']!}/v1";

  Map<String, String> header({String? accessToken}){
    return {
      'API-KEY': Credentials.aPIKey,
      'X-ACCESS-TOKEN': accessToken ?? ""
    };
  }

  String get APIURL{
    return testMode? _TEST_API_ENDPOINT: _PROD_API_ENDPOINT;
  }
  String get paymentURL{
    return "$APIURL/transaction";
  }

}