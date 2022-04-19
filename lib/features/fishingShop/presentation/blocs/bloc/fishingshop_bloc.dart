import 'package:bloc/bloc.dart';
import 'package:catchfish/features/fishingShop/domain/entities/retreive_inventory_entity.dart';
import 'package:catchfish/features/lobby/domain/usecases/retreiveInventoryUsecase.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'fishingshop_event.dart';
part 'fishingshop_state.dart';

class FishingshopBloc extends Bloc<FishingshopEvent, FishingshopState> {
  late RetreiveInventoryEntity retreiveInventoryEntity;
  FishingshopBloc() : super(FishingshopInitial()) {
    on<FishingshopEvent>((event, emit) async {
      if (event is EnteringShopEvent) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        final FirebaseAuth auth = FirebaseAuth.instance;
        String email = "";
        if (auth.currentUser != null) {
          email = auth.currentUser!.email!;
          RetreiveInventoryUsecase retreiveInventoryUsecase =
              RetreiveInventoryUsecase();
          retreiveInventoryEntity =
              await retreiveInventoryUsecase.getInventory();
          emit(EnteringShopState(
              retreiveInventoryEntity: retreiveInventoryEntity));
        }
      }
    });
  }
}
