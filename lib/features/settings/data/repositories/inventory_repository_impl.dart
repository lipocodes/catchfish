import 'package:catchfish/core/errors/failures.dart';
import 'package:catchfish/features/settings/data/datasources/remote_datasource.dart';
import 'package:catchfish/features/settings/data/models/inventory_model.dart';
import 'package:catchfish/features/settings/domain/entities/inventory_entity.dart';
import 'package:catchfish/features/settings/domain/repositories/inventory_repository.dart';
import 'package:dartz/dartz.dart';

class InventoryRepositoryImpl implements InventoryRepository {
  @override
  Future<InventoryEntity> getInventoryDB(String email) async {
    try {
      RemoteDataSources remoteDataSources = RemoteDataSources();
      InventoryModel inventoryModel =
          await remoteDataSources.getInventoryDB(email);

      InventoryEntity inventoryEntity = inventoryModel;
      return inventoryEntity;
    } catch (e) {
      InventoryEntity inventoryEntity =
          InventoryEntity(listItemsToSell: [], listInventory: []);
      return inventoryEntity;
    }
  }

  Future<Either<Failure, bool>> buyItem(int indexItem) async {
    try {
      RemoteDataSources remoteDataSources = RemoteDataSources();
      bool yesNo = false;
      final res = await remoteDataSources.buyItem(indexItem);
      res.fold((l) => GeneralFailure(), (r) => yesNo = r);
      return Right(yesNo);
    } catch (e) {
      return Left(GeneralFailure());
    }
  }
}
