import 'package:catchfish/features/settings/data/repositories/inventory_repository_impl.dart';
import 'package:catchfish/features/settings/domain/entities/inventory_entity.dart';

class InventoryUsecases {
  Future<InventoryEntity> getInventoryDB(String email) async {
    InventoryRepositoryImpl inventoryRepositoryImpl = InventoryRepositoryImpl();

    return await inventoryRepositoryImpl.getInventoryDB(email);
  }
}
