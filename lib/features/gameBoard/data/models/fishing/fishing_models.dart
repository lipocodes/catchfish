import 'package:catchfish/features/gameBoard/domain/entities/fishing/pulse_entity.dart';

class PulseModel extends PulseEntity {
  const PulseModel({required double pulseStrength, required double pulseLength})
      : super(pulseStrength: pulseStrength, pulseLength: pulseLength);
  factory PulseModel.fromJson(Map<String, dynamic> json) {
    return PulseModel(
      pulseStrength: json['pulseStrength'],
      pulseLength: json['pulseLength'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'pulseStrength': pulseStrength,
      'pulseLength': pulseLength,
    };
  }
}
