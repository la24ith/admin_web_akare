import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/dashboard_entities.dart';

abstract class AdminDashboardRepository {
  /// يرجع كل بيانات اللوحة دفعة واحدة (إحصائيات + آخر 5 عقارات pending
  /// + آخر 5 بلاغات pending) عبر طلبات متوازية بالـ DataSource.
  Future<Either<Failure, DashboardOverview>> getDashboardOverview();
}
