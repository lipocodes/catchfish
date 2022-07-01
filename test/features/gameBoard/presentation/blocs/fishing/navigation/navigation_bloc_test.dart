import 'package:catchfish/features/gameBoard/data/repositories/navigation_repository_impl.dart';
import 'package:catchfish/features/gameBoard/domain/usecases/navigation/navigation_usecases.dart';
import 'package:catchfish/features/gameBoard/presentation/blocs/navigation/bloc/navigation_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:catchfish/injection_container.dart' as di;
import 'package:mockito/mockito.dart';

import 'navigation_bloc_test.mocks.dart';

@GenerateMocks([NavigationUsecases])
void main() {
  NavigationBloc navigationBloc = NavigationBloc();
  MockNavigationUsecases mockNavigationUsecases = MockNavigationUsecases();
  NavigationRepositoryImpl navigationRepositoryImpl =
      NavigationRepositoryImpl();
  tearDown(() {});
  group("Testing BLOC NavigationBloc", () {
    di.init();
    WidgetsFlutterBinding.ensureInitialized();
    test('testing LeavingNavigationEvent()', () {
      when(mockNavigationUsecases.givePrizeNavigation(navigationRepositoryImpl))
          .thenAnswer((_) async => const Right(true));
      navigationBloc.add(
          LeavingNavigationEvent(navigationUsecases: mockNavigationUsecases));
      expectLater(
          navigationBloc.stream,
          emitsInAnyOrder([
            LeavingNavigationState(),
          ]));
    });
  });
}
