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

// ── property_moderation ──
import '../../features/property_moderation/data/datasources/property_moderation_remote_data_source.dart';
import '../../features/property_moderation/data/repositories/property_moderation_repository_impl.dart';
import '../../features/property_moderation/domain/repositories/property_moderation_repository.dart';
import '../../features/property_moderation/domain/usecases/approve_property.dart';
import '../../features/property_moderation/domain/usecases/get_pending_properties.dart';
import '../../features/property_moderation/domain/usecases/get_property_review_detail.dart';
import '../../features/property_moderation/domain/usecases/reject_property.dart';
import '../../features/property_moderation/presentation/cubit/property_moderation_cubit.dart';
import '../../features/property_moderation/presentation/cubit/property_review_detail_cubit.dart';

// ── all_properties ──
import '../../features/all_properties/data/datasources/all_properties_remote_data_source.dart';
import '../../features/all_properties/data/repositories/all_properties_repository_impl.dart';
import '../../features/all_properties/domain/repositories/all_properties_repository.dart';
import '../../features/all_properties/domain/usecases/disable_property.dart';
import '../../features/all_properties/domain/usecases/get_all_properties.dart';
import '../../features/all_properties/presentation/cubit/all_properties_cubit.dart';

// ── users_management ──
import '../../features/users_management/data/datasources/users_management_remote_data_source.dart';
import '../../features/users_management/data/repositories/users_management_repository_impl.dart';
import '../../features/users_management/domain/repositories/users_management_repository.dart';
import '../../features/users_management/domain/usecases/get_users.dart';
import '../../features/users_management/domain/usecases/set_user_active.dart';
import '../../features/users_management/presentation/cubit/users_management_cubit.dart';

// ── agent_verification ──
import '../../features/agent_verification/data/datasources/agent_verification_remote_data_source.dart';
import '../../features/agent_verification/data/repositories/agent_verification_repository_impl.dart';
import '../../features/agent_verification/domain/repositories/agent_verification_repository.dart';
import '../../features/agent_verification/domain/usecases/get_pending_agents.dart';
import '../../features/agent_verification/domain/usecases/verify_agent.dart';
import '../../features/agent_verification/presentation/cubit/agent_verification_cubit.dart';

// ── reports_management ──
import '../../features/reports_management/data/datasources/reports_management_remote_data_source.dart';
import '../../features/reports_management/data/repositories/reports_management_repository_impl.dart';
import '../../features/reports_management/domain/repositories/reports_management_repository.dart';
import '../../features/reports_management/domain/usecases/disable_reported_property.dart';
import '../../features/reports_management/domain/usecases/get_reports.dart';
import '../../features/reports_management/domain/usecases/mark_reviewed.dart';
import '../../features/reports_management/presentation/cubit/reports_management_cubit.dart';

/// متغيّر GetIt العام — نفس الاسم والنمط المستخدم بمشروع الموبايل.
final GetIt sl = GetIt.instance;

Future<void> init() async {
  // ── Core (عام لكل المشروع) ──
  sl.registerLazySingleton<UserSession>(() => UserSession());

  // ── Features ──
  registerAuthFeatureDependencies();
  registerAdminDashboardFeatureDependencies();
  registerPropertyModerationFeatureDependencies();
  registerAllPropertiesFeatureDependencies();
  registerUsersManagementFeatureDependencies();
  registerAgentVerificationFeatureDependencies();
  registerReportsManagementFeatureDependencies();
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

void registerPropertyModerationFeatureDependencies() {
  // Presentation — Cubit منفصل للقائمة وآخر لتفاصيل المراجعة، كل واحد factory
  sl.registerFactory<PropertyModerationCubit>(
    () => PropertyModerationCubit(getPendingProperties: sl()),
  );
  sl.registerFactory<PropertyReviewDetailCubit>(
    () => PropertyReviewDetailCubit(
      getPropertyReviewDetail: sl(),
      approveProperty: sl(),
      rejectProperty: sl(),
    ),
  );

  // Domain
  sl.registerLazySingleton<GetPendingProperties>(
    () => GetPendingProperties(sl()),
  );
  sl.registerLazySingleton<GetPropertyReviewDetail>(
    () => GetPropertyReviewDetail(sl()),
  );
  sl.registerLazySingleton<ApproveProperty>(() => ApproveProperty(sl()));
  sl.registerLazySingleton<RejectProperty>(() => RejectProperty(sl()));

  // Data
  sl.registerLazySingleton<PropertyModerationRepository>(
    () => PropertyModerationRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<PropertyModerationRemoteDataSource>(
    () => PropertyModerationRemoteDataSourceImpl(),
  );
}

void registerAllPropertiesFeatureDependencies() {
  // Presentation
  sl.registerFactory<AllPropertiesCubit>(
    () => AllPropertiesCubit(getAllProperties: sl(), disableProperty: sl()),
  );

  // Domain
  sl.registerLazySingleton<GetAllProperties>(() => GetAllProperties(sl()));
  sl.registerLazySingleton<DisableProperty>(() => DisableProperty(sl()));

  // Data
  sl.registerLazySingleton<AllPropertiesRepository>(
    () => AllPropertiesRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<AllPropertiesRemoteDataSource>(
    () => AllPropertiesRemoteDataSourceImpl(),
  );
}

void registerUsersManagementFeatureDependencies() {
  // Presentation
  sl.registerFactory<UsersManagementCubit>(
    () => UsersManagementCubit(getUsers: sl(), setUserActive: sl()),
  );

  // Domain
  sl.registerLazySingleton<GetUsers>(() => GetUsers(sl()));
  sl.registerLazySingleton<SetUserActive>(() => SetUserActive(sl()));

  // Data
  sl.registerLazySingleton<UsersManagementRepository>(
    () => UsersManagementRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<UsersManagementRemoteDataSource>(
    () => UsersManagementRemoteDataSourceImpl(),
  );
}

void registerAgentVerificationFeatureDependencies() {
  // Presentation
  sl.registerFactory<AgentVerificationCubit>(
    () => AgentVerificationCubit(getPendingAgents: sl(), verifyAgent: sl()),
  );

  // Domain
  sl.registerLazySingleton<GetPendingAgents>(() => GetPendingAgents(sl()));
  sl.registerLazySingleton<VerifyAgent>(() => VerifyAgent(sl()));

  // Data
  sl.registerLazySingleton<AgentVerificationRepository>(
    () => AgentVerificationRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<AgentVerificationRemoteDataSource>(
    () => AgentVerificationRemoteDataSourceImpl(),
  );
}

void registerReportsManagementFeatureDependencies() {
  // Presentation
  sl.registerFactory<ReportsManagementCubit>(
    () => ReportsManagementCubit(
      getReports: sl(),
      markReviewed: sl(),
      disableReportedProperty: sl(),
    ),
  );

  // Domain
  sl.registerLazySingleton<GetReports>(() => GetReports(sl()));
  sl.registerLazySingleton<MarkReviewed>(() => MarkReviewed(sl()));
  sl.registerLazySingleton<DisableReportedProperty>(
    () => DisableReportedProperty(sl()),
  );

  // Data
  sl.registerLazySingleton<ReportsManagementRepository>(
    () => ReportsManagementRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<ReportsManagementRemoteDataSource>(
    () => ReportsManagementRemoteDataSourceImpl(),
  );
}
