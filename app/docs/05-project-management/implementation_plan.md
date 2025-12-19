# Implementation Plan - Multi-Tenancy & Documentation

## Goal Description
1.  **Documentation**: Move all documentation to the project's `docs/` folder so it's accessible in the repo.
2.  **Multi-Tenancy Strategy**: Refine the RLS approach to handle "Company Cleanup" efficiently.

## 1. Documentation Strategy
- Create a `docs/` directory in the project root.
- Move existing artifacts (`architecture_proposal.md`, `database_schema.sql`, etc.) there.
- Add a `README.md` in `docs/` acting as an index.

## 2. Multi-Tenancy Refinement (Addressing User Concerns)
### The "Company Code" Question
- **Yes, only once**: The user enters the company code (or subdomain) *once* during the initial setup/login. We store this in `SharedPreferences` (local storage). Subsequent opens use this stored context.

### The "Data Cleanup" Concern (Option B)
- **Problem**: Deleting rows scattered across 20 tables is tedious when a company leaves.
- **Solution**: **Soft Delete + Cascading Deletes**.
    1.  **Cascading Deletes**: Define Foreign Keys with `ON DELETE CASCADE`. When you delete a row in `empresas`, Postgres *automatically* deletes all linked users, branches, interactions, and claims. It's instant and clean.
    2.  **Soft Delete**: Add `deleted_at` column. To "cancel" a company, you just mark it as deleted. The data stays for 30 days (for recovery) and then a cron job wipes it.

### Why Option B (RLS) is still better
- **Maintenance**: Managing 100 separate DB connections/migrations is a nightmare compared to `ON DELETE CASCADE`.
- **Cost**: One Supabase instance vs 100.

## Proposed Changes
### Documentation
#### [NEW] [docs/README.md](file:///Users/robertorossa/Desktop/Desarrollo/flutter/mi_primera_app/docs/README.md)
- Index of all documentation.

### Database
#### [MODIFY] [multi_tenancy_schema.sql](file:///Users/robertorossa/Desktop/Desarrollo/flutter/mi_primera_app/docs/database/multi_tenancy_schema.sql)
- Update schema to include `ON DELETE CASCADE` for easy cleanup.

### App Logic
#### [NEW] [user_context.dart](file:///Users/robertorossa/Desktop/Desarrollo/flutter/mi_primera_app/lib/services/user_context.dart)
- Handle Company Code persistence.
