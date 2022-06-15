import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'selectgroup_event.dart';
part 'selectgroup_state.dart';

class SelectgroupBloc extends Bloc<SelectgroupEvent, SelectgroupState> {
  SelectgroupBloc() : super(SelectgroupInitial()) {
    on<SelectgroupEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
