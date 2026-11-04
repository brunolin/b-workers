# B-Workers 1.0
Private dark-mode employee timesheet and daily-rate tracker.

## Setup
1. Create a Supabase project. In SQL Editor, run `supabase/schema.sql`.
2. In Supabase Authentication, create your administrator user (email/password). Disable public sign-ups in Auth settings.
3. Find that user's UUID in Authentication > Users, then run `insert into public.admins(user_id) values ('YOUR_AUTH_USER_UUID');` in SQL Editor.
4. Copy `.env.example` to `.env.local`; fill in the Supabase project URL and **publishable/anon** key. Never use the service-role key in the browser.
5. Run `npm install` and `npm run dev` (Node.js 20+). Visit http://localhost:3000.
6. Deploy to Vercel by importing the project from GitHub, setting the same environment variables. Vercel provides HTTPS.

## Features
Login, employees with individual rates, Monday–Sunday timesheet, full/half/no-work entries, service descriptions, weekly close/reopen, dashboard, employee-filtered weekly report, CSV export, browser Print to PDF. All work records store the rate at the time of entry.

## Notes
- Closed weeks are protected against work-log changes in the database, not only in the UI.
- Changing an employee's rate does not change existing work logs. Editing an existing log **does** capture the current rate; use caution if updating historical records.
- This is a payroll *estimate*, not a tax/payroll processing or labor-law compliance tool. Check local wage/hour and overtime obligations before using for actual payroll.
- Supabase offers managed backups depending on plan. Configure database backups and recovery appropriate to your needs.
- Only authorized users listed in `admins` can access business tables; don't share admin credentials.
- PWA installation and a dedicated monthly-report screen are not yet implemented in this initial source version.
