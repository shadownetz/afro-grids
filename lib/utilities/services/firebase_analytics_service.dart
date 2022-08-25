import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';

import '../../models/purchase_item_model.dart';

class FirebaseAnalyticsService{
  late final FirebaseAnalytics _analytics;
  FirebaseAnalyticsService(): _analytics = FirebaseAnalytics.instance;

  static trackScreen(String screenName) async{
    await FirebaseAnalytics.instance
        .setCurrentScreen(
        screenName: screenName
    );
  }
  Future<void> logLoginEvent({required String loginMethod}) async {
    try{
      await _analytics.logLogin(loginMethod: loginMethod);
      debugPrint("successfully logged login event");
    }catch(e){
      debugPrint("Unable to log login event: ${e.toString()}");
    }
  }

  Future<void> logSignupEvent({required String signUpMethod}) async {
    try{
      await _analytics.logSignUp(signUpMethod: signUpMethod);
      debugPrint("successfully logged signup event");
    }catch(e){
      debugPrint("Unable to log signup event: ${e.toString()}");
    }
  }

  Future<void> logPaymentEvent({
    required String currency,
    required num price,
    required String transactionId,
    List<PurchaseItemModel> items= const []
  }) async {
    try{
      List<AnalyticsEventItem> eventItems = items.map((item) => AnalyticsEventItem(
          itemName: item.name,
          currency: item.currency,
          price: item.amount,
          quantity: item.quantity
      )).toList();
      await _analytics.logPurchase(
          currency: currency,
          value: price.toDouble(),
          transactionId: transactionId,
          items: eventItems
      );
      debugPrint("successfully logged payment event");
    }catch(e){
      debugPrint("Unable to log payment event: ${e.toString()}");
    }
  }

  Future<void> logBeginCheckoutEvent({
    required String currency,
    required num price,
    List<PurchaseItemModel> items= const []
  }) async {
    try{
      List<AnalyticsEventItem> eventItems = items.map((item) => AnalyticsEventItem(
          itemName: item.name,
          currency: item.currency,
          price: item.amount,
          quantity: item.quantity
      )).toList();
      await _analytics.logBeginCheckout(
          value: price.toDouble(),
          currency: currency,
          items: eventItems
      );
      debugPrint("successfully logged checkout event");
    }catch(e){
      debugPrint("Unable to log checkout event: ${e.toString()}");
    }
  }

}