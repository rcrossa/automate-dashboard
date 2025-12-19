import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:msasb_app/l10n/generated/app_localizations.dart';

class UserErrorView extends StatelessWidget {
  final VoidCallback? onLogout;

  const UserErrorView({super.key, this.onLogout});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 80, color: Colors.red),
            const SizedBox(height: 20),
            Text(
              l10n.userNotFoundDB,
              style: const TextStyle(fontSize: 20, color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                final user = Supabase.instance.client.auth.currentUser;
                if (user != null) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(l10n.authenticatedUserId),
                      content: SelectableText(user.id),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(l10n.close),
                        ),
                      ],
                    ),
                  );
                }
              },
              icon: const Icon(Icons.info_outline),
              label: Text(l10n.viewUserId),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () async {
                await Supabase.instance.client.auth.signOut();
                if (onLogout != null) onLogout!();
              },
              icon: const Icon(Icons.logout),
              label: Text(l10n.logout),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
