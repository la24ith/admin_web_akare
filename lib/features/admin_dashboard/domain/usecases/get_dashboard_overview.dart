import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/dashboard_entities.dart';
import '../repositories/admin_dashboard_repository.dart';

class GetDashboardOverview implements UseCase<DashboardOverview, NoParams> {
  final AdminDashboardRepository repository;
  GetDashboardOverview(this.repository);

  @override
  Future<Either<Failure, DashboardOverview>> call(NoParams params) {
    return repository.getDashboardOverview();
  }
}
