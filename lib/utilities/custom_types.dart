import 'package:afro_grids/models/inventory_model.dart';

class Ratings{
  final num total;
  final num count;
  final num average;
  Ratings(this.total, this.count, this.average);
}

class Reviews{
  final num total;
  final num average;
  Reviews(this.total, this.average);
}

class OrderItem{
  final String inventoryId;
  final int count;
  OrderItem(this.inventoryId, this.count);
}