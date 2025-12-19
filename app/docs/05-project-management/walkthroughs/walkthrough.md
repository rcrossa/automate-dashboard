# Walkthrough - Super Admin Dashboard

## Changes
### Services
- **SuperAdminService**: Created to handle privileged operations:
    - `crearEmpresa`: Inserts new company and default branch.
    - `invitarUsuario`: Inserts into `invitaciones` table.
    - `listarEmpresas`: Fetches all companies.

### UI
- **SuperAdminDashboardScreen**:
    - Lists all registered companies.
    - Floating Action Button to open "Create Company" dialog.
    - Dialog includes fields for Company Name, Code, Address, and Initial Admin Email.
    - Triggers the service to create the company and invite the admin.

### Navigation
- **AppDrawer**: Updated to route `super_admin` users to `SuperAdminDashboardScreen`.

## Verification Results
### Automated Tests
- Ran `flutter analyze`. Code is clean.

### Manual Verification
- **Access**: Super Admin user sees the new dashboard option.
- **Creation**: Creating a company adds it to the list.
- **Invitation**: Inviting an email creates a row in `invitaciones` (needs DB check).
