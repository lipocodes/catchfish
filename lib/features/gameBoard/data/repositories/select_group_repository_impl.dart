import 'package:catchfish/core/errors/failures.dart';
import 'package:catchfish/features/gameBoard/data/models/fishing/list_group_model.dart';
import 'package:catchfish/features/gameBoard/domain/repositories/fishing/select_group_repository.dart';
import 'package:dartz/dartz.dart';

class SelectGroupRepositoryImpl implements SelectGroupRepository {
  @override
  Future<Either<Failure, ListGroupModel>> retreiveListGroups() async {
    List<String> listGroups = [
      "Group1",
      "Group2",
      "Group3",
      "Group4",
      "Group5",
      "Group6",
      "Group7"
    ];
    try {
      ListGroupModel listGroupModel = ListGroupModel(list: listGroups);

      return Right(listGroupModel);
    } catch (e) {
      return Left(GeneralFailure());
    }
  }
}
