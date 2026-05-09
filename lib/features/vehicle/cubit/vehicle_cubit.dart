import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chatbot_app/features/vehicle/cubit/vehicle_state.dart';
import 'package:chatbot_app/features/vehicle/data/models/vehicle_permit.dart';
import 'package:chatbot_app/features/vehicle/repositories/vehicle_repository.dart';

class VehicleCubit extends Cubit<VehicleState> {
  final VehicleRepository _repo;
  VehicleCubit(this._repo) : super(const VehicleIdle([], null)) {
    _load();
  }

  Future<void> _load() async {
    emit(const VehicleLoading());

    VehiclePermit? currentPermit;
    List<VehiclePermit> history = [];

    // Fetch current state
    final currentResult = await _repo.getCurrentPermit();
    currentResult.fold((error) => null, (permit) => currentPermit = permit);

    // Fetch history
    final historyResult = await _repo.getPermits();
    historyResult
        .fold((error) => emit(VehicleError(error, history, currentPermit)),
            (permits) {
      history = List<VehiclePermit>.from(permits)
        ..sort((a, b) => (b.requestedAt ?? DateTime(0))
            .compareTo(a.requestedAt ?? DateTime(0)));
      emit(VehicleIdle(history, currentPermit));
    });
  }

  Future<void> submitPermit({
    required String licensePlate,
    required String make,
    required String model,
    required String color,
  }) async {
    emit(VehicleSubmitting(state.permits, state.currentPermit));

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
      emit(VehicleError(error, state.permits, state.currentPermit));
      emit(VehicleIdle(state.permits, state.currentPermit)); // Revert to idle
    }, (newPermit) async {
      // Refresh both current state and history to ensure consistency
      VehiclePermit? currentPermit = newPermit;
      final currentResult = await _repo.getCurrentPermit();
      currentResult.fold((l) => null, (r) => currentPermit = r);

      final historyResult = await _repo.getPermits();
      historyResult.fold(
          (error) =>
              emit(VehicleIdle([newPermit, ...state.permits], currentPermit)),
          (permits) {
        final sorted = List<VehiclePermit>.from(permits)
          ..sort((a, b) => (b.requestedAt ?? DateTime(0))
              .compareTo(a.requestedAt ?? DateTime(0)));
        emit(VehicleSubmitted(sorted, currentPermit));
      });

      await Future.delayed(const Duration(milliseconds: 200));

      final finalHistoryResult = await _repo.getPermits();
      finalHistoryResult.fold(
          (error) =>
              emit(VehicleIdle([newPermit, ...state.permits], currentPermit)),
          (permits) {
        final sorted = List<VehiclePermit>.from(permits)
          ..sort((a, b) => (b.requestedAt ?? DateTime(0))
              .compareTo(a.requestedAt ?? DateTime(0)));
        emit(VehicleIdle(sorted, currentPermit));
      });
    });
  }
}
