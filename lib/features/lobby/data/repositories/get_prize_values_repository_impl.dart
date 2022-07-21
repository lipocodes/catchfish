import 'package:catchfish/features/lobby/data/datasources/get_prize_values_remote_datasource.dart';
import 'package:catchfish/features/lobby/domain/entities/prize_values_entity.dart';
import 'package:catchfish/features/lobby/domain/repositories/get_prize_values_repository.dart';

class GetPrizeValuesRepositoryImpl implements GetPrizeValuesRepository {
  @override
  Future<PrizeValuesEntity> getPrizeValuesDB(String email) async {
    GetPrizeValuesRemoteDatasource getPrizeValuesRemoteDatasource =
        GetPrizeValuesRemoteDatasource();
    return await getPrizeValuesRemoteDatasource.getPrizeValuesDB(email);
  }

  @override
  savePrizeValuesDB(String email, PrizeValuesEntity prizeValuesEntity) async {
    GetPrizeValuesRemoteDatasource getPrizeValuesRemoteDatasource =
        GetPrizeValuesRemoteDatasource();
    await getPrizeValuesRemoteDatasource.savePrizeValuesDB(
        email, prizeValuesEntity);
  }
}
