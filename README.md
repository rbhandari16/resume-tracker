@"
# resume-tracker - Phase 3 - Database Schema Only
Current progress: Phase 3 - Database Schema Only

What exists:
- Core Tables
- Constraints
- Indexes

What does not exist yet:
- RLS
- Background Routes 
- Analytics Views 
- Deployment

# This repository is maintained as a reference system.
"@ | Set- Content README.md


## Phase 4 — Row Level Security (RLS)

RLS enforces strict data ownership:

- Users can access only their own applications.
- Events derive ownership via applications.
- Resume versions are readable by authenticated users.
- Service role bypasses RLS (backend only).

This ensures multi-user isolation and secure event tracking.

