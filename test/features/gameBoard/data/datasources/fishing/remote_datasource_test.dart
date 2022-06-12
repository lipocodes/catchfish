import 'package:catchfish/features/gameBoard/data/datasources/fishing/local_datasource.dart';
import 'package:catchfish/features/gameBoard/data/datasources/fishing/remote_datasource.dart';
import 'package:catchfish/injection_container.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:catchfish/injection_container.dart' as di;

@GenerateMocks([])
void main() {
  //warning: no point running unit tests here: can't run Firebase commands on testing environment
  setUp(() async {});
  tearDown(() {});
  group("Testing RemoteDatasource", () {
    di.init();
    test("testing updateCaughtFishUsersCollection()", () async {});
  });
}
