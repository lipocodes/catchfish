import 'package:bloc/bloc.dart';
import 'package:catchfish/core/errors/failures.dart';
import 'package:catchfish/core/utils/play_sound.dart';
import 'package:catchfish/features/settings/domain/entities/inventory_entity.dart';
import 'package:catchfish/features/settings/domain/entities/inventory_screen_entity.dart';
import 'package:catchfish/features/settings/domain/usecases/inventory_usecases.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'inventory_event.dart';
part 'inventory_state.dart';

class InventoryBloc extends Bloc<InventoryEvent, InventoryState> {
  InventoryBloc() : super(InventoryInitial()) {
    on<InventoryEvent>((event, emit) async {
      if (event is EnteringInventoryEvent) {
        /*PlaySound playSound = PlaySound();
        playSound.play(
          path: "assets/sounds/settings/",
          fileName: "bubbles.mp3",
        );*/

        final FirebaseAuth auth = FirebaseAuth.instance;
        String email = "";
        if (auth.currentUser != null) {
          email = auth.currentUser!.email!;
          InventoryUsecases inventoryUsecases = InventoryUsecases();
          InventoryScreenEntity inventoryScreenEntity =
              await inventoryUsecases.getInventoryDB(email);

          emit(EnteringInventoryState(
              inventoryScreenEntity: inventoryScreenEntity));
        } else {
          InventoryUsecases inventoryUsecases = InventoryUsecases();
          InventoryScreenEntity inventoryScreenEntity =
              await inventoryUsecases.getInventoryDB(email);
          emit(EnteringInventoryState(
              inventoryScreenEntity: inventoryScreenEntity));
        }
      } else if (event is BuyingItemEvent) {
        final FirebaseAuth auth = FirebaseAuth.instance;
        String email = "";
        if (auth.currentUser != null) {
          email = auth.currentUser!.email!;
          InventoryUsecases inventoryUsecases = InventoryUsecases();
          final res = await inventoryUsecases.buyItem(
              email, event.indexItem, event.quantity);
          bool yesNo = false;
          res.fold((l) => Left(GeneralFailure()), (r) => yesNo = r);
          emit(BuyingItemState(enoughMoney: yesNo));
        } else {
          emit(const BuyingItemState(enoughMoney: false));
        }
      }
    });
  }
}
