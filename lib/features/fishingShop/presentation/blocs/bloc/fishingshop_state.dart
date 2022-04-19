part of 'fishingshop_bloc.dart';

abstract class FishingshopState extends Equatable {
  const FishingshopState();

  @override
  List<Object> get props => [];
}

class FishingshopInitial extends FishingshopState {}

class EnteringShopState extends FishingshopState {
  late RetreiveInventoryEntity retreiveInventoryEntity;
  EnteringShopState({required this.retreiveInventoryEntity});
}
