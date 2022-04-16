import 'package:catchfish/core/errors/failures.dart';
import 'package:catchfish/features/login/domain/entities/user_entity.dart';

abstract class UserRepository {
  saveUserToDB(UserEntity userEntity);
}
