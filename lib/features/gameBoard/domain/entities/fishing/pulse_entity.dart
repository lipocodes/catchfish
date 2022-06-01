import 'package:equatable/equatable.dart';

class PulseEntity extends Equatable {
  final double pulseStrength;
  final double pulseLength;

  const PulseEntity({
    required this.pulseStrength,
    required this.pulseLength,
  }) : super();

  @override
  // TODO: implement props
  List<Object?> get props => [pulseStrength, pulseLength];
}
