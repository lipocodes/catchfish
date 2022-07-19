import 'package:catchfish/features/gameBoard/domain/entities/fishing/mutipleplayer_entity.dart';

class MultipleplayerModel extends MultipleplayerEntity {
  MultipleplayerModel(
      {required int timeTillStartGame, required List playersInGroup})
      : super(
            timeTillStartGame: timeTillStartGame,
            playersInGroup: playersInGroup);
}
