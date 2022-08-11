import 'package:afro_grids/utilities/credentials.dart';

class APIConfig{
  static bool testMode = true;
  final String _TEST_API_ENDPOINT="http://localhost:5001/afrogrids/us-central1/api/v1";
  final String _PROD_API_ENDPOINT="http://localhost:5001/afrogrids/us-central1/api/v1";
  final String _TEST_PAYMENT_URL='';
  final String _PROD_PAYMENT_URL='';

  Map<String, String> header({String? accessToken}){
    return {
      'API-KEY': Credentials.aPIKey,
      'X-ACCESS-TOKEN': accessToken ?? ""
    };
  }

  String get APIURL{
    return testMode? _TEST_API_ENDPOINT: _PROD_API_ENDPOINT;
  }

}