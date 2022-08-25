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
import '../styles.dart';

class PaymentRepo{

  PaymentRepo();

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
      headers: APIConfig().header(),
      body: jsonEncode({
        'transactionId': transactionId,
        'isTest': APIConfig.testMode
      }),
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
      paymentOptions: "ussd, card, barter, payattitude",
      customization: Customization(title: description ?? paymentLabel),
      isTestMode: APIConfig.testMode,
      redirectUrl: '',
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
