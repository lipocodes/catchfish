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
  final RetreivePrizeEntity retreivePrizeEntity;

  const BuyItemWithMoneyPrizeState({required this.retreivePrizeEntity});
}
