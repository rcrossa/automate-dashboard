import 'package:flutter/material.dart';
import 'package:msasb_app/l10n/generated/app_localizations.dart';

class LoginForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController nombreController;
  final TextEditingController usernameController; // Added
  final bool modoRegistro;
  final bool cargando;
  final String mensaje;
  final VoidCallback onToggleMode;
  final VoidCallback onLogin;
  final VoidCallback onRegistro;
  final VoidCallback onRecuperarPassword;

  const LoginForm({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.nombreController,
    required this.usernameController, // Added
    required this.modoRegistro,
    required this.cargando,
    required this.mensaje,
    required this.onToggleMode,
    required this.onLogin,
    required this.onRegistro,
    required this.onRecuperarPassword,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width <= 800;
    final l10n = AppLocalizations.of(context)!;

    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (isMobile) ...[
            const Icon(Icons.business, size: 80, color: Colors.blue),
            const SizedBox(height: 16),
            Text(
              l10n.welcomeMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
          ],

          // Switch entre Login y Registro
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(l10n.loginTitle, style: TextStyle(fontWeight: !modoRegistro ? FontWeight.bold : FontWeight.normal)),
              Switch(
                key: const Key('auth_mode_switch'),
                value: modoRegistro,
                onChanged: (_) => onToggleMode(),
              ),
              Text(l10n.registerTitle, style: TextStyle(fontWeight: modoRegistro ? FontWeight.bold : FontWeight.normal)),
            ],
          ),
          const SizedBox(height: 24),

          // Campo Nombre (solo en registro)
          if (modoRegistro) ...[
            TextFormField(
              key: const Key('register_name_field'),
              controller: nombreController,
              decoration: InputDecoration(
                labelText: l10n.nameLabel,
                prefixIcon: const Icon(Icons.person),
                border: const OutlineInputBorder(),
              ),
              validator: (value) {
                if (modoRegistro && (value == null || value.isEmpty)) {
                  return 'Ingresa tu nombre';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            // Campo Username (solo en registro)
            TextFormField(
              key: const Key('register_username_field'),
              controller: usernameController,
              decoration: InputDecoration(
                labelText: l10n.usernameFieldLabel,
                prefixIcon: const Icon(Icons.alternate_email),
                border: const OutlineInputBorder(),
              ),
              validator: (value) {
                if (modoRegistro && (value == null || value.isEmpty)) {
                  return l10n.validationError; // Using generic validation error for now or add specific key
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
          ],

          // Campo Email
          TextFormField(
            key: const Key('login_email_field'),
            controller: emailController,
            decoration: InputDecoration(
              labelText: l10n.loginLabel,
              prefixIcon: const Icon(Icons.email),
              border: const OutlineInputBorder(),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) return 'Ingresa tu usuario o email';
              // if (!value.contains('@')) return 'Email inválido'; // Allow username
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Campo Contraseña
          TextFormField(
            key: const Key('login_password_field'),
            controller: passwordController,
            decoration: InputDecoration(
              labelText: l10n.passwordLabel,
              prefixIcon: const Icon(Icons.lock),
              border: const OutlineInputBorder(),
            ),
            obscureText: true,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) {
              // Ejecutar login o registro según el modo
              if (modoRegistro) {
                onRegistro();
              } else {
                onLogin();
              }
            },
            validator: (value) {
              if (value == null || value.isEmpty) return 'Ingresa tu contraseña';
              if (value.length < 6) return 'Mínimo 6 caracteres';
              return null;
            },
          ),
          const SizedBox(height: 24),

          // Indicador de carga o botones
          if (cargando)
            const Center(child: CircularProgressIndicator())
          else ...[
            SizedBox(
              height: 50,
              child: ElevatedButton.icon(
                key: Key(modoRegistro ? 'register_submit_button' : 'login_submit_button'),
                onPressed: modoRegistro ? onRegistro : onLogin,
                icon: Icon(modoRegistro ? Icons.person_add : Icons.login),
                label: Text(modoRegistro ? l10n.registerButton : l10n.loginButton),
                style: ElevatedButton.styleFrom(
                  backgroundColor: modoRegistro ? Colors.green : Colors.blue,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            if (!modoRegistro) ...[
              const SizedBox(height: 12),
              TextButton(
                onPressed: onRecuperarPassword,
                child: Text(l10n.forgotPassword),
              ),
            ],
          ],

          const SizedBox(height: 16),
          if (mensaje.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: mensaje.contains('exitoso') ? Colors.green.shade50 : Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                mensaje,
                style: TextStyle(
                  color: mensaje.contains('exitoso') ? Colors.green : Colors.red,
                ),
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }
}
