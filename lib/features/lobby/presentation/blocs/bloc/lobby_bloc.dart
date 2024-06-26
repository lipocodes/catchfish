import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:catchfish/core/consts/daily_prizes.dart';
import 'package:catchfish/core/utils/play_sound.dart';
import 'package:catchfish/features/lobby/domain/entities/prize_values_entity.dart';
import 'package:catchfish/features/lobby/domain/usecases/prize_values_usecase.dart';
import 'package:catchfish/features/settings/domain/usecases/inventory_usecases.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'lobby_event.dart';
part 'lobby_state.dart';

class LobbyBloc extends Bloc<LobbyEvent, LobbyState> {
  late PlaySound playSound;
  bool isLoggedIn = false;

  comparePrefsToDBPrizeList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final FirebaseAuth auth = FirebaseAuth.instance;
    String email = "";
    if (auth.currentUser != null) {
      email = auth.currentUser!.email!;
      PrizeValuesUsecase prizeValuesUsecase = PrizeValuesUsecase();
      PrizeValuesEntity prizeValuesEntity =
          await prizeValuesUsecase.getPrizeValues(
        email,
      );

      int lastPrizeValuesUpdatePrefs = prefs.getInt(
            "lastPrizeValuesUpdatePrefs",
          ) ??
          0;

      //if prize values on DN are fresher than prize values in Prefs

      if (prizeValuesEntity.lastPrizeValuesUpdateDB >=
          lastPrizeValuesUpdatePrefs) {
        //if user is logged in && DB data is newer, update prefs
        await prefs.setInt("inventoryMoney", prizeValuesEntity.inventoryMoney);

        await prefs.setInt("inventoryBaits", prizeValuesEntity.inventoryBaits);
        await prefs.setInt("inventoryXP", prizeValuesEntity.inventoryXP);
        await prefs.setInt("lastPrizeValuesUpdatePrefs",
            prizeValuesEntity.lastPrizeValuesUpdateDB);
      } else if (prizeValuesEntity.lastPrizeValuesUpdateDB <
          lastPrizeValuesUpdatePrefs) {
        int inventoryMoney = prefs.getInt("inventoryMoney") ?? 0;
        int inventoryBaits = prefs.getInt("inventoryBaits") ?? 0;
        int inventoryXP = prefs.getInt("inventoryXP") ?? 0;
        PrizeValuesEntity prizeValuesEntity = PrizeValuesEntity(
            inventoryMoney: inventoryMoney,
            inventoryBaits: inventoryBaits,
            inventoryXP: inventoryXP,
            lastPrizeValuesUpdateDB: lastPrizeValuesUpdatePrefs);
        await prizeValuesUsecase.savePrizeValues(email, prizeValuesEntity);
      }
    }
  }

  comparePrefsToDBEquipmentList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final FirebaseAuth auth = FirebaseAuth.instance;
    String email = "";
    if (auth.currentUser != null) {
      email = auth.currentUser!.email!;
      InventoryUsecases inventoryUsecases = InventoryUsecases();

      await inventoryUsecases.getInventoryDB(email);
    }
  }

  LobbyBloc() : super(LobbyInitial()) {
    on<LobbyEvent>((event, emit) async {
      if (event is EnteringLobbyEvent) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        final FirebaseAuth auth = FirebaseAuth.instance;
        String email = "";
        //When  entering the lobby, if user is logged in - compare prize list && inventory between DB & prefs.
        //if data on DB is newer, update it
        //id data on prefs is newer, update the DB
        await comparePrefsToDBPrizeList();

        await comparePrefsToDBEquipmentList();
        int inventoryMoney = prefs.getInt("inventoryMoney") ?? 0;
        int inventoryBaits = prefs.getInt("inventoryBaits") ?? 0;
        int inventoryXP = prefs.getInt("inventoryXP") ?? 0;
        int playerLevel = prefs.getInt("playerLevel") ?? 0;

        if (auth.currentUser == null) {
          isLoggedIn = false;
        } else {
          isLoggedIn = true;
        }

        playSound = PlaySound();

        playSound.play(path: "assets/sounds/lobby/", fileName: "waves.mp3");
        int dayLastRotation = prefs.getInt("dayLastCompassRotation") ?? 0;

        emit(EnteringLobbyState(
            hasRotatedTodayYet:
                DateTime.now().day == dayLastRotation ? true : false,
            inventoryMoney: inventoryMoney,
            inventoryBaits: inventoryBaits,
            inventoryXP: inventoryXP,
            isLoggedIn: isLoggedIn));
      } else if (event is ReturningLobbyEvent) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        final FirebaseAuth auth = FirebaseAuth.instance;
        String email = "";
        //When  entering the lobby, if user is logged in - compare prize list && inventory between DB & prefs.
        //if data on DB is newer, update it
        //id data on prefs is newer, update the DB
        await comparePrefsToDBPrizeList();
        await comparePrefsToDBEquipmentList();

        int inventoryMoney = prefs.getInt("inventoryMoney") ?? 0;

        int inventoryBaits = prefs.getInt("inventoryBaits") ?? 0;
        int inventoryXP = prefs.getInt("inventoryXP") ?? 0;
        int playerLevel = prefs.getInt("playerLevel") ?? 0;

        if (auth.currentUser == null) {
          isLoggedIn = false;
        } else {
          isLoggedIn = true;
        }

        playSound = PlaySound();

        playSound.play(path: "assets/sounds/lobby/", fileName: "waves.mp3");
        int dayLastRotation = prefs.getInt("dayLastCompassRotation") ?? 0;
        emit(ReturningLobbyState(
            hasRotatedTodayYet:
                DateTime.now().day == dayLastRotation ? true : false,
            inventoryMoney: inventoryMoney,
            inventoryBaits: inventoryBaits,
            inventoryXP: inventoryXP,
            playerLevel: 3));
      } else if (event is LeavingLobbyEvent) {
        playSound.stop();
        emit(LeavingLobbyState());
      } else if (event is RotateCompassEvent) {
        emit(RotateCompassState());
      } else if (event is EndRotateCompassEvent) {
        playSound = PlaySound();
        playSound.play(path: "assets/sounds/lobby/", fileName: "applause.mp3");
        int randomIndex = Random().nextInt(dailyPrizes.length);
        int randomSum = Random().nextInt(10);

        SharedPreferences prefs = await SharedPreferences.getInstance();
        //save the day when last rotated the compass
        int dayLastCompassRotation = DateTime.now().day;
        await prefs.setInt("dayLastCompassRotation", dayLastCompassRotation);

        int inventoryMoney = prefs.getInt("inventoryMoney") ?? 0;
        if (randomIndex == 0) {
          inventoryMoney += randomSum;
          prefs.setInt("inventoryMoney", inventoryMoney);
        }
        int inventoryBaits = prefs.getInt("inventoryBaits") ?? 0;
        if (randomIndex == 1) {
          inventoryBaits += randomSum;
          prefs.setInt("inventoryBaits", inventoryBaits);
        }
        int inventoryXP = prefs.getInt("inventoryXP") ?? 0;
        if (randomIndex == 2) {
          inventoryXP += randomSum;
          prefs.setInt("inventoryXP", inventoryXP);
        }
        final FirebaseAuth auth = FirebaseAuth.instance;
        String email = "";

        if (auth.currentUser == null) {
          isLoggedIn = false;
        } else {
          if (auth.currentUser!.email != null) {
            email = auth.currentUser!.email!;
          }
          isLoggedIn = true;
          //update DB about new prizes values
          var lastPrizeValuesUpdateDB = DateTime.now().millisecondsSinceEpoch;

          PrizeValuesEntity prizeValuesEntity = PrizeValuesEntity(
              inventoryMoney: inventoryMoney,
              inventoryBaits: inventoryBaits,
              inventoryXP: inventoryXP,
              lastPrizeValuesUpdateDB: lastPrizeValuesUpdateDB);
          PrizeValuesUsecase prizeValuesUsecase = PrizeValuesUsecase();
          prizeValuesUsecase.savePrizeValues(email, prizeValuesEntity);
        }
        emit(EndRotateCompassState(
            dailyPrize: dailyPrizes[randomIndex],
            inventoryMoney: inventoryMoney,
            inventoryBaits: inventoryBaits,
            inventoryXP: inventoryXP,
            isLoggedIn: isLoggedIn));
      }
    });
  }
}
