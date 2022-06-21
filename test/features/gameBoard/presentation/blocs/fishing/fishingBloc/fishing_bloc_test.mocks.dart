// Mocks generated by Mockito 5.1.0 from annotations
// in catchfish/test/features/gameBoard/presentation/blocs/fishing/fishingBloc/fishing_bloc_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i7;

import 'package:audioplayers/audioplayers.dart' as _i3;
import 'package:bloc/bloc.dart' as _i8;
import 'package:catchfish/core/errors/failures.dart' as _i10;
import 'package:catchfish/core/usecases/usecase.dart' as _i12;
import 'package:catchfish/features/gameBoard/data/datasources/fishing/local_datasource.dart'
    as _i4;
import 'package:catchfish/features/gameBoard/data/datasources/fishing/remote_datasource.dart'
    as _i5;
import 'package:catchfish/features/gameBoard/data/repositories/fishing_repository_impl.dart'
    as _i14;
import 'package:catchfish/features/gameBoard/domain/entities/fishing/caught_fish_entity.dart'
    as _i13;
import 'package:catchfish/features/gameBoard/domain/entities/fishing/pulse_entity.dart'
    as _i11;
import 'package:catchfish/features/gameBoard/domain/usecases/fishing/fishing_usecase.dart'
    as _i9;
import 'package:catchfish/features/gameBoard/presentation/blocs/fishing/fishingBloc/fishing_bloc.dart'
    as _i2;
import 'package:dartz/dartz.dart' as _i6;
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

class _FakeFishingState_0 extends _i1.Fake implements _i2.FishingState {}

class _FakeAudioCache_1 extends _i1.Fake implements _i3.AudioCache {}

class _FakeAudioPlayer_2 extends _i1.Fake implements _i3.AudioPlayer {}

class _FakeLocalDatasourcePrefs_3 extends _i1.Fake
    implements _i4.LocalDatasourcePrefs {}

class _FakeRemoteDatasource_4 extends _i1.Fake implements _i5.RemoteDatasource {
}

class _FakeEither_5<L, R> extends _i1.Fake implements _i6.Either<L, R> {}

