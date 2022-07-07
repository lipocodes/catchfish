class InventoryScreenEntity {
  late List<String> idItemsToSell = [];
  late List<String> imageItemsToSell = [];
  late List<int> priceItemsToSell = [];
  late List<String> titleItemsToSell = [];
  late List<String> subtitleItemsToSell = [];
  late List<String> ids;
  late List<String> images;
  late List<String> items;
  late List<int> quantities;
  InventoryScreenEntity(
      {required this.idItemsToSell,
      required this.imageItemsToSell,
      required this.priceItemsToSell,
      required this.titleItemsToSell,
      required this.subtitleItemsToSell,
      required this.ids,
      required this.images,
      required this.items,
      required this.quantities});
}
