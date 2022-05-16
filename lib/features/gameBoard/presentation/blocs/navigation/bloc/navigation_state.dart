part of 'navigation_bloc.dart';

abstract class NavigationState extends Equatable {
  const NavigationState();

  @override
  List<Object> get props => [];
}

class NavigationInitial extends NavigationState {}

class EnteringNavigationState extends NavigationState {}

class ShowMapState extends NavigationState {}

class LeavingNavigationState extends NavigationState {}