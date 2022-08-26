import 'dart:convert';

import 'package:afro_grids/configs/api_config.dart';
import 'package:afro_grids/utilities/credentials.dart';
import 'package:flutter/material.dart';
import 'package:flutterwave_standard/core/flutterwave.dart';
import 'package:flutterwave_standard/models/requests/customer.dart' as RaveCustomer;
import 'package:flutterwave_standard/models/requests/customizations.dart';
import 'package:flutterwave_standard/models/responses/charge_response.dart';
import "package:http/http.dart" as http;

import '../../models/payment_response_model.dart';
import '../../repositories/auth_repo.dart';
import '../styles.dart';

class PaymentService{

  PaymentService();

  RaveCustomer.Customer getCustomer(firstName, phone, String email) {
    return RaveCustomer.Customer(
        name: firstName,
        phoneNumber: phone,
        email: email
    );
  }

  Future<PaymentResponseModel?> verifyPayment(String transactionId)async{
    http.Response transactionResponse = await http.post(
      Uri.parse("${APIConfig().paymentURL}/verify"),
      headers: APIConfig().header(accessToken: await AuthRepo().getAccessToken()),
      body: {
        'transactionId': transactionId,
        'isTest': APIConfig.testMode
      },
    );
    if(transactionResponse.statusCode == 200){
      return PaymentResponseModel.fromJson(jsonDecode(transactionResponse.body));
    }
    return null;
  }

  Future<PaymentResponseModel> pay(
      {
        required BuildContext context,
        required String email,
        required firstName,
        required String userId,
        required String phone,
        required String amount,
        required String paymentLabel,
        required String currency,
        String? description
      }) async {

    final Flutterwave flutterwave = Flutterwave(
      context: context,
      style: ravePayStyle(paymentLabel),
      publicKey: Credentials.raveKey(isTest: APIConfig.testMode),
      currency: currency,
      txRef: "${DateTime.now()}_$userId",
      amount: amount,
      customer: getCustomer(firstName, phone, email),
      paymentOptions: "ussd, card, account, banktransfer, mpesa, mobilemoneyghana, mobilemoneyfranco, mobilemoneyuganda, mobilemoneyrwanda, mobilemoneyzambia, qr, credit, barter, payattitude",
      customization: Customization(
          title: description ?? paymentLabel,
          logo: 'https://firebasestorage.googleapis.com/v0/b/afrogrids.appspot.com/o/ext%2Frsz_1afrogrid.png?alt=media&token=a1a70d50-9a98-4a2a-a670-a262a27b0c7e'
      ),
      isTestMode: APIConfig.testMode,
      redirectUrl: 'https://afrogrids.com',
      meta: {
        'username': firstName,
        'phone': phone,
        'email': email,
        'purpose': paymentLabel
      },
    );
    final ChargeResponse response = await flutterwave.charge();

    if(response.success != null) {
      var paymentVerificationResponse = await verifyPayment(response.transactionId!);
      if(paymentVerificationResponse != null){
        return paymentVerificationResponse;
      }
      throw Exception("Unable to verify payment");
    } else {
      throw Exception("Unable to complete payment");
    }
  }

}
