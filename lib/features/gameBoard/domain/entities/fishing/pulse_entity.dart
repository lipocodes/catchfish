import 'package:equatable/equatable.dart';

class PulseEntity extends Equatable {
  final double pulseStrength;
  final double pulseLength;
  final double angle;

  const PulseEntity({
    required this.pulseStrength,
    required this.pulseLength,
    required this.angle,
  }) : super();

  @override
  // TODO: implement props
  List<Object?> get props => [pulseStrength, pulseLength, angle];
}
