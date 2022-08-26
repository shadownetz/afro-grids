import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CurrencyUtil{
  BuildContext? context;

  CurrencyUtil({this.context});

  String currencySymbol(String currencyName){
    var format = NumberFormat.simpleCurrency(locale: Platform.localeName, name: currencyName);
    return format.currencySymbol;
  }

  String get currencyName{
    var format = NumberFormat.simpleCurrency(locale: Platform.localeName);
    return format.currencyName ?? "";
  }

  String format(num value){
    return NumberFormat("#,000").format(value);
  }

  List<String> get acceptedCurrencies{
    return ['USD'];
    // return [
    //   'GBP', 'CAD', 'XAF', 'CLP', 'COP', 'EGP', 'EUR', 'GHS',
    //   'GNF', 'KES', 'MWK', 'MAD', 'NGN', 'RWF', 'SLL', 'STD',
    //   'ZAR', 'TZS', 'UGX', 'USD', 'XOF', 'ZMW'
    // ];
  }

}