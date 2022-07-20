import 'package:bloc/bloc.dart';
import 'package:catchfish/features/gameBoard/data/repositories/select_group_repository_impl.dart';
import 'package:catchfish/features/gameBoard/domain/entities/fishing/mutipleplayer_entity.dart';
import 'package:catchfish/features/gameBoard/domain/usecases/fishing/selectGroup_usecase.dart';
import 'package:catchfish/injection_container.dart';
import 'package:equatable/equatable.dart';

part 'lobby_multiplayer_game_event.dart';
part 'lobby_multiplayer_game_state.dart';

class LobbyMultiplayerGameBloc
    extends Bloc<LobbyMultiplayerGameEvent, LobbyMultiplayerGameState> {
  LobbyMultiplayerGameBloc() : super(LobbyMultiplayerGameInitial()) {
    on<LobbyMultiplayerGameEvent>((event, emit) async {
      if (event is JoinMultipleplayerGameEvent) {
        SelectGroupUsecase selectGroupUsecase = sl.get<SelectGroupUsecase>();
        SelectGroupRepositoryImpl selectGroupRepositoryImpl =
            sl.get<SelectGroupRepositoryImpl>();

        final res = await selectGroupUsecase.joinMultiplayerGame(
            selectGroupRepositoryImpl: selectGroupRepositoryImpl);
        bool yesNo = false;
        res.fold(
          (failure) => emit(ErrorUpdateMultipleplayerGameState()),
          (success) => yesNo = success,
        );
        emit(JoinMultipleplayerGameState(successful: yesNo));
      } else if (event is GetUpdateMultipleplayerGameEvent) {
        SelectGroupUsecase selectGroupUsecase = sl.get<SelectGroupUsecase>();
        SelectGroupRepositoryImpl selectGroupRepositoryImpl =
            sl.get<SelectGroupRepositoryImpl>();
        final res = await selectGroupUsecase.getUpdateMyltiplayerGame(
            selectGroupRepositoryImpl: selectGroupRepositoryImpl);
        late MultipleplayerEntity multipleplayerEntity;
        res.fold(
          (failure) => emit(ErrorUpdateMultipleplayerGameState()),
          (entity) => multipleplayerEntity = entity,
        );
        emit(GetUpdateMultipleplayerGameState(
            multipleplayerEntity: multipleplayerEntity));
      } else if (event is QuitMultipleplayerGameEvent) {
        SelectGroupUsecase selectGroupUsecase = sl.get<SelectGroupUsecase>();
        SelectGroupRepositoryImpl selectGroupRepositoryImpl =
            sl.get<SelectGroupRepositoryImpl>();

        final res = await selectGroupUsecase.quitMultiplayerGame(
            selectGroupRepositoryImpl: selectGroupRepositoryImpl);
        bool yesNo = false;
        res.fold(
          (failure) => emit(ErrorUpdateMultipleplayerGameState()),
          (success) => yesNo = success,
        );
        emit(QuitMultipleplayerGameState(successful: yesNo));
      } else if (event is NeutralEvent) {
        emit(NeutralState());
      }
    });
  }
}
