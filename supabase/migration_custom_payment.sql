-- B-Workers v1.1: custom payment that replaces the normal daily-rate calculation.
-- Safe to run on the existing database; existing records remain standard payments.
alter table public.work_logs
  add column if not exists payment_type text not null default 'standard'
    check (payment_type in ('standard', 'custom')),
  add column if not exists custom_amount numeric(12,2)
    check (custom_amount is null or custom_amount >= 0),
  add column if not exists payment_details text;

-- Existing rows keep payment_type='standard'. Custom records store their exact
-- replacement amount in custom_amount; day_fraction is set to 1 for day-equivalent reporting.
