import 'package:catchfish/features/settings/data/datasources/remote_datasource.dart';
import 'package:catchfish/features/settings/data/models/inventory_model.dart';
import 'package:catchfish/features/settings/domain/entities/inventory_entity.dart';
import 'package:catchfish/features/settings/domain/repositories/inventory_repository.dart';

class InventoryRepositoryImpl implements InventoryRepository {
  @override
  Future<InventoryEntity> getInventoryDB(String email) async {
    RemoteDataSources remoteDataSources = RemoteDataSources();
    InventoryModel inventoryModel =
        await remoteDataSources.getInventoryDB(email);
    InventoryEntity inventoryEntity = inventoryModel;
    return inventoryEntity;
  }
}