/// A class which mocks [FishingBloc].
///
/// See the documentation for Mockito's code generation for more information.
class MockFishingBloc extends _i1.Mock implements _i2.FishingBloc {
  MockFishingBloc() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.FishingState get state => (super.noSuchMethod(Invocation.getter(#state),
      returnValue: _FakeFishingState_0()) as _i2.FishingState);
  @override
  _i7.Stream<_i2.FishingState> get stream =>
      (super.noSuchMethod(Invocation.getter(#stream),
              returnValue: Stream<_i2.FishingState>.empty())
          as _i7.Stream<_i2.FishingState>);
  @override
  bool get isClosed =>
      (super.noSuchMethod(Invocation.getter(#isClosed), returnValue: false)
          as bool);
  @override
  void add(_i2.FishingEvent? event) =>
      super.noSuchMethod(Invocation.method(#add, [event]),
          returnValueForMissingStub: null);
  @override
  void onEvent(_i2.FishingEvent? event) =>
      super.noSuchMethod(Invocation.method(#onEvent, [event]),
          returnValueForMissingStub: null);
  @override
  void emit(_i2.FishingState? state) =>
      super.noSuchMethod(Invocation.method(#emit, [state]),
          returnValueForMissingStub: null);
  @override
  void on<E extends _i2.FishingEvent>(
          _i8.EventHandler<E, _i2.FishingState>? handler,
          {_i8.EventTransformer<E>? transformer}) =>
      super.noSuchMethod(
          Invocation.method(#on, [handler], {#transformer: transformer}),
          returnValueForMissingStub: null);
  @override
  void onTransition(
          _i8.Transition<_i2.FishingEvent, _i2.FishingState>? transition) =>
      super.noSuchMethod(Invocation.method(#onTransition, [transition]),
          returnValueForMissingStub: null);
  @override
  _i7.Future<void> close() => (super.noSuchMethod(Invocation.method(#close, []),
      returnValue: Future<void>.value(),
      returnValueForMissingStub: Future<void>.value()) as _i7.Future<void>);
  @override
  void onChange(_i8.Change<_i2.FishingState>? change) =>
      super.noSuchMethod(Invocation.method(#onChange, [change]),
          returnValueForMissingStub: null);
  @override
  void addError(Object? error, [StackTrace? stackTrace]) =>
      super.noSuchMethod(Invocation.method(#addError, [error, stackTrace]),
          returnValueForMissingStub: null);
  @override
  void onError(Object? error, StackTrace? stackTrace) =>
      super.noSuchMethod(Invocation.method(#onError, [error, stackTrace]),
          returnValueForMissingStub: null);
}

/// A class which mocks [FishingUsecase].
///
/// See the documentation for Mockito's code generation for more information.
class MockFishingUsecase extends _i1.Mock implements _i9.FishingUsecase {
  MockFishingUsecase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.AudioCache get audioCache =>
      (super.noSuchMethod(Invocation.getter(#audioCache),
          returnValue: _FakeAudioCache_1()) as _i3.AudioCache);
  @override
  _i3.AudioPlayer get audioPlayer =>
      (super.noSuchMethod(Invocation.getter(#audioPlayer),
          returnValue: _FakeAudioPlayer_2()) as _i3.AudioPlayer);
  @override
  set audioPlayer(_i3.AudioPlayer? _audioPlayer) =>
      super.noSuchMethod(Invocation.setter(#audioPlayer, _audioPlayer),
          returnValueForMissingStub: null);
  @override
  _i4.LocalDatasourcePrefs get localDatasourcePrefs => (super.noSuchMethod(
      Invocation.getter(#localDatasourcePrefs),
      returnValue: _FakeLocalDatasourcePrefs_3()) as _i4.LocalDatasourcePrefs);
  @override
  set localDatasourcePrefs(_i4.LocalDatasourcePrefs? _localDatasourcePrefs) =>
      super.noSuchMethod(
          Invocation.setter(#localDatasourcePrefs, _localDatasourcePrefs),
          returnValueForMissingStub: null);
  @override
  _i5.RemoteDatasource get remoteDatasource =>
      (super.noSuchMethod(Invocation.getter(#remoteDatasource),
          returnValue: _FakeRemoteDatasource_4()) as _i5.RemoteDatasource);
  @override
  set remoteDatasource(_i5.RemoteDatasource? _remoteDatasource) => super
      .noSuchMethod(Invocation.setter(#remoteDatasource, _remoteDatasource),
          returnValueForMissingStub: null);
  @override
  dynamic playBackgroundAudio(String? engineSound) => super
      .noSuchMethod(Invocation.method(#playBackgroundAudio, [engineSound]));
  @override
  _i7.Future<_i6.Either<_i10.Failure, _i11.PulseEntity>> call(
          _i12.NoParams? params) =>
      (super.noSuchMethod(Invocation.method(#call, [params]),
          returnValue: Future<_i6.Either<_i10.Failure, _i11.PulseEntity>>.value(
              _FakeEither_5<_i10.Failure, _i11.PulseEntity>())) as _i7
          .Future<_i6.Either<_i10.Failure, _i11.PulseEntity>>);
  @override
  _i7.Future<_i6.Either<_i10.Failure, _i11.PulseEntity>> getPulse() =>
      (super.noSuchMethod(Invocation.method(#getPulse, []),
          returnValue: Future<_i6.Either<_i10.Failure, _i11.PulseEntity>>.value(
              _FakeEither_5<_i10.Failure, _i11.PulseEntity>())) as _i7
          .Future<_i6.Either<_i10.Failure, _i11.PulseEntity>>);
  @override
  _i7.Future<_i6.Either<_i10.Failure, _i13.CaughtFishEntity>> isFishCaught() =>
      (super.noSuchMethod(Invocation.method(#isFishCaught, []),
              returnValue:
                  Future<_i6.Either<_i10.Failure, _i13.CaughtFishEntity>>.value(
                      _FakeEither_5<_i10.Failure, _i13.CaughtFishEntity>()))
          as _i7.Future<_i6.Either<_i10.Failure, _i13.CaughtFishEntity>>);
  @override
  _i7.Future<_i6.Either<_i10.Failure, String>> calculateNewCoundownTime(
          String? currentCountdownTime) =>
      (super.noSuchMethod(
          Invocation.method(#calculateNewCoundownTime, [currentCountdownTime]),
          returnValue: Future<_i6.Either<_i10.Failure, String>>.value(
              _FakeEither_5<_i10.Failure, String>())) as _i7
          .Future<_i6.Either<_i10.Failure, String>>);
  @override
  _i7.Future<_i6.Either<_i10.Failure, List<String>>> populatePersonalShop(
          _i5.RemoteDatasource? remoteDatasource,
          _i4.LocalDatasource? localDatasource) =>
      (super.noSuchMethod(
              Invocation.method(
                  #populatePersonalShop, [remoteDatasource, localDatasource]),
              returnValue: Future<_i6.Either<_i10.Failure, List<String>>>.value(
                  _FakeEither_5<_i10.Failure, List<String>>()))
          as _i7.Future<_i6.Either<_i10.Failure, List<String>>>);
  @override
  _i7.Future<_i6.Either<_i10.Failure, bool>> updateCaughtInGroups(
          String? caughtFishDetails) =>
      (super.noSuchMethod(
              Invocation.method(#updateCaughtInGroups, [caughtFishDetails]),
              returnValue: Future<_i6.Either<_i10.Failure, bool>>.value(
                  _FakeEither_5<_i10.Failure, bool>()))
          as _i7.Future<_i6.Either<_i10.Failure, bool>>);
  @override
  _i7.Future<_i6.Either<_i10.Failure, bool>> addFishPersonalShop(
          String? caughtFishDetails) =>
      (super.noSuchMethod(
              Invocation.method(#addFishPersonalShop, [caughtFishDetails]),
              returnValue: Future<_i6.Either<_i10.Failure, bool>>.value(
                  _FakeEither_5<_i10.Failure, bool>()))
          as _i7.Future<_i6.Either<_i10.Failure, bool>>);
  @override
  _i7.Future<_i6.Either<_i10.Failure, List<String>>> getGameResults(
          _i14.FishingRepositoryImpl? fishingRepositoryImpl) =>
      (super.noSuchMethod(
              Invocation.method(#getGameResults, [fishingRepositoryImpl]),
              returnValue: Future<_i6.Either<_i10.Failure, List<String>>>.value(
                  _FakeEither_5<_i10.Failure, List<String>>()))
          as _i7.Future<_i6.Either<_i10.Failure, List<String>>>);
}
