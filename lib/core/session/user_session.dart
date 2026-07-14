import 'package:flutter/foundation.dart';
import '../network/supabase_config.dart';

/// نفس فكرة UserSession بمشروع الموبايل، لكن هون بيتحقق حصرًا إنه الدور = admin.
/// كائن عام واحد (registerLazySingleton بـ GetIt) يُستخدم بـ redirect تبع go_router
/// وبأي مكان بالواجهة يحتاج معرفة بيانات الأدمن الحالي.
class UserSession extends ChangeNotifier {
  String? _userId;
  String? _fullName;
  String? _email;
  String? _role;
  bool _isLoading = false;

  String? get userId => _userId;
  String? get fullName => _fullName;
  String? get email => _email;
  String? get role => _role;
  bool get isLoading => _isLoading;

  bool get isLoggedIn => supabase.auth.currentSession != null;
  bool get isAdmin => _role == 'admin';

  /// يُستدعى بعد تسجيل الدخول وعند إقلاع التطبيق لو فيه Session محفوظة.
  Future<void> loadRole() async {
    final session = supabase.auth.currentSession;
    if (session == null) {
      _clear();
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final uid = session.user.id;
      final row = await supabase
          .from('users')
          .select('id, full_name, email, role')
          .eq('id', uid)
          .single();

      _userId = row['id'] as String;
      _fullName = row['full_name'] as String?;
      _email = row['email'] as String?;
      _role = row['role'] as String?;
    } catch (_) {
      _clear();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _clear() {
    _userId = null;
    _fullName = null;
    _email = null;
    _role = null;
  }

  Future<void> signOut() async {
    await supabase.auth.signOut();
    _clear();
    notifyListeners();
  }
}
