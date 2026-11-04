create table public.admins (user_id uuid primary key references auth.users(id) on delete cascade);
create or replace function public.is_admin() returns boolean language sql stable security definer set search_path = '' as $$ select exists(select 1 from public.admins where user_id=(select auth.uid())) $$;
create table public.employees (id uuid primary key default gen_random_uuid(),name text not null check(length(trim(name))>0),daily_rate numeric(12,2) not null check(daily_rate>=0),active boolean not null default true,created_at timestamptz not null default now());
create table public.work_logs (id uuid primary key default gen_random_uuid(),employee_id uuid not null references public.employees(id),work_date date not null,day_fraction numeric(2,1) not null check(day_fraction in (0,0.5,1)),description text not null default '',daily_rate_snapshot numeric(12,2) not null check(daily_rate_snapshot>=0),created_at timestamptz not null default now(),unique(employee_id,work_date));
create table public.week_closures (week_start date primary key,closed_at timestamptz not null default now());
create or replace function public.prevent_closed_week_changes() returns trigger language plpgsql set search_path='' as $$ declare d date; begin d:=case when tg_op='DELETE' then old.work_date else new.work_date end; if exists(select 1 from public.week_closures where week_start=(d - ((extract(isodow from d)::int - 1)))::date) then raise exception 'Week is closed'; end if; return case when tg_op='DELETE' then old else new end; end $$;
create trigger enforce_closed_week before insert or update or delete on public.work_logs for each row execute function public.prevent_closed_week_changes();
alter table public.admins enable row level security;
alter table public.employees enable row level security;
alter table public.work_logs enable row level security;
alter table public.week_closures enable row level security;
create policy "admin read admins" on public.admins for select to authenticated using (user_id=(select auth.uid()));
create policy "admin employees" on public.employees for all to authenticated using (public.is_admin()) with check(public.is_admin());
create policy "admin logs" on public.work_logs for all to authenticated using (public.is_admin()) with check(public.is_admin());
create policy "admin closures" on public.week_closures for all to authenticated using (public.is_admin()) with check(public.is_admin());
-- After creating your user in Supabase Auth, run in SQL Editor:
-- insert into public.admins(user_id) values ('YOUR_AUTH_USER_UUID');
