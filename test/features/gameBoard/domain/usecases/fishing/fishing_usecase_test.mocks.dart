// Mocks generated by Mockito 5.1.0 from annotations
// in catchfish/test/features/gameBoard/domain/usecases/fishing/fishing_usecase_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i4;

import 'package:catchfish/core/errors/failures.dart' as _i5;
import 'package:catchfish/features/gameBoard/data/datasources/fishing/local_datasource.dart'
    as _i6;
import 'package:catchfish/features/gameBoard/data/datasources/fishing/remote_datasource.dart'
    as _i7;
import 'package:catchfish/features/gameBoard/data/repositories/fishing_repository_impl.dart'
    as _i3;
import 'package:dartz/dartz.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types

class _FakeEither_0<L, R> extends _i1.Fake implements _i2.Either<L, R> {}

/// A class which mocks [FishingRepositoryImpl].
///
/// See the documentation for Mockito's code generation for more information.
class MockFishingRepositoryImpl extends _i1.Mock
    implements _i3.FishingRepositoryImpl {
  MockFishingRepositoryImpl() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<_i2.Either<_i5.Failure, bool>> updateLevel(
          int? newLevel,
          _i6.LocalDatasourcePrefs? localDatasourcePrefs,
          _i7.RemoteDatasource? remoteDatasource) =>
      (super.noSuchMethod(
          Invocation.method(
              #updateLevel, [newLevel, localDatasourcePrefs, remoteDatasource]),
          returnValue: Future<_i2.Either<_i5.Failure, bool>>.value(
              _FakeEither_0<_i5.Failure, bool>())) as _i4
          .Future<_i2.Either<_i5.Failure, bool>>);
  @override
  _i4.Future<_i2.Either<_i5.Failure, int>> getLevelPref(
          _i6.LocalDatasourcePrefs? localDatasourcePrefs,
          _i7.RemoteDatasource? remoteDatasource) =>
      (super.noSuchMethod(
              Invocation.method(
                  #getLevelPref, [localDatasourcePrefs, remoteDatasource]),
              returnValue: Future<_i2.Either<_i5.Failure, int>>.value(
                  _FakeEither_0<_i5.Failure, int>()))
          as _i4.Future<_i2.Either<_i5.Failure, int>>);
  @override
  _i4.Future<_i2.Either<_i5.Failure, List<dynamic>>> getPersonalShop(
          _i6.LocalDatasourcePrefs? localDatasourcePrefs,
          _i7.RemoteDatasource? remoteDatasource) =>
      (super.noSuchMethod(
              Invocation.method(
                  #getPersonalShop, [localDatasourcePrefs, remoteDatasource]),
              returnValue: Future<_i2.Either<_i5.Failure, List<dynamic>>>.value(
                  _FakeEither_0<_i5.Failure, List<dynamic>>()))
          as _i4.Future<_i2.Either<_i5.Failure, List<dynamic>>>);
  @override
  _i4.Future<_i2.Either<_i5.Failure, bool>> removeFishPersonalShop(
          String? fishDetails,
          _i6.LocalDatasourcePrefs? localDatasourcePrefs,
          _i7.RemoteDatasource? remoteDatasource) =>
      (super.noSuchMethod(
              Invocation.method(#removeFishPersonalShop,
                  [fishDetails, localDatasourcePrefs, remoteDatasource]),
              returnValue: Future<_i2.Either<_i5.Failure, bool>>.value(
                  _FakeEither_0<_i5.Failure, bool>()))
          as _i4.Future<_i2.Either<_i5.Failure, bool>>);
  @override
  _i4.Future<_i2.Either<_i5.Failure, bool>> deleteGroup(
          String? groupName, _i7.RemoteDatasource? remoteDatasource) =>
      (super.noSuchMethod(
              Invocation.method(#deleteGroup, [groupName, remoteDatasource]),
              returnValue: Future<_i2.Either<_i5.Failure, bool>>.value(
                  _FakeEither_0<_i5.Failure, bool>()))
          as _i4.Future<_i2.Either<_i5.Failure, bool>>);
  @override
  _i4.Future<_i2.Either<_i5.Failure, bool>> addPlayerToGroup(
          String? groupName, _i7.RemoteDatasource? remoteDatasource) =>
      (super.noSuchMethod(
          Invocation.method(#addPlayerToGroup, [groupName, remoteDatasource]),
          returnValue: Future<_i2.Either<_i5.Failure, bool>>.value(
              _FakeEither_0<_i5.Failure, bool>())) as _i4
          .Future<_i2.Either<_i5.Failure, bool>>);
  @override
  _i4.Future<_i2.Either<_i5.Failure, List<dynamic>>> getPlayersForSelectedGroup(
          String? selectedGroupName, _i7.RemoteDatasource? remoteDatasource) =>
      (super.noSuchMethod(
              Invocation.method(#getPlayersForSelectedGroup,
                  [selectedGroupName, remoteDatasource]),
              returnValue: Future<_i2.Either<_i5.Failure, List<dynamic>>>.value(
                  _FakeEither_0<_i5.Failure, List<dynamic>>()))
          as _i4.Future<_i2.Either<_i5.Failure, List<dynamic>>>);
  @override
  _i4.Future<_i2.Either<_i5.Failure, List<dynamic>>> getExistingGroups(
          _i7.RemoteDatasource? remoteDatasource) =>
      (super.noSuchMethod(
              Invocation.method(#getExistingGroups, [remoteDatasource]),
              returnValue: Future<_i2.Either<_i5.Failure, List<dynamic>>>.value(
                  _FakeEither_0<_i5.Failure, List<dynamic>>()))
          as _i4.Future<_i2.Either<_i5.Failure, List<dynamic>>>);
  @override
  _i4.Future<_i2.Either<_i5.Failure, bool>> updateCaughtFishInGroups(
          String? caughtFishDetails) =>
      (super.noSuchMethod(
              Invocation.method(#updateCaughtFishInGroups, [caughtFishDetails]),
              returnValue: Future<_i2.Either<_i5.Failure, bool>>.value(
                  _FakeEither_0<_i5.Failure, bool>()))
          as _i4.Future<_i2.Either<_i5.Failure, bool>>);
  @override
  _i4.Future<_i2.Either<_i5.Failure, bool>> addFishPersonalShop(
          String? caughtFishDetails) =>
      (super.noSuchMethod(
              Invocation.method(#addFishPersonalShop, [caughtFishDetails]),
              returnValue: Future<_i2.Either<_i5.Failure, bool>>.value(
                  _FakeEither_0<_i5.Failure, bool>()))
          as _i4.Future<_i2.Either<_i5.Failure, bool>>);
  @override
  _i4.Future<_i2.Either<_i5.Failure, List<String>>> getGameResults() =>
      (super.noSuchMethod(Invocation.method(#getGameResults, []),
              returnValue: Future<_i2.Either<_i5.Failure, List<String>>>.value(
                  _FakeEither_0<_i5.Failure, List<String>>()))
          as _i4.Future<_i2.Either<_i5.Failure, List<String>>>);
  @override
  _i4.Future<_i2.Either<_i5.GeneralFailure, int>> retreiveNumPlayers() =>
      (super.noSuchMethod(Invocation.method(#retreiveNumPlayers, []),
              returnValue: Future<_i2.Either<_i5.GeneralFailure, int>>.value(
                  _FakeEither_0<_i5.GeneralFailure, int>()))
          as _i4.Future<_i2.Either<_i5.GeneralFailure, int>>);
  @override
  _i4.Future<_i2.Either<_i5.GeneralFailure, bool>> hasGameStarted() =>
      (super.noSuchMethod(Invocation.method(#hasGameStarted, []),
              returnValue: Future<_i2.Either<_i5.GeneralFailure, bool>>.value(
                  _FakeEither_0<_i5.GeneralFailure, bool>()))
          as _i4.Future<_i2.Either<_i5.GeneralFailure, bool>>);
  @override
  _i4.Future<_i2.Either<_i5.GeneralFailure, String>> getGroupLeader() =>
      (super.noSuchMethod(Invocation.method(#getGroupLeader, []),
              returnValue: Future<_i2.Either<_i5.GeneralFailure, String>>.value(
                  _FakeEither_0<_i5.GeneralFailure, String>()))
          as _i4.Future<_i2.Either<_i5.GeneralFailure, String>>);
  @override
  _i4.Future<_i2.Either<_i5.GeneralFailure, bool>> startGame() =>
      (super.noSuchMethod(Invocation.method(#startGame, []),
              returnValue: Future<_i2.Either<_i5.GeneralFailure, bool>>.value(
                  _FakeEither_0<_i5.GeneralFailure, bool>()))
          as _i4.Future<_i2.Either<_i5.GeneralFailure, bool>>);
  @override
  _i4.Future<_i2.Either<_i5.GeneralFailure, String>>
      getNamePlayerCaughtFish() => (super.noSuchMethod(
              Invocation.method(#getNamePlayerCaughtFish, []),
              returnValue: Future<_i2.Either<_i5.GeneralFailure, String>>.value(
                  _FakeEither_0<_i5.GeneralFailure, String>()))
          as _i4.Future<_i2.Either<_i5.GeneralFailure, String>>);
  @override
  _i4.Future<_i2.Either<_i5.GeneralFailure, List<dynamic>>> rejectPriceOffer(
          int? index, _i7.RemoteDatasource? remoteDatasource) =>
      (super.noSuchMethod(
              Invocation.method(#rejectPriceOffer, [index, remoteDatasource]),
              returnValue:
                  Future<_i2.Either<_i5.GeneralFailure, List<dynamic>>>.value(
                      _FakeEither_0<_i5.GeneralFailure, List<dynamic>>()))
          as _i4.Future<_i2.Either<_i5.GeneralFailure, List<dynamic>>>);
  @override
  _i4.Future<_i2.Either<_i5.GeneralFailure, List<dynamic>>> acceptPriceOffer(
          int? index, _i7.RemoteDatasource? remoteDatasource) =>
      (super.noSuchMethod(
              Invocation.method(#acceptPriceOffer, [index, remoteDatasource]),
              returnValue:
                  Future<_i2.Either<_i5.GeneralFailure, List<dynamic>>>.value(
                      _FakeEither_0<_i5.GeneralFailure, List<dynamic>>()))
          as _i4.Future<_i2.Either<_i5.GeneralFailure, List<dynamic>>>);
}
