// Mocks generated by Mockito 5.1.0 from annotations
// in catchfish/test/features/gameBoard/data/datasources/fishing/remote_datasource_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i6;

import 'package:catchfish/features/tokens/data/datasources/remote_datasource.dart'
    as _i5;
import 'package:catchfish/features/tokens/data/models/tokens_model.dart' as _i4;
import 'package:catchfish/features/tokens/domain/entities/products_entity.dart'
    as _i3;
import 'package:firebase_auth/firebase_auth.dart' as _i2;
import 'package:in_app_purchase/in_app_purchase.dart' as _i7;
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

class _FakeFirebaseAuth_0 extends _i1.Fake implements _i2.FirebaseAuth {}

class _FakeProductsEntity_1 extends _i1.Fake implements _i3.ProductsEntity {}

class _FakeTokensModel_2 extends _i1.Fake implements _i4.TokensModel {}

/// A class which mocks [RemoteDatasource].
///
/// See the documentation for Mockito's code generation for more information.
class MockRemoteDatasource extends _i1.Mock implements _i5.RemoteDatasource {
  MockRemoteDatasource() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.FirebaseAuth get auth => (super.noSuchMethod(Invocation.getter(#auth),
      returnValue: _FakeFirebaseAuth_0()) as _i2.FirebaseAuth);
  @override
  _i6.Future<_i3.ProductsEntity> getProducts() =>
      (super.noSuchMethod(Invocation.method(#getProducts, []),
              returnValue:
                  Future<_i3.ProductsEntity>.value(_FakeProductsEntity_1()))
          as _i6.Future<_i3.ProductsEntity>);
  @override
  dynamic listenToPurchaseUpdated(
          List<_i7.PurchaseDetails>? purchaseDetailsList) =>
      super.noSuchMethod(
          Invocation.method(#listenToPurchaseUpdated, [purchaseDetailsList]));
  @override
  _i6.Future<_i4.TokensModel> buyTokens(String? prodID) =>
      (super.noSuchMethod(Invocation.method(#buyTokens, [prodID]),
              returnValue: Future<_i4.TokensModel>.value(_FakeTokensModel_2()))
          as _i6.Future<_i4.TokensModel>);
}