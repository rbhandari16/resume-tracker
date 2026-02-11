-- =========================================
-- Phase 4: Row Level Security (RLS)
-- =========================================
-- Purpose:
-- Enforce ownership and secure multi-user isolation.
-- =========================================


-- =========================================
-- 1️⃣ Enable RLS
-- =========================================
alter table applications enable row level security;
alter table events enable row level security;
alter table resume_versions enable row level security;


-- =========================================
-- 2️⃣ Applications Ownership Policies
-- =========================================

create policy "users can view own applications"
on applications
for select
using (auth.uid() = user_id);

create policy "users can insert own applications"
on applications
for insert
with check (auth.uid() = user_id);

create policy "users can update own applications"
on applications
for update
using (auth.uid() = user_id)
with check (auth.uid() = user_id);

create policy "users can delete own applications"
on applications
for delete
using (auth.uid() = user_id);


-- =========================================
-- 3️⃣ Events Derived Ownership Policies
-- =========================================

create policy "users can view own events"
on events
for select
using (
  exists (
    select 1
    from applications
    where applications.id = events.application_id
    and applications.user_id = auth.uid()
  )
);

create policy "users can insert own events"
on events
for insert
with check (
  exists (
    select 1
    from applications
    where applications.id = events.application_id
    and applications.user_id = auth.uid()
  )
);


-- =========================================
-- 4️⃣ Resume Versions (Read-only to Auth Users)
-- =========================================

create policy "authenticated users can view resume versions"
on resume_versions
for select
using (auth.role() = 'authenticated');
