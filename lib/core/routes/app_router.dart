import 'package:go_router/go_router.dart';
import '../di/injection_container.dart';
import '../network/supabase_config.dart';
import '../session/user_session.dart';
import '../widgets/admin_scaffold.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/admin_dashboard/presentation/screens/admin_dashboard_screen.dart';
import '../../features/property_moderation/presentation/screens/property_moderation_screen.dart';
import '../../features/property_moderation/presentation/screens/property_review_detail_screen.dart';
import '../../features/all_properties/presentation/screens/all_properties_screen.dart';
import '../../features/users_management/presentation/screens/users_management_screen.dart';
import '../../features/agent_verification/presentation/screens/agent_verification_screen.dart';
import '../../features/reports_management/presentation/screens/reports_management_screen.dart';

/// كل الروابط بهاد الملف — نفس المبدأ المتّبع بمشروع الموبايل، لكن هاد ملف
/// مستقل بالكامل لأن admin_web مشروع Flutter منفصل.
class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: '/login',
    refreshListenable: sl<UserSession>(),
    redirect: (context, state) async {
      final userSession = sl<UserSession>();
      final loggingIn = state.matchedLocation == '/login';
      final hasSupabaseSession = supabase.auth.currentSession != null;

      // ما فيه Session بـ Supabase إطلاقًا → لازم /login
      if (!hasSupabaseSession) {
        return loggingIn ? null : '/login';
      }

      // فيه Session لكن userSession لسا ما حمّلت الدور (مثلًا Refresh بالمتصفح)
      if (userSession.role == null && !userSession.isLoading) {
        await userSession.loadRole();
      }

      // الدور غير admin → ارفض الدخول كليًا، سجّل خروجه وارجعه لـ /login
      if (!userSession.isAdmin) {
        if (hasSupabaseSession) {
          await userSession.signOut();
        }
        return '/login';
      }

      // أدمن مسجّل دخول وواقف على /login → وجّهه مباشرة للوحة التحكم
      if (loggingIn) return '/admin/dashboard';

      return null; // بدون إعادة توجيه
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AdminScaffold(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/admin/dashboard',
              builder: (context, state) => const AdminDashboardScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/admin/properties/pending',
              builder: (context, state) => const PropertyModerationScreen(),
              routes: [
                GoRoute(
                  path: ':id/review',
                  builder: (context, state) => PropertyReviewDetailScreen(
                    propertyId: state.pathParameters['id']!,
                  ),
                ),
              ],
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/admin/properties',
              builder: (context, state) => const AllPropertiesScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/admin/users',
              builder: (context, state) => const UsersManagementScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/admin/agents/pending',
              builder: (context, state) => const AgentVerificationScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/admin/reports',
              builder: (context, state) => const ReportsManagementScreen(),
            ),
          ]),
        ],
      ),
    ],
  );
}
