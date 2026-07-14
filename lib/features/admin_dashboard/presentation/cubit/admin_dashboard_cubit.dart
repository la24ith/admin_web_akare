import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/dashboard_entities.dart';
import '../../domain/usecases/get_dashboard_overview.dart';

part 'admin_dashboard_state.dart';

class AdminDashboardCubit extends Cubit<AdminDashboardState> {
  final GetDashboardOverview getDashboardOverview;

  AdminDashboardCubit({required this.getDashboardOverview})
      : super(const AdminDashboardInitial());

  Future<void> loadOverview() async {
    emit(const AdminDashboardLoading());

    final result = await getDashboardOverview(const NoParams());

    result.fold(
      (failure) => emit(AdminDashboardError(failure.message)),
      (overview) => emit(AdminDashboardLoaded(overview)),
    );
  }

  Future<void> refresh() => loadOverview();
}
