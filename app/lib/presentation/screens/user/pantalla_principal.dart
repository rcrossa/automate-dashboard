import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:msasb_app/domain/entities/user_session.dart';
import 'package:msasb_app/presentation/providers/user_provider.dart';
import 'package:msasb_app/widgets/module_guard.dart';
import '../company/company_dashboard_screen.dart';
import '../branch/branch_dashboard_screen.dart';
import '../super_admin/super_admin_dashboard_screen.dart';
import 'widgets/user_error_view.dart';
import 'widgets/user_profile_screen.dart';
import 'widgets/dashboard_fallbacks.dart';

class PantallaPrincipal extends ConsumerStatefulWidget {
  final VoidCallback? onLogout;
  const PantallaPrincipal({super.key, this.onLogout});
  @override
  ConsumerState<PantallaPrincipal> createState() => _PantallaPrincipalState();
}

class _PantallaPrincipalState extends ConsumerState<PantallaPrincipal> {
  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userStateProvider);

    return userState.when(
      data: (session) {
        if (session.usuario == null) {
          return UserErrorView(onLogout: widget.onLogout);
        }
        return _buildDashboardContent(session);
      },
      loading: () => Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (err, stack) => UserErrorView(onLogout: widget.onLogout),
    );
  }

  Widget _buildDashboardContent(UserSession session) {
    // 0. Si es Super Admin, mostrar Dashboard de Super Admin
    if (session.isSuperAdmin || session.currentRole == 'super_admin') {
      return const SuperAdminDashboardScreen();
    }

    // 1. Si es Admin, mostrar Dashboard de Empresa (Maneja su propio Scaffold/Layout)
    if (session.currentRole == 'admin') {
      return ModuleGuard(
        moduleCode: 'dashboard',
        fallback: DashboardFallbacks.buildAdminFallback(context, session.usuario!, empresa: session.empresa),
        child: const CompanyDashboardScreen(),
      );
    }

    // 2. Si es Gerente o Staff (rol 'usuario'), mostrar Dashboard de Sucursal
    if (session.currentRole == 'gerente' || session.currentRole == 'staff' || session.currentRole == 'usuario') {
      return ModuleGuard(
        moduleCode: 'dashboard',
        fallback: DashboardFallbacks.buildStandardFallback(context, session.usuario!),
        child: BranchDashboardScreen(session: session),
      );
    }

    // 3. Si es Usuario normal (o fallback), mostrar vista básica con Scaffold por defecto
    return UserProfileScreen(
      usuario: session.usuario,
      onLogout: widget.onLogout,
    );
  }
}

