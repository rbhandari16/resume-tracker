-- =========================================
-- Phase 3: Core Database Schema
-- =========================================
-- This file defines structural foundation only.
-- No RLS, no policies, no views, no analytics.
-- =========================================

-- 1️⃣ Enable UUID extension
create extension if not exists "uuid-ossp";


-- =========================================
-- 2️⃣ Resume Versions
-- =========================================
create table resume_versions (
  id uuid primary key default uuid_generate_v4(),
  name text not null unique,
  created_at timestamptz default now()
);


-- =========================================
-- 3️⃣ Applications (Ownership Anchor)
-- =========================================
create table applications (
  id uuid primary key default uuid_generate_v4(),

  user_id uuid not null
    references auth.users(id)
    on delete cascade,

  company text not null,
  role text not null,

  slug text not null unique,

  resume_version_id uuid
    references resume_versions(id),

  status text not null default 'applied',

  applied_at timestamptz default now(),
  last_activity_at timestamptz,

  notes text,

  created_at timestamptz default now(),
  updated_at timestamptz default now()
);


-- =========================================
-- 4️⃣ Events (Append-Only)
-- =========================================
create table events (
  id uuid primary key default uuid_generate_v4(),

  application_id uuid not null
    references applications(id)
    on delete cascade,

  event_type text not null,
  event_value text,

  timestamp timestamptz default now()
);


-- =========================================
-- 5️⃣ Indexes
-- =========================================
create index idx_applications_user_id
on applications(user_id);

create index idx_applications_slug
on applications(slug);

create index idx_events_application_id
on events(application_id);

create index idx_events_event_type
on events(event_type);

create index idx_events_timestamp
on events(timestamp);


-- =========================================
-- 6️⃣ Updated_at Trigger
-- =========================================
create or replace function set_updated_at()
returns trigger as $$
begin
  new.updated_at = now();
  return new;
end;
$$ language plpgsql;

create trigger applications_updated_at
before update on applications
for each row
execute procedure set_updated_at();


-- =========================================
-- 7️⃣ Seed Resume Versions
-- =========================================
insert into resume_versions (name)
values
  ('v1_safe'),
  ('v2_tailored'),
  ('v3_experimental');
