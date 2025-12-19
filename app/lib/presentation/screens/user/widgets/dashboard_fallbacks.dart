import 'package:flutter/material.dart';
import 'package:msasb_app/domain/entities/usuario_con_permisos.dart';
import 'package:msasb_app/domain/entities/empresa.dart';
import 'package:msasb_app/widgets/app_drawer.dart';
import '../../company/marketplace_screen.dart';
import 'package:msasb_app/l10n/generated/app_localizations.dart';

class DashboardFallbacks {
  static Widget buildAdminFallback(BuildContext context, UsuarioConPermisos? usuario, {Empresa? empresa}) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.dashboardInactive)),
      drawer: AppDrawer(usuario: usuario),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.dashboard_customize, size: 80, color: Colors.orange),
            const SizedBox(height: 20),
            Text(
              l10n.dashboardDisabledMessage,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(l10n.adminActivateMessage),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () {
                if (empresa != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MarketplaceScreen(empresaId: empresa.id),
                    ),
                  );
                }
              },
              icon: const Icon(Icons.storefront),
              label: Text(l10n.goToMarketplace),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget buildStandardFallback(BuildContext context, UsuarioConPermisos? usuario) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.accessDenied)),
      drawer: AppDrawer(usuario: usuario),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lock_outline, size: 80, color: Colors.grey),
            const SizedBox(height: 20),
            Text(
              l10n.dashboardNotActive,
              style: const TextStyle(fontSize: 20, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            Text(l10n.contactAdminMessage),
          ],
        ),
      ),
    );
  }
}
