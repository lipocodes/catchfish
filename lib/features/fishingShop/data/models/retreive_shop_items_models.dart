import 'package:catchfish/features/fishingShop/domain/entities/retreive_shop_items_entity.dart';

class RetreiveShopItemsModels extends RetreiveShopItemsEntity {
  RetreiveShopItemsModels(
      {required String id,
      required String image,
      required String title,
      required String subtitle,
      required int price})
      : super(
            id: id,
            image: image,
            title: title,
            subtitle: subtitle,
            price: price);
}
