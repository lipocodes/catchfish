import 'package:catchfish/features/gameBoard/domain/usecases/fishing/fishing_usecase.dart';
import 'package:catchfish/features/gameBoard/presentation/blocs/fishing/bloc/fishing_bloc.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<bool> init() async {
  //Bloc: not singleton
  sl.registerFactory<FishingBloc>(
    () => FishingBloc(),
  );
  // Use cases
  sl.registerLazySingleton<FishingUsecase>(() => FishingUsecase());

  return true;
}
