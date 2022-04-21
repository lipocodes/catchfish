part of 'fishingshop_bloc.dart';

abstract class FishingshopState extends Equatable {
  const FishingshopState();

  @override
  List<Object> get props => [];
}

class FishingshopInitial extends FishingshopState {}

class EnteringShopState extends FishingshopState {
  final RetreivePrizeEntity retreivePrizeEntity;
  const EnteringShopState({required this.retreivePrizeEntity});
}

class RetreiveShopItemsState extends FishingshopState {
  final List<RetreiveShopItemsEntity> listItems;
  const RetreiveShopItemsState({required this.listItems});
}

class BuyItemWithMoneyPrizeState extends FishingshopState {
  final int inventoryMoney;
  final int inventoryBaits;
  final int inventoryXP;
  const BuyItemWithMoneyPrizeState(
      {required this.inventoryMoney,
      required this.inventoryBaits,
      required this.inventoryXP});
}
