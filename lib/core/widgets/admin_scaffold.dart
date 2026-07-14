import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../di/injection_container.dart';
import '../session/user_session.dart';
import '../theme/app_colors.dart';
import 'admin_sidebar.dart';

/// نفس فكرة AgentScaffold (StatefulShellRoute.indexedStack) لكن بتخطيط Row
/// مناسب لشاشة واسعة، مع Sidebar ثابت على اليمين (الواجهة RTL).
class AdminScaffold extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const AdminScaffold({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Row(
        children: [
          // بـ RTL: أول عنصر بالـ Row يظهر أقصى اليمين بصريًا.
          Expanded(child: navigationShell),
          AdminSidebar(
            currentIndex: navigationShell.currentIndex,
            onSelect: (i) => navigationShell.goBranch(
              i,
              initialLocation: i == navigationShell.currentIndex,
            ),
            userSession: sl<UserSession>(),
            onLogout: () async {
              await sl<UserSession>().signOut();
              // signOut يستدعي notifyListeners، لكن go_router ما بيعيد تقييم
              // الـ redirect إلا مع تنقّل جديد — لذلك نستدعي go('/login') يدويًا هون.
              if (context.mounted) {
                context.go('/login');
              }
            },
          ),
        ],
      ),
    );
  }
}
