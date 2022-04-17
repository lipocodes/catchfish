import 'package:catchfish/features/settings/data/models/inventory_model.dart';

class RemoteDataSources {
  Future<InventoryModel> getInventoryDB(String email) async {
    InventoryModel inventoryModel =
        await InventoryModel(listInventory: ["ccccccccccccccccccc"]);
    return inventoryModel;
  }
}
