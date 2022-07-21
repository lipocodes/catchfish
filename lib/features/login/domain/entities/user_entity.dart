import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  String displayName;
  String email;
  String photoURL;
  String phoneNumber;
  UserEntity(
      {required this.displayName,
      required this.email,
      required this.photoURL,
      required this.phoneNumber});

  @override
  // TODO: implement props
  List<Object?> get props => [displayName, email, photoURL, phoneNumber];
}
