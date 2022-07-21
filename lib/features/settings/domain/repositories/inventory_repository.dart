import 'package:catchfish/features/settings/domain/entities/inventory_entity.dart';

abstract class InventoryRepository {
  Future<InventoryEntity> getInventoryDB(String email);
}
