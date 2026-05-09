import 'package:equatable/equatable.dart';
import 'package:chatbot_app/features/auth/data/models/student_model.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();
  @override
  List<Object?> get props => [];
}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final StudentModel student;
  const DashboardLoaded(this.student);
  @override
  List<Object?> get props => [student];
}

class DashboardError extends DashboardState {
  final String message;
  const DashboardError(this.message);
  @override
  List<Object?> get props => [message];
}
