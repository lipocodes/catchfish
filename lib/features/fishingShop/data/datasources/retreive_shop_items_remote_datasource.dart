import 'package:catchfish/features/fishingShop/data/models/retreive_shop_items_models.dart';

class RetreiveShopItemsRemoteDatasource {
  Future<List<RetreiveShopItemsModels>> getItems() async {
    List<RetreiveShopItemsModels> listItems = [];
    RetreiveShopItemsModels retreiveShopItemsModels = RetreiveShopItemsModels(
        id: "1000",
        image:
            "https://th.bing.com/th/id/R.b270ad7dbc44160820f37af132c0c31d?rik=3YK43kYXrsby8w&pid=ImgRaw&r=0",
        title: "Xcite Baits",
        subtitle: "On discount",
        quantity: 20,
        price: 8.50);
    listItems.add(retreiveShopItemsModels);
    return listItems;
  }
}
