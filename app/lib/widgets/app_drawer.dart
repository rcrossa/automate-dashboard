import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:msasb_app/presentation/screens/client/client_list_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/entities/usuario_con_permisos.dart';
import 'package:msasb_app/presentation/providers/module_provider.dart';
import 'package:msasb_app/presentation/providers/user_provider.dart';
import 'package:msasb_app/presentation/widgets/company_logo.dart'; // ✅ Import

import 'package:msasb_app/presentation/screens/company/company_dashboard_screen.dart';

import 'package:msasb_app/presentation/screens/super_admin/super_admin_dashboard_screen.dart';
import 'package:msasb_app/presentation/screens/user/widgets/user_profile_screen.dart';
import '../l10n/generated/app_localizations.dart';
import 'language_selector.dart';
import 'package:msasb_app/presentation/screens/crm/config/crm_config_screen.dart';
import 'package:msasb_app/presentation/screens/crm/claims/claims_list_screen.dart';

class AppDrawer extends ConsumerWidget {
  final UsuarioConPermisos? usuario;
  final VoidCallback? onLogout;

  const AppDrawer({
    super.key,
    required this.usuario,
    this.onLogout,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final userState = ref.watch(userStateProvider);
    final activeModulesFunc = ref.watch(activeModulesProvider);
    final activeModules = activeModulesFunc.asData?.value ?? [];

    // Use user from provider (more reliable) or fallback to widget argument
    final userResult = userState.asData?.value.usuario ?? usuario;

    // List of active modules (default empty if loading/error for now)
    

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.blue),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo de empresa
                const CompanyLogo(
                  height: 48,
                  adaptToDarkMode: true,
                ),
                const SizedBox(height: 8),
                Text(
                  (userResult?.nombre != null && userResult!.nombre.isNotEmpty) 
                      ? userResult.nombre 
                      : l10n.noName,
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
                Text(
                  userResult?.email ?? '',
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: Text(l10n.drawerHome),
            onTap: () {
              Navigator.pop(context); // Cerrar drawer
              // Navegar al inicio (PantallaPrincipal) limpiando el stack
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          ),

          if (userResult?.rol == 'admin' || userResult?.rol == 'gerente' || userResult?.rol == 'super_admin')
            ListTile(
              leading: const Icon(Icons.admin_panel_settings),
              title: Text(l10n.drawerAdmin),
              onTap: () {
                Navigator.pop(context); // Cerrar drawer
                if (userResult?.rol == 'super_admin') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SuperAdminDashboardScreen()),
                  );
                } else if (userResult?.rol == 'admin') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CompanyDashboardScreen()),
                  );
                }
              },
            ),
          
          // Configuración CRM (Solo Admins)
          if ((userResult?.rol == 'admin' || userResult?.rol == 'super_admin') &&  
              activeModules.contains('reclamos'))
             ListTile(
              leading: const Icon(Icons.settings_applications),
              title: const Text('Configuración CRM'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CrmConfigScreen()),
                );
              },
             ),

          // Operación CRM (Todos si el módulo está activo)
          if (activeModules.contains('reclamos'))
             ListTile(
              leading: const Icon(Icons.assignment),
              title: const Text('Gestionar Reclamos'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ClaimsListScreen()),
                );
              },
             ),

          ListTile(
            leading: const Icon(Icons.people),
            title: Text(l10n.clients),
            onTap: () {
              Navigator.pop(context); // Cerrar drawer
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ClientListScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: Text(l10n.myProfile),
            onTap: () {
              Navigator.pop(context);
              // Navegar al perfil
              // Importar UserProfileScreen si es necesario (verificaremos imports)
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserProfileScreen(
                    usuario: usuario,
                    onLogout: onLogout, // Pasamos el callback
                  ),
                ),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(l10n.drawerLanguage),
            trailing: const LanguageSelector(),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: Text(l10n.drawerLogout),
            onTap: () async {
              await Supabase.instance.client.auth.signOut();
              if (onLogout != null) {
                onLogout!();
              } else {
                // Si no se pasa onLogout, forzamos ir al login o reiniciar la app
                // En este caso, PantallaPrincipal maneja el estado de sesión, así que
                // si estamos en otra pantalla, deberíamos volver a main o similar.
                // Como main.dart escucha cambios de sesión, esto debería actualizarse solo si estamos en el árbol correcto.
                if (context.mounted) {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
