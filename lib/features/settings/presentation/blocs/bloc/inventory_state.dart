part of 'inventory_bloc.dart';

abstract class InventoryState extends Equatable {
  const InventoryState();

  @override
  List<Object> get props => [];
}

class InventoryInitial extends InventoryState {}

class EnteringInventoryState extends InventoryState {
  final InventoryScreenEntity inventoryScreenEntity;
  const EnteringInventoryState({required this.inventoryScreenEntity});
  @override
  List<Object> get props => [inventoryScreenEntity];
}
