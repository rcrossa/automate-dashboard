import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:msasb_app/l10n/generated/app_localizations.dart';
import 'package:msasb_app/presentation/providers/admin_repository_provider.dart';
import 'package:msasb_app/utils/error_handler.dart';

class InvitacionCard extends ConsumerWidget {
  final Map<String, dynamic> invitacionData;
  final VoidCallback onDeleted;

  const InvitacionCard({
    super.key,
    required this.invitacionData,
    required this.onDeleted,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 600;

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          color: Colors.orange.shade50,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.mail_outline),
                title: Text(invitacionData['email']),
                subtitle: Text('${invitacionData['empresas']['nombre']} - ${invitacionData['roles']['nombre']}'),
                trailing: isSmallScreen ? null : _buildDeleteButton(context, ref),
              ),
              if (isSmallScreen)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0, right: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _buildDeleteButton(context, ref),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDeleteButton(BuildContext context, WidgetRef ref) {
    return IconButton(
      icon: const Icon(Icons.delete, color: Colors.red),
      onPressed: () async {
        try {
          final repo = ref.read(adminRepositoryProvider);
          await repo.deleteInvitation(invitacionData['id'].toString());
          if (!context.mounted) return;
          
          final l10n = AppLocalizations.of(context)!;
          ErrorHandler.showSuccess(context, l10n.invitationDeleteSuccess);
          onDeleted();
        } catch (e) {
          if (!context.mounted) return;
          
          ErrorHandler.showError(context, e);
        }
      },
    );
  }
}
