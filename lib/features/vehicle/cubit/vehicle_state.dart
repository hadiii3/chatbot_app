import 'package:equatable/equatable.dart';
import 'package:chatbot_app/features/vehicle/data/models/vehicle_permit.dart';

abstract class VehicleState extends Equatable {
  final List<VehiclePermit> permits;
  final VehiclePermit? currentPermit;

  const VehicleState(this.permits, this.currentPermit);

  @override
  List<Object?> get props => [permits, currentPermit];
}

class VehicleLoading extends VehicleState {
  const VehicleLoading() : super(const [], null);
}

class VehicleIdle extends VehicleState {
  const VehicleIdle(super.permits, super.currentPermit);
}

class VehicleSubmitting extends VehicleState {
  const VehicleSubmitting(super.permits, super.currentPermit);
}

class VehicleSubmitted extends VehicleState {
  const VehicleSubmitted(super.permits, super.currentPermit);
}

class VehicleError extends VehicleState {
  final String message;
  const VehicleError(this.message, super.permits, super.currentPermit);

  @override
  List<Object?> get props => [permits, currentPermit, message];
}
