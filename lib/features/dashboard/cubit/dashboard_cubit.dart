import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chatbot_app/features/dashboard/cubit/dashboard_state.dart';
import 'package:chatbot_app/features/dashboard/repositories/dashboard_repository.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final DashboardRepository _repo;
  DashboardCubit(this._repo) : super(DashboardLoading()) {
    loadDashboard();
  }

  void loadDashboard() {
    final student = _repo.getStudent();
    if (student != null) {
      emit(DashboardLoaded(student));
    } else {
      emit(const DashboardError('Could not load student data.'));
    }
  }
}
