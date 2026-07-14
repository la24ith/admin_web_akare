import 'package:supabase_flutter/supabase_flutter.dart';

/// نفس بيانات مشروع Supabase المستخدم بتطبيقي الزبون والوكيل — بدون أي تغيير.
/// استبدل القيمتين بنفس القيم الموجودة عندك بملف supabase_config.dart بمشروع الموبايل.
const String kSupabaseUrl = 'https://sowkmrqrmpciklebwqxy.supabase.co';

const String kSupabaseAnonKey =
    'sb_publishable_Hxr2XbRx3KYfimYu_h-QKw_BhQEzPp9';

Future<void> initSupabase() async {
  await Supabase.initialize(
    url: kSupabaseUrl,
    anonKey: kSupabaseAnonKey,
  );
}

/// متغيّر عام يُستخدم مباشرة بكل RemoteDataSourceImpl بدل sl()،
/// لأن SupabaseClient مش مسجّل بـ GetIt أصلًا.
SupabaseClient get supabase => Supabase.instance.client;
