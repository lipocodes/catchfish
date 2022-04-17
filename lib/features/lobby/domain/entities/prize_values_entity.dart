class PrizeValuesEntity {
  int inventoryMoney;
  int inventoryBaits;
  int inventoryXP;
  int lastPrizeValuesUpdateDB;
  PrizeValuesEntity({
    required this.inventoryMoney,
    required this.inventoryBaits,
    required this.inventoryXP,
    required this.lastPrizeValuesUpdateDB,
  });
  factory PrizeValuesEntity.fromJson(Map<String, dynamic> json) {
    return PrizeValuesEntity(
        inventoryMoney: json['inventoryMoney'],
        inventoryBaits: json['inventoryBaits'],
        inventoryXP: json['inventoryXP'],
        lastPrizeValuesUpdateDB: json['lastPrizeValuesUpdateDB']);
  }
  Map<String, dynamic> toJson() {
    return {
      'inventoryMoney': inventoryMoney,
      'inventoryBaits': inventoryBaits,
      'inventoryXP': inventoryXP,
      'lastPrizeValuesUpdateDB': lastPrizeValuesUpdateDB,
    };
  }
}
