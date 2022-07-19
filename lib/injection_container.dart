import 'package:catchfish/features/gameBoard/data/datasources/fishing/remote_datasource.dart';
import 'package:catchfish/features/gameBoard/data/datasources/navigation/navigation_local_datasource.dart';
import 'package:catchfish/features/gameBoard/data/datasources/navigation/navigation_remote_datasource.dart';
import 'package:catchfish/features/gameBoard/data/models/fishing/list_group_model.dart';
import 'package:catchfish/features/gameBoard/data/models/fishing/new_player_model.dart';
import 'package:catchfish/features/gameBoard/data/repositories/fishing_repository_impl.dart';
import 'package:catchfish/features/gameBoard/data/repositories/navigation_repository_impl.dart';
import 'package:catchfish/features/gameBoard/data/repositories/select_group_repository_impl.dart';
import 'package:catchfish/features/gameBoard/domain/entities/fishing/caught_fish_entity.dart';
import 'package:catchfish/features/gameBoard/domain/entities/fishing/mutipleplayer_entity.dart';
import 'package:catchfish/features/gameBoard/domain/usecases/fishing/fishing_usecase.dart';
import 'package:catchfish/features/gameBoard/domain/usecases/fishing/selectGroup_usecase.dart';
import 'package:catchfish/features/gameBoard/domain/usecases/navigation/navigation_usecases.dart';
import 'package:catchfish/features/gameBoard/presentation/blocs/fishing/fishingBloc/fishing_bloc.dart';
import 'package:catchfish/features/gameBoard/presentation/blocs/fishing/selectGroupBloc/selectgroup_bloc.dart';
import 'package:get_it/get_it.dart';

import 'features/gameBoard/data/datasources/fishing/local_datasource.dart';

final sl = GetIt.instance;

sendSMS() async {}

Future<bool> init() async {
  //Bloc: not singleton
  sl.registerFactory<FishingBloc>(
    () => FishingBloc(),
  );
  sl.registerFactory<SelectgroupBloc>(
    () => SelectgroupBloc(),
  );
  // Use cases
  sl.registerLazySingleton<FishingUsecase>(() => FishingUsecase());
  sl.registerLazySingleton<SelectGroupUsecase>(() => SelectGroupUsecase());
  sl.registerLazySingleton<NavigationUsecases>(() => NavigationUsecases());
  //local & remote datasource
  sl.registerLazySingleton<LocalDatasourcePrefs>(() => LocalDatasourcePrefs());
  sl.registerLazySingleton<RemoteDatasource>(() => RemoteDatasource());
  sl.registerLazySingleton<NavigationLocalDatasource>(
      () => NavigationLocalDatasource());
  sl.registerLazySingleton<NavigationRemoteDatasource>(
      () => NavigationRemoteDatasource());
  //repository Impl
  sl.registerLazySingleton<FishingRepositoryImpl>(
      () => FishingRepositoryImpl());
  sl.registerLazySingleton<SelectGroupRepositoryImpl>(
      () => SelectGroupRepositoryImpl());
  sl.registerLazySingleton<NavigationRepositoryImpl>(
      () => NavigationRepositoryImpl());
  //entities
  sl.registerLazySingleton<CaughtFishEntity>(
      () => CaughtFishEntity(isFishCaught: true, caughtFishDetails: ""));
  sl.registerLazySingleton<MultipleplayerEntity>(
      () => MultipleplayerEntity(timeTillStartGame: 100, playersInGroup: []));
  //models
  sl.registerLazySingleton<NewPlayerModel>(() => NewPlayerModel(
      playerName: "", image: "", caughtFish: [], timeLastCaughtFish: 0));
  sl.registerLazySingleton<ListGroupModel>(() => ListGroupModel(list: []));

  return true;
}
