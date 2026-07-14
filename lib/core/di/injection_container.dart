import 'package:admin_web/features/property_moderation/data/repository/property_moderation_repository_impl.dart';
import 'package:admin_web/features/property_moderation/domin/repository/property_moderation_repository.dart';
import 'package:admin_web/features/property_moderation/domin/usecase/approve_property.dart';
import 'package:admin_web/features/property_moderation/domin/usecase/getPendingProperties.dart';
import 'package:admin_web/features/property_moderation/domin/usecase/get_property_review_detail.dart';
import 'package:admin_web/features/property_moderation/domin/usecase/reject_property.dart';
import 'package:get_it/get_it.dart';

import '../session/user_session.dart';

// ── auth ──
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_as_admin.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';

// ── admin_dashboard ──
import '../../features/admin_dashboard/data/datasources/admin_dashboard_remote_data_source.dart';
import '../../features/admin_dashboard/data/repositories/admin_dashboard_repository_impl.dart';
import '../../features/admin_dashboard/domain/repositories/admin_dashboard_repository.dart';
import '../../features/admin_dashboard/domain/usecases/get_dashboard_overview.dart';
import '../../features/admin_dashboard/presentation/cubit/admin_dashboard_cubit.dart';

/// متغيّر GetIt العام — نفس الاسم والنمط المستخدم بمشروع الموبايل.
final GetIt sl = GetIt.instance;

Future<void> init() async {
  // ── Core (عام لكل المشروع) ──
  sl.registerLazySingleton<UserSession>(() => UserSession());

  // ── Features ──
  registerAuthFeatureDependencies();
  registerAdminDashboardFeatureDependencies();

  // TODO: بالخطوات القادمة، أضف هون بنفس النمط:
  registerPropertyModerationFeatureDependencies();
  // registerAllPropertiesFeatureDependencies();
  // registerUsersManagementFeatureDependencies();
  // registerAgentVerificationFeatureDependencies();
  // registerReportsManagementFeatureDependencies();
}

void registerAuthFeatureDependencies() {
  // Presentation
  sl.registerFactory<AuthCubit>(
    () => AuthCubit(loginAsAdmin: sl(), userSession: sl()),
  );

  // Domain
  sl.registerLazySingleton<LoginAsAdmin>(() => LoginAsAdmin(sl()));

  // Data
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());
}

void registerAdminDashboardFeatureDependencies() {
  // Presentation
  sl.registerFactory<AdminDashboardCubit>(
    () => AdminDashboardCubit(getDashboardOverview: sl()),
  );

  // Domain
  sl.registerLazySingleton<GetDashboardOverview>(
    () => GetDashboardOverview(sl()),
  );

  // Data
  sl.registerLazySingleton<AdminDashboardRepository>(
    () => AdminDashboardRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<AdminDashboardRemoteDataSource>(
    () => AdminDashboardRemoteDataSourceImpl(),
  );
}

//property_moderation
void registerPropertyModerationFeatureDependencies() {
  // Domain
  sl.registerLazySingleton<GetPendingProperties>(
    () => GetPendingProperties(sl()),
  );
  sl.registerLazySingleton<GetPropertyReviewDetail>(
    () => GetPropertyReviewDetail(sl()),
  );
  sl.registerLazySingleton<RejectProperty>(
    () => RejectProperty(sl()),
  );
  sl.registerLazySingleton<ApproveProperty>(
    () => ApproveProperty(sl()),
  );

  // Data
  sl.registerLazySingleton<PropertyModerationRepository>(
    () => PropertyModerationRepositoryImpl(sl()),
  );

  //presentation
  sl.registerFactory<AdminDashboardCubit>(
    () => AdminDashboardCubit(getDashboardOverview: sl()),
  );
}
