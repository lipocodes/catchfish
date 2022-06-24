import 'package:catchfish/features/gameBoard/data/datasources/fishing/remote_datasource.dart';
import 'package:catchfish/features/gameBoard/data/models/fishing/list_group_model.dart';
import 'package:catchfish/features/gameBoard/data/models/fishing/new_player_model.dart';
import 'package:catchfish/features/gameBoard/data/repositories/fishing_repository_impl.dart';
import 'package:catchfish/features/gameBoard/data/repositories/select_group_repository_impl.dart';
import 'package:catchfish/features/gameBoard/domain/entities/fishing/caught_fish_entity.dart';
import 'package:catchfish/features/gameBoard/domain/usecases/fishing/fishing_usecase.dart';
import 'package:catchfish/features/gameBoard/domain/usecases/fishing/selectGroup_usecase.dart';
import 'package:catchfish/features/gameBoard/presentation/blocs/fishing/fishingBloc/fishing_bloc.dart';
import 'package:catchfish/features/gameBoard/presentation/blocs/fishing/selectGroupBloc/selectgroup_bloc.dart';
import 'package:get_it/get_it.dart';

import 'features/gameBoard/data/datasources/fishing/local_datasource.dart';

final sl = GetIt.instance;

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
  //local & remote datasource
  sl.registerLazySingleton<LocalDatasourcePrefs>(() => LocalDatasourcePrefs());
  sl.registerLazySingleton<RemoteDatasource>(() => RemoteDatasource());
  //repository Impl
  sl.registerLazySingleton<FishingRepositoryImpl>(
      () => FishingRepositoryImpl());
  sl.registerLazySingleton<SelectGroupRepositoryImpl>(
      () => SelectGroupRepositoryImpl());
  //entities
  sl.registerLazySingleton<CaughtFishEntity>(
      () => CaughtFishEntity(isFishCaught: true, caughtFishDetails: ""));
  //models
  sl.registerLazySingleton<NewPlayerModel>(() => NewPlayerModel(
      playerName: "", image: "", caughtFish: [], timeLastCaughtFish: 0));
  sl.registerLazySingleton<ListGroupModel>(() => ListGroupModel(list: []));

  return true;
}
