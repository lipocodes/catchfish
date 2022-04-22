part of 'fishingshop_bloc.dart';

abstract class FishingshopEvent extends Equatable {
  const FishingshopEvent();

  @override
  List<Object> get props => [];
}

class EnteringShopEvent extends FishingshopEvent {}

class RetreiveShopItemsEvent extends FishingshopEvent {}

class BuyItemWithMoneyPrizeEvent extends FishingshopEvent {
  final String id;
  final String image;
  final String title;
  final int price;
  const BuyItemWithMoneyPrizeEvent(
      {required this.id,
      required this.image,
      required this.title,
      required this.price});
}
