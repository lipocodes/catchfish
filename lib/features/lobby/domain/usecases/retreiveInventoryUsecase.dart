import 'package:catchfish/features/fishingShop/domain/entities/retreive_inventory_entity.dart';

class RetreiveInventoryUsecase {
  Future<RetreiveInventoryEntity> getInventory() async {
    RetreiveInventoryEntity retreiveInventoryEntity = RetreiveInventoryEntity(
        inventoryMoney: 10, inventoryBaits: 5, inventoryXP: 3);

    return retreiveInventoryEntity;
  }
}
