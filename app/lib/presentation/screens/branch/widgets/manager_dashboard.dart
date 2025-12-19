import 'package:flutter/material.dart';
import 'package:msasb_app/presentation/screens/client/client_list_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:msasb_app/domain/entities/sucursal.dart';
import 'package:msasb_app/domain/entities/usuario_con_permisos.dart';
import 'package:msasb_app/widgets/app_drawer.dart';
import 'package:msasb_app/l10n/generated/app_localizations.dart';
import 'package:msasb_app/widgets/language_selector.dart';
import 'package:msasb_app/presentation/providers/user_provider.dart';

class ManagerDashboard extends ConsumerWidget {
  final Sucursal? sucursal;
  final UsuarioConPermisos? usuario;

  const ManagerDashboard({super.key, this.sucursal, this.usuario});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    // Fallback to provider if not passed, but we intend to pass it.
    final userFromProvider = ref.watch(userStateProvider).asData?.value.usuario;
    final effectiveUser = usuario ?? userFromProvider;

    return Scaffold(
      appBar: AppBar(
        title: Text(sucursal?.nombre ?? l10n.branchPanel),
        actions: const [
          LanguageSelector(),
          SizedBox(width: 8),
        ],
      ),
      drawer: AppDrawer(usuario: effectiveUser),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.storefront, size: 64, color: Colors.green),
            const SizedBox(height: 16),
            Text(
              l10n.branchLabel(sucursal?.nombre ?? ''),
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(l10n.branchManagementPanel),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                // Navegar a reclamos
              },
              icon: const Icon(Icons.warning_amber),
              label: Text(l10n.viewClaims),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const ClientListScreen()),
                );
              },
              icon: const Icon(Icons.people),
              label: Text(l10n.clients),
            ),
            const SizedBox(height: 16),

            ElevatedButton.icon(
              onPressed: () {
                // Navegar a interacciones
              },
              icon: const Icon(Icons.history),
              label: Text(l10n.viewInteractions),
            ),
          ],
        ),
      ),
    );
  }
}
