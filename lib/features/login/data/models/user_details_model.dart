import 'package:catchfish/features/login/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel(
      {required String displayName,
      required String email,
      required String photoURL,
      required String phoneNumber})
      : super(
            displayName: displayName,
            email: email,
            photoURL: photoURL,
            phoneNumber: phoneNumber);
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        displayName: json['displayName'],
        email: json['email'],
        photoURL: json['photoURL'],
        phoneNumber: json['phoneNumber']);
  }
  Map<String, dynamic> toJson() {
    return {
      'displayName': displayName,
      'email': email,
      'photoURL': photoURL,
      'phoneNumber': phoneNumber
    };
  }
}
