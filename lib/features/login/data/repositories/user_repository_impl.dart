import 'package:catchfish/features/login/data/datasources/user_details_remote_datasource.dart';
import 'package:catchfish/features/login/domain/entities/user_entity.dart';
import 'package:catchfish/features/login/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  @override
  saveUserToDB(UserEntity userEntity) {
    UserDetailsRemoteDataSource userDetailsRemoteDataSource =
        UserDetailsRemoteDataSource();
    userDetailsRemoteDataSource.saveUserToDB(userEntity);
  }
}
