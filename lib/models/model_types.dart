
class Ratings{
  final num total;
  final num count;
  final num average;
  Ratings(this.total, this.count, this.average);

  Map<String, dynamic> toMap(){
    return {
      'total': total,
      'count': count,
      'average': average
    };
  }
}

class Reviews{
  final num total;
  final num average;
  Reviews(this.total, this.average);

  Map<String, dynamic> toMap(){
    return {
      'total': total,
      'average': average
    };
  }
}

class OrderItem{
  final String inventoryId;
  final int count;

  OrderItem(this.inventoryId, this.count);

  Map<String, dynamic> toMap(){
    return {
      'inventoryId': inventoryId,
      'count': count
    };
  }

}