import 'package:intl/intl.dart';

String currencyFormatter(num value){
  return NumberFormat("#,000").format(value);
}