import 'package:catchfish/features/settings/domain/entities/inventory_entity.dart';

class InventoryModel extends InventoryEntity {
  InventoryModel(
      {required List<String> listItemsToSell,
      required List<String> listInventory})
      : super(listItemsToSell: listItemsToSell, listInventory: listInventory);
}
