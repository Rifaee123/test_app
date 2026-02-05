import 'package:equatable/equatable.dart';
import '../model/student_dashboard_view_model.dart';

abstract class StudentDashboardState extends Equatable {
  const StudentDashboardState();

  @override
  List<Object?> get props => [];
}

class StudentDashboardInitial extends StudentDashboardState {}

class StudentDashboardLoading extends StudentDashboardState {}

class StudentDashboardLoaded extends StudentDashboardState {
  final StudentDashboardViewModel viewModel;

  const StudentDashboardLoaded(this.viewModel);

  @override
  List<Object?> get props => [viewModel];
}

class StudentDashboardError extends StudentDashboardState {
  final String message;

  const StudentDashboardError(this.message);

  @override
  List<Object?> get props => [message];
}
