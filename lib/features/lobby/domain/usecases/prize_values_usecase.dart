import 'package:catchfish/features/lobby/data/repositories/get_prize_values_repository_impl.dart';
import 'package:catchfish/features/lobby/domain/entities/prize_values_entity.dart';

class PrizeValuesUsecase {
  Future<PrizeValuesEntity> getPrizeValues(
    String email,
  ) async {
    GetPrizeValuesRepositoryImpl getPrizeValuesRepositoryImpl =
        GetPrizeValuesRepositoryImpl();
    return await getPrizeValuesRepositoryImpl.getPrizeValuesDB(email);
  }

  savePrizeValues(String email, PrizeValuesEntity prizeValuesEntity) async {
    GetPrizeValuesRepositoryImpl getPrizeValuesRepositoryImpl =
        GetPrizeValuesRepositoryImpl();
    getPrizeValuesRepositoryImpl.savePrizeValuesDB(email, prizeValuesEntity);
  }
}
