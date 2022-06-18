// Mocks generated by Mockito 5.1.0 from annotations
// in catchfish/test/features/gameBoard/presentation/blocs/fishing/select_group_bloc_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i4;

import 'package:catchfish/core/errors/failures.dart' as _i5;
import 'package:catchfish/core/usecases/usecase.dart' as _i7;
import 'package:catchfish/features/gameBoard/data/repositories/select_group_repository_impl.dart'
    as _i9;
import 'package:catchfish/features/gameBoard/domain/entities/fishing/list_group_entity.dart'
    as _i8;
import 'package:catchfish/features/gameBoard/domain/entities/fishing/pulse_entity.dart'
    as _i6;
import 'package:catchfish/features/gameBoard/domain/usecases/fishing/selectGroup_usecase.dart'
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

/// A class which mocks [SelectGroupUsecase].
///
/// See the documentation for Mockito's code generation for more information.
class MockSelectGroupUsecase extends _i1.Mock
    implements _i3.SelectGroupUsecase {
  MockSelectGroupUsecase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<_i2.Either<_i5.Failure, _i6.PulseEntity>> call(
          _i7.NoParams? params) =>
      (super.noSuchMethod(Invocation.method(#call, [params]),
          returnValue: Future<_i2.Either<_i5.Failure, _i6.PulseEntity>>.value(
              _FakeEither_0<_i5.Failure, _i6.PulseEntity>())) as _i4
          .Future<_i2.Either<_i5.Failure, _i6.PulseEntity>>);
  @override
  _i4.Future<_i2.Either<_i5.Failure, _i8.ListGroupEntity>> retreiveListGroups(
          _i9.SelectGroupRepositoryImpl? selectGroupRepositoryImpl) =>
      (super.noSuchMethod(
          Invocation.method(#retreiveListGroups, [selectGroupRepositoryImpl]),
          returnValue:
              Future<_i2.Either<_i5.Failure, _i8.ListGroupEntity>>.value(
                  _FakeEither_0<_i5.Failure, _i8.ListGroupEntity>())) as _i4
          .Future<_i2.Either<_i5.Failure, _i8.ListGroupEntity>>);
  @override
  _i4.Future<_i2.Either<_i5.Failure, bool>> addUserToGroup(
          String? groupName, String? yourName) =>
      (super.noSuchMethod(
              Invocation.method(#addUserToGroup, [groupName, yourName]),
              returnValue: Future<_i2.Either<_i5.Failure, bool>>.value(
                  _FakeEither_0<_i5.Failure, bool>()))
          as _i4.Future<_i2.Either<_i5.Failure, bool>>);
}
