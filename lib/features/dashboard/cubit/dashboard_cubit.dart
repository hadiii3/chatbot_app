import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chatbot_app/features/dashboard/cubit/dashboard_state.dart';
import 'package:chatbot_app/features/dashboard/repositories/dashboard_repository.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final DashboardRepository _repo;
  DashboardCubit(this._repo) : super(DashboardLoading()) {
    loadDashboard();
  }

  Future<void> loadDashboard() async {
    emit(DashboardLoading());
    final result = await _repo.getStudent();
    result.fold(
      (error) => emit(DashboardError(error)),
      (student) => emit(DashboardLoaded(student)),
    );
  }
}
