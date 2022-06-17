import 'package:catchfish/core/errors/failures.dart';
import 'package:catchfish/features/gameBoard/data/datasources/fishing/remote_datasource.dart';
import 'package:catchfish/features/gameBoard/data/models/fishing/list_group_model.dart';
import 'package:catchfish/features/gameBoard/domain/entities/fishing/list_group_entity.dart';
import 'package:dartz/dartz.dart';

abstract class SelectGroupRepository {
  Future<Either<Failure, ListGroupModel>> retreiveListGroups(
      RemoteDatasource remoteDatasource);
}
