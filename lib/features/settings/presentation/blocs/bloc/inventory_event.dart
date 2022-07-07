part of 'inventory_bloc.dart';

abstract class InventoryEvent extends Equatable {
  const InventoryEvent();

  @override
  List<Object> get props => [];
}

class EnteringInventoryEvent extends InventoryEvent {}

// ignore: must_be_immutable
class BuyingItemEvent extends InventoryEvent {
  int indexItem;
  BuyingItemEvent({required this.indexItem});
}
