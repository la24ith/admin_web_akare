-- شغّل هاد الملف على SQL Editor بمشروع Supabase قبل تجربة تسجيل الدخول من admin_web
-- لا يحذف أو يعدّل أي سياسة موجودة مسبقًا (تبقى سياسات المستخدم العادي كما هي)

create policy "admins_manage_all_properties"
on properties for all
using (exists (select 1 from users where id = auth.uid() and role = 'admin'))
with check (exists (select 1 from users where id = auth.uid() and role = 'admin'));

create policy "admins_manage_all_users"
on users for all
using (exists (select 1 from users u where u.id = auth.uid() and u.role = 'admin'))
with check (exists (select 1 from users u where u.id = auth.uid() and u.role = 'admin'));

create policy "admins_manage_all_agents"
on agents for all
using (exists (select 1 from users where id = auth.uid() and role = 'admin'))
with check (exists (select 1 from users where id = auth.uid() and role = 'admin'));

create policy "admins_manage_all_reports"
on property_reports for all
using (exists (select 1 from users where id = auth.uid() and role = 'admin'))
with check (exists (select 1 from users where id = auth.uid() and role = 'admin'));

-- اختياري: سجل تدقيق قرارات الأدمن
create table if not exists admin_actions_log (
  id uuid primary key default gen_random_uuid(),
  admin_user_id uuid not null references users(id),
  action_type text not null,
  target_table text not null,
  target_id uuid not null,
  notes text,
  created_at timestamptz not null default now()
);
