import 'package:bloc/bloc.dart';
import 'package:catchfish/features/fishingShop/domain/entities/retreive_prize_entity.dart';
import 'package:catchfish/features/fishingShop/domain/usecases/retreive_prize_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'fishingshop_event.dart';
part 'fishingshop_state.dart';

class FishingshopBloc extends Bloc<FishingshopEvent, FishingshopState> {
  late RetreivePrizeEntity retreivePrizeEntity;
  FishingshopBloc() : super(FishingshopInitial()) {
    on<FishingshopEvent>((event, emit) async {
      if (event is EnteringShopEvent) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        final FirebaseAuth auth = FirebaseAuth.instance;
        String email = "";
        if (auth.currentUser != null) {
          email = auth.currentUser!.email!;
          RetreivePrizeUsecase retreivePrizeUsecase = RetreivePrizeUsecase();
          retreivePrizeEntity = await retreivePrizeUsecase.getPrize();
          emit(EnteringShopState(retreivePrizeEntity: retreivePrizeEntity));
        }
      }
    });
  }
}
