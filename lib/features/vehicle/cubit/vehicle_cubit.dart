import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chatbot_app/features/vehicle/cubit/vehicle_state.dart';
import 'package:chatbot_app/features/vehicle/data/models/vehicle_permit.dart';
import 'package:chatbot_app/features/vehicle/repositories/vehicle_repository.dart';

class VehicleCubit extends Cubit<VehicleState> {
  final VehicleRepository _repo;
  VehicleCubit(this._repo) : super(const VehicleIdle([])) {
    _load();
  }

  Future<void> _load() async {
    emit(const VehicleLoading());
    final historyResult = await _repo.getPermits();
    historyResult.fold((error) => emit(VehicleError(error)),
        (permits) => emit(VehicleIdle(permits)));
  }

  Future<void> submitPermit({
    required String licensePlate,
    required String make,
    required String model,
    required String color,
  }) async {
    emit(VehicleSubmitting(state.permits));

    final permit = VehiclePermit(
      id: 0,
      licensePlate: licensePlate.toUpperCase(),
      make: make,
      model: model,
      color: color,
      status: PermitStatus.pending,
      requestedAt: DateTime.now(),
    );

    final result = await _repo.addPermit(permit);
    result.fold((error) {
      emit(VehicleError(error));
      emit(VehicleIdle(state.permits)); // Revert to idle
    }, (newPermit) async {
      // Reload history to ensure consistency
      final historyResult = await _repo.getPermits();
      historyResult.fold(
          (error) => emit(VehicleIdle([...state.permits, newPermit])),
          (permits) => emit(VehicleSubmitted(permits)));

      await Future.delayed(const Duration(milliseconds: 200));

      final finalHistoryResult = await _repo.getPermits();
      finalHistoryResult.fold(
          (error) => emit(VehicleIdle([...state.permits, newPermit])),
          (permits) => emit(VehicleIdle(permits)));
    });
  }
}
