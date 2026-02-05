import 'package:equatable/equatable.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object?> get props => [];
}

class DashboardStarted extends DashboardEvent {
  final String studentId;

  const DashboardStarted(this.studentId);

  @override
  List<Object?> get props => [studentId];
}
