part of 'fishingshop_bloc.dart';

abstract class FishingshopState extends Equatable {
  const FishingshopState();

  @override
  List<Object> get props => [];
}

class FishingshopInitial extends FishingshopState {}

class EnteringShopState extends FishingshopState {
  late RetreivePrizeEntity retreivePrizeEntity;
  EnteringShopState({required this.retreivePrizeEntity});
}
