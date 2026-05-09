import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chatbot_app/features/vehicle/cubit/vehicle_state.dart';
import 'package:chatbot_app/features/vehicle/data/models/vehicle_permit.dart';
import 'package:chatbot_app/features/vehicle/repositories/vehicle_repository.dart';

class VehicleCubit extends Cubit<VehicleState> {
  final VehicleRepository _repo;
  VehicleCubit(this._repo) : super(const VehicleIdle([])) {
    _load();
  }

  void _load() => emit(VehicleIdle(_repo.getPermits()));

  Future<void> submitPermit({
    required String licensePlate,
    required String make,
    required String model,
    required String color,
  }) async {
    emit(VehicleSubmitting(state.permits));
    await Future.delayed(const Duration(milliseconds: 800));
    final permit = VehiclePermit(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      licensePlate: licensePlate.toUpperCase(),
      make: make,
      model: model,
      color: color,
      status: PermitStatus.pending,
      requestedAt: DateTime.now(),
    );
    await _repo.addPermit(permit);
    emit(VehicleSubmitted(_repo.getPermits()));
    await Future.delayed(const Duration(milliseconds: 200));
    emit(VehicleIdle(_repo.getPermits()));
  }
}
