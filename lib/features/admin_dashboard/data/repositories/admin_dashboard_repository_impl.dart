import 'package:dartz/dartz.dart';
import 'package:postgrest/postgrest.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/dashboard_entities.dart';
import '../../domain/repositories/admin_dashboard_repository.dart';
import '../datasources/admin_dashboard_remote_data_source.dart';
import '../models/dashboard_models.dart';

class AdminDashboardRepositoryImpl implements AdminDashboardRepository {
  final AdminDashboardRemoteDataSource remoteDataSource;
  AdminDashboardRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, DashboardOverview>> getDashboardOverview() {
    return _guard(() async {
      // الطلبات الثلاثة بالتوازي — أسرع من تنفيذها الواحد تلو الآخر
      final results = await Future.wait([
        remoteDataSource.getStats(),
        remoteDataSource.getRecentPendingProperties(),
        remoteDataSource.getRecentPendingReports(),
      ]);

      return DashboardOverview(
        stats: results[0] as DashboardStatsModel,
        recentPendingProperties:
            results[1] as List<PendingPropertyPreviewModel>,
        recentPendingReports: results[2] as List<PendingReportPreviewModel>,
      );
    });
  }

  Future<Either<Failure, T>> _guard<T>(Future<T> Function() action) async {
    try {
      final result = await action();
      return Right(result);
    } on PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
