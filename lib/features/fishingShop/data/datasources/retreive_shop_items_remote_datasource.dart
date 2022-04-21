import 'package:catchfish/features/fishingShop/data/models/retreive_shop_items_models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RetreiveShopItemsRemoteDatasource {
  Future<List<RetreiveShopItemsModels>> getItems() async {
    List<RetreiveShopItemsModels> listItems = [];

    try {
      var t = await FirebaseFirestore.instance.collection("fishingShop").get();
      for (int a = 0; a < t.docs.length; a++) {
        String id = t.docs[a].data()['id'];
        String image = t.docs[a].data()['image'];
        String title = t.docs[a].data()['title'];
        String subtitle = t.docs[a].data()['subtitle'];
        //int quantity = t.docs[a].data()['quantity'];
        double price = 0.0;
        if (t.docs[a].data()['price'].runtimeType != double) {
          int intVar = t.docs[a].data()['price'];
          price = intVar.toDouble();
        } else {
          price = t.docs[a].data()['price'];
        }

        RetreiveShopItemsModels retreiveShopItemsModels =
            RetreiveShopItemsModels(
                id: id,
                image: image,
                title: title,
                subtitle: subtitle,
                // quantity: quantity,
                price: price);
        listItems.add(retreiveShopItemsModels);
      }
    } catch (e) {
      print("eeeeeeeeeeeeeeeee=" + e.toString());
    }
    return listItems;
  }
}
