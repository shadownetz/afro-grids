import 'package:afro_grids/utilities/currency.dart';
import 'package:intl/intl.dart';

extension DateTimeFormatter on DateTime{
  static List<String> months = [ "January", "February", "March", "April", "May", "June",
    "July", "August", "September", "October", "November", "December" ];

  String toDateTimeStr(){
    var day = this.day;
    var month = months[this.month-1];
    var year = this.year;
    var hour = this.hour;
    var minute = this.minute;
    var marker = DateFormat('a').format(this);
    return "$day $month $year at $hour:$minute $marker";
  }

  String toTimeStr(){
    return DateFormat.jm().format(this);
  }
}

extension CurrencyFormatter on String{
  String currencySymbol(){
    return CurrencyUtil().currencySymbol(this);
  }
}