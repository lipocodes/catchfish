import 'package:bloc/bloc.dart';
import 'package:catchfish/core/utils/play_sound.dart';
import 'package:catchfish/features/fishingShop/domain/entities/retreive_prize_entity.dart';
import 'package:catchfish/features/fishingShop/domain/usecases/retreive_prize_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'fishingshop_event.dart';
part 'fishingshop_state.dart';

class FishingshopBloc extends Bloc<FishingshopEvent, FishingshopState> {
  bool isLoggedIn = false;
  FishingshopBloc() : super(FishingshopInitial()) {
    on<FishingshopEvent>((event, emit) async {
      if (event is EnteringShopEvent) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        final FirebaseAuth auth = FirebaseAuth.instance;
        String email = "";
        if (auth.currentUser != null) {
          email = auth.currentUser!.email!;

          RetreivePrizeUsecase retreivePrizeUsecase = RetreivePrizeUsecase();
          RetreivePrizeEntity retreivePrizeEntity =
              await retreivePrizeUsecase.getPrize(email);
          int lastPrizeValuesUpdatePrefs = prefs.getInt(
                "lastPrizeValuesUpdatePrefs",
              ) ??
              0;
          //if prize values on DN are fresher than prize values in Prefs
          //if user is logged in && DB data is newer, update prefs

          if (retreivePrizeEntity.lastPrizeValuesUpdateDB >
              lastPrizeValuesUpdatePrefs) {
            await prefs.setInt(
                "inventoryMoney", retreivePrizeEntity.inventoryMoney);
            await prefs.setInt(
                "inventoryBaits", retreivePrizeEntity.inventoryBaits);
            await prefs.setInt("inventoryXP", retreivePrizeEntity.inventoryXP);
            await prefs.setInt("lastPrizeValuesUpdateDB",
                retreivePrizeEntity.lastPrizeValuesUpdateDB);
          }
        }
        //if user is not logged in, user gets old prefs values
        int inventoryMoney = prefs.getInt("inventoryMoney") ?? 0;
        int inventoryBaits = prefs.getInt("inventoryBaits") ?? 0;
        int inventoryXP = prefs.getInt("inventoryXP") ?? 0;
        int lastPrizeValuesUpdateDB =
            prefs.getInt("lastPrizeValuesUpdateDB") ?? 0;
        if (auth.currentUser == null) {
          isLoggedIn = false;
        } else {
          isLoggedIn = true;
        }

        RetreivePrizeEntity retreivePrizeEntity = RetreivePrizeEntity(
          inventoryMoney: inventoryMoney,
          inventoryBaits: inventoryBaits,
          inventoryXP: inventoryXP,
          lastPrizeValuesUpdateDB: lastPrizeValuesUpdateDB,
        );

        emit(EnteringShopState(retreivePrizeEntity: retreivePrizeEntity));
      }
    });
  }
}
