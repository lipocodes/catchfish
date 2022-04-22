import 'package:catchfish/features/fishingShop/data/repositories/buy_item_with_money_prize_impl.dart';
import 'package:catchfish/features/fishingShop/domain/entities/retreive_prize_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BuyItemWithMoneyPrizeUsecase {
  Future<RetreivePrizeEntity> buyItem(
      String id, String image, String title, int price) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    String email = "";
    if (auth.currentUser != null) {
      email = auth.currentUser!.email!;
    } else {
      email = "";
    }

    BuyItemWithPrizeMoneyImpl buyItemWithPrizeMoneyImpl =
        BuyItemWithPrizeMoneyImpl();
    RetreivePrizeEntity retreivePrizeEntity =
        await buyItemWithPrizeMoneyImpl.buyItemm(id, image, title, price);
    return retreivePrizeEntity;
  }
}
