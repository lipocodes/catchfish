import 'package:catchfish/features/gameBoard/domain/entities/fishing/list_group_entity.dart';

class ListGroupModel extends ListGroupEntity {
  final List<String> list;
  ListGroupModel({required this.list}) : super(list: list);
}
