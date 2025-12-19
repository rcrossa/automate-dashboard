import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:msasb_app/domain/entities/usuario_con_permisos.dart';
import 'package:msasb_app/presentation/providers/user_provider.dart';
import 'package:msasb_app/widgets/app_drawer.dart';
import 'package:msasb_app/l10n/generated/app_localizations.dart';
import 'package:msasb_app/widgets/language_selector.dart';
import 'package:msasb_app/utils/error_message.dart';

class UserProfileScreen extends ConsumerWidget {
  final UsuarioConPermisos? usuario;
  final VoidCallback? onLogout;

  const UserProfileScreen({
    super.key,
    required this.usuario,
    this.onLogout,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final session = ref.watch(userStateProvider).asData?.value;
    final currentRole = session?.currentRole;
    final currentCompany = session?.empresa;
    final currentBranch = session?.sucursal;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: const [
          LanguageSelector(),
          SizedBox(width: 8),
        ],
      ),
      drawer: AppDrawer(
        usuario: usuario,
        onLogout: () async {
          // 1. Cerrar sesión en Supabase
          await Supabase.instance.client.auth.signOut();
          
          if (context.mounted) {
            // 2. Limpiar navegación (Cerrar Drawer, Dialogs, y Pantallas apiladas user profile)
            // Volver hasta la raíz (SessionControl)
            Navigator.of(context).popUntil((route) => route.isFirst);
            
            // 3. Notificar a SessionControl para cambiar a LoginScreen
            if (onLogout != null) onLogout!();
          }
        },
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${l10n.welcomeMessage}, ${usuario?.nombre ?? ''}',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      // Preferimos el usuario de la sesión actual (provider) para editar
                      final currentUser = session?.usuario ?? usuario;
                      if (currentUser != null) {
                        _showEditProfileDialog(context, ref, currentUser);
                      } else {
                         ErrorMessage.show(context, 'No user loaded to edit');
                      }
                    },
                  ),
                ],
              ),
              if (usuario?.username != null && usuario!.username!.isNotEmpty)
                Text(
                  '@${usuario!.username}',
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
            const SizedBox(height: 10),
            Text(
              l10n.roleDetected(currentRole ?? l10n.none),
              style: const TextStyle(fontSize: 18, color: Colors.blue, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            
            const SizedBox(height: 20),
            Text(
              l10n.emailLabelWithVal(usuario?.email ?? ''),
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text(
              l10n.permissions,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              children: usuario?.capacidades.map((c) => Chip(label: Text(c))).toList() ?? [],
            ),
            const SizedBox(height: 20),
            if (currentCompany != null) ...[
              const Divider(),
              Text(
                l10n.companyLabelWithVal(currentCompany.nombre),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              if (currentBranch != null)
                Text(l10n.branchLabelWithVal(currentBranch.nombre)),
            ] else ...[
              const Divider(),
              Text(
                l10n.noCompanyAssigned,
                style: const TextStyle(color: Colors.orange),
              ),
            ],
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  void _showEditProfileDialog(BuildContext context, WidgetRef ref, UsuarioConPermisos? usuario) {
    if (usuario == null) return;
    
    final nombreCtrl = TextEditingController(text: usuario.nombre);
    final usernameCtrl = TextEditingController(text: usuario.username);
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.editProfile),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nombreCtrl,
              decoration: InputDecoration(labelText: l10n.nameLabel),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: usernameCtrl,
              decoration: InputDecoration(labelText: l10n.usernameFieldLabel),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                final client = Supabase.instance.client;
                final updates = <String, dynamic>{
                  'nombre': nombreCtrl.text.trim(),
                  'username': usernameCtrl.text.trim(),
                };
                
                await client.from('usuarios').update(updates).eq('id', Supabase.instance.client.auth.currentUser!.id);
                
                await client.auth.updateUser(
                  UserAttributes(data: updates),
                );

                if (context.mounted) {
                  Navigator.pop(context);
                  ErrorMessage.showSuccess(context, l10n.profileUpdated);
                  ref.read(userStateProvider.notifier).refresh();
                }
              } catch (e) {
                if (context.mounted) {
                  ErrorMessage.show(context, e.toString());
                }
              }
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }
}
