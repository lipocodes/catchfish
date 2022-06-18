import 'package:catchfish/features/gameBoard/data/models/fishing/list_group_model.dart';
import 'package:catchfish/features/gameBoard/data/repositories/select_group_repository_impl.dart';
import 'package:catchfish/features/gameBoard/presentation/widgets/selectGroup/selector_group_type.dart';
import 'package:catchfish/features/tokens/data/datasources/remote_datasource.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:catchfish/injection_container.dart' as di;
import 'package:mockito/mockito.dart';

import '../../repositories/fishing_repository_impl_test.mocks.dart';

@GenerateMocks([RemoteDatasource])
void main() {
  MockRemoteDatasource mockRemoteDatasource = MockRemoteDatasource();
  SelectGroupRepositoryImpl selectGroupRepositoryImpl =
      SelectGroupRepositoryImpl();
  //warning: no point running unit tests here: can't run Firebase commands on testing environment
  setUp(() async {});
  tearDown(() {});
  group("Testing RemoteDatasource", () {
    di.init();
  });
}
