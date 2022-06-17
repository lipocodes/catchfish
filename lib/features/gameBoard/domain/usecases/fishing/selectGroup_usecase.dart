import 'package:catchfish/core/errors/failures.dart';
import 'package:catchfish/core/usecases/usecase.dart';
import 'package:catchfish/features/gameBoard/domain/entities/fishing/list_group.dart';
import 'package:catchfish/features/gameBoard/domain/entities/fishing/pulse_entity.dart';
import 'package:dartz/dartz.dart';

class SelectGroupUsecase extends UseCase<PulseEntity, NoParams> {
  @override
  Future<Either<Failure, PulseEntity>> call(NoParams params) {
    // TODO: implement call
    throw UnimplementedError();
  }

  Future<Either<Failure, ListGroup>> retreiveListGroups() async {
    try {
      List<String> listGroups = [
        "Group1",
        "Group2",
        "Group3",
        "Group4",
        "Group5",
        "Group6",
        "Group7"
      ];
      ListGroup list = ListGroup(list: listGroups);
      return Right(list);
    } catch (e) {
      return Left(GeneralFailure());
    }
  }
}
