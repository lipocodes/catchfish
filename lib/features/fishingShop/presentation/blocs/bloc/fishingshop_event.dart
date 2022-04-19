part of 'fishingshop_bloc.dart';

abstract class FishingshopEvent extends Equatable {
  const FishingshopEvent();

  @override
  List<Object> get props => [];
}

class EnteringShopEvent extends FishingshopEvent {}
