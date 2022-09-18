import 'package:afro_grids/utilities/colours.dart';
import 'package:afro_grids/utilities/currency.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';

extension DateTimeFormatter on DateTime{
  static List<String> months = [ "January", "February", "March", "April", "May", "June",
    "July", "August", "September", "October", "November", "December" ];

  String toDateTimeStr(){
    var day = this.day;
    var month = months[this.month-1];
    var year = this.year;
    var marker = DateFormat.jm().format(this);
    return "$day $month $year at $marker";
  }

  String toTimeStr(){
    return DateFormat.jm().format(this);
  }

  Future<DateTime> networkTimestamp() async {
    return await NTP.now();
  }
}

extension CurrencyFormatter on String{
  String currencySymbol(){
    return CurrencyUtil().currencySymbol(this);
  }
  Color statusColor(){
    var str = toLowerCase();
    if(str == 'pending'){
      return Colours.secondary;
    }
    else if(str == 'approved'){
      return Colours.primary;
    }
    return Colors.red;
  }
}