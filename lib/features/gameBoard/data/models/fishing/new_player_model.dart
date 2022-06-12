import 'package:catchfish/features/gameBoard/domain/entities/fishing/new_player_entity.dart';

class NewPlayerModel extends NewPlayerEntity {
  String playerName;
  String image;
  List caughtFish;
  NewPlayerModel(
      {required this.playerName, required this.image, required this.caughtFish})
      : super(playerName: playerName, image: image, caughtFish: caughtFish);

  factory NewPlayerModel.fromJson(Map<String, dynamic> json) {
    return NewPlayerModel(
        playerName: json['playerName'],
        image: json['image'],
        caughtFish: json['caughtFish']);
  }
  Map<String, dynamic> toJson() {
    return {
      'playerName': playerName,
      'image': image,
      'caughtFish': caughtFish,
    };
  }
}
