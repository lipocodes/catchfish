part of 'inventory_bloc.dart';

abstract class InventoryState extends Equatable {
  const InventoryState();

  @override
  List<Object> get props => [];
}

class InventoryInitial extends InventoryState {}

class EnteringInventoryState extends InventoryState {
  final InventoryEntity inventoryEntity;
  const EnteringInventoryState({required this.inventoryEntity});
  @override
  List<Object> get props => [inventoryEntity];
}
