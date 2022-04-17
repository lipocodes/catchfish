import 'package:catchfish/core/errors/failures.dart';
import 'package:catchfish/features/login/data/repositories/user_repository_impl.dart';
import 'package:catchfish/features/login/domain/entities/user_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:dartz/dartz.dart';

//use case: need to save/update user details to DB
class SaveUserDetails {
  call(UserEntity userEntity) async {
    UserRepositoryImpl userRepositoryImpl = UserRepositoryImpl();
    await userRepositoryImpl.saveUserToDB(userEntity);
  }
}
