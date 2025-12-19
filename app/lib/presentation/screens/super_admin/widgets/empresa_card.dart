import 'package:flutter/material.dart';
import 'package:msasb_app/domain/entities/empresa.dart';
import '../../company/company_dashboard_screen.dart';
import '../../company/marketplace_screen.dart';

import 'package:msasb_app/l10n/generated/app_localizations.dart';

class EmpresaCard extends StatelessWidget {
  final Map<String, dynamic> empresaData;

  const EmpresaCard({super.key, required this.empresaData});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 600;
        
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          elevation: 2,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                contentPadding: const EdgeInsets.all(16),
                leading: CircleAvatar(
                  backgroundColor: Colors.blue.shade100,
                  child: Text(
                    empresaData['nombre'][0].toUpperCase(),
                    style: TextStyle(color: Colors.blue.shade900),
                  ),
                ),
                title: Text(empresaData['nombre'], style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text('${l10n.codeLabel}: ${empresaData['codigo']}'),
                    const SizedBox(height: 4),
                    Text(
                      '${l10n.createdLabel}: ${empresaData['fecha_creacion'].toString().split(' ')[0]}',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                onTap: () {
                  final empresaObj = Empresa.fromJson(empresaData);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CompanyDashboardScreen(empresaOverride: empresaObj),
                    ),
                  );
                },
                trailing: isSmallScreen ? null : _buildActions(context),
              ),
              if (isSmallScreen)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0, right: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _buildActions(context),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActions(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.storefront, color: Colors.blue),
          tooltip: l10n.manageModulesTooltip,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MarketplaceScreen(empresaId: empresaData['id']),
              ),
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.settings_applications, color: Colors.orange),
          tooltip: l10n.manageCompanyTooltip,
          onPressed: () {
            final empresaObj = Empresa.fromJson(empresaData);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CompanyDashboardScreen(empresaOverride: empresaObj),
              ),
            );
          },
        ),
      ],
    );
  }
}
