import 'package:equatable/equatable.dart';
import 'package:chatbot_app/features/vehicle/data/models/vehicle_permit.dart';

abstract class VehicleState extends Equatable {
  final List<VehiclePermit> permits;
  const VehicleState(this.permits);
  @override
  List<Object?> get props => [permits];
}

class VehicleLoading extends VehicleState {
  const VehicleLoading() : super(const []);
}

class VehicleIdle extends VehicleState {
  const VehicleIdle(super.permits);
}

class VehicleSubmitting extends VehicleState {
  const VehicleSubmitting(super.permits);
}

class VehicleSubmitted extends VehicleState {
  const VehicleSubmitted(super.permits);
}

class VehicleError extends VehicleState {
  final String message;
  const VehicleError(this.message) : super(const []);
  @override
  List<Object?> get props => [permits, message];
}
