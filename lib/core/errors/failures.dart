import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure([List properties = const <dynamic>[]]);
}

//repositories return these classes in Either<Failure, NumberTrivia>
class ServerFailure extends Failure {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class CacheFailure extends Failure {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
