import 'package:catchfish/features/lobby/domain/entities/prize_values_entity.dart';

abstract class GetPrizeValuesRepository {
  Future<PrizeValuesEntity> getPrizeValuesDB(String email);
  savePrizeValuesDB(String email, PrizeValuesEntity prizeValuesEntity);
}
