import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:msasb_app/presentation/providers/user_provider.dart';
import 'package:msasb_app/presentation/providers/auth_repository_provider.dart';
import 'package:msasb_app/l10n/generated/app_localizations.dart';
import 'package:msasb_app/utils/error_handler.dart';
import 'widgets/login_branding.dart';
import 'widgets/login_form.dart';
import 'package:msasb_app/widgets/language_selector.dart';
import 'package:msasb_app/utils/responsive_helper.dart';

class LoginPantalla extends ConsumerStatefulWidget {
  final VoidCallback? onLoginSuccess;
  const LoginPantalla({super.key, this.onLoginSuccess});

  @override
  ConsumerState<LoginPantalla> createState() => _LoginPantallaState();
}

class _LoginPantallaState extends ConsumerState<LoginPantalla> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController usernameController = TextEditingController(); // Added
  String mensaje = '';
  bool cargando = false;
  bool modoRegistro = false; // false = login, true = registro

  final _formKey = GlobalKey<FormState>();

  Future<void> login() async {
    if (!_formKey.currentState!.validate()) return;
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    setState(() { cargando = true; mensaje = ''; });
    
    try {
      final authRepo = ref.read(authRepositoryProvider);
      
      // 1. Iniciar sesión
      await authRepo.signInWithEmailAndPassword(
        emailController.text.trim(), 
        passwordController.text
      );

      if (!mounted) return;
      
      // 2. Refrescar estado global
      await ref.read(userStateProvider.notifier).refresh();

      // 3. Obtener usuario limpio desde repositorio
      final usuario = await authRepo.getCurrentUser();
      
      if (!mounted) return;
      
      if (usuario != null) {
        setState(() { mensaje = l10n.loginSuccess; });
        Future.delayed(const Duration(milliseconds: 500), () {
          if (!mounted) return;
          if (widget.onLoginSuccess != null) widget.onLoginSuccess!();
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop(usuario);
          }
        });
      } else {
        setState(() { mensaje = l10n.userFetchError; });
      }
    } catch (e) {
      if (!mounted) return;
      ErrorHandler.showError(context, e);
      setState(() => cargando = false);
    }
  }

  Future<void> registro() async {
    if (!_formKey.currentState!.validate()) return;
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    setState(() { cargando = true; mensaje = ''; });
    
    try {
      await ref.read(authRepositoryProvider).signUp(
        email: emailController.text.trim(),
        password: passwordController.text,
        nombre: nombreController.text.trim(),
        username: usernameController.text.trim(),
      );
      
      if (!mounted) return;
      setState(() { cargando = false; mensaje = l10n.registerSuccess; });
    } catch (e) {
      if (!mounted) return;
      ErrorHandler.showError(context, e);
      setState(() => cargando = false);
    }
  }

  Future<void> recuperarPassword() async {
    final l10n = AppLocalizations.of(context)!;
    if (emailController.text.trim().isEmpty || !emailController.text.contains('@')) {
      if (!mounted) return;
      setState(() { mensaje = l10n.recoveryEmailInvalid; });
      return;
    }
    if (!mounted) return;
    setState(() { cargando = true; mensaje = ''; });
    try {
      await ref.read(authRepositoryProvider).resetPasswordForEmail(emailController.text.trim());
      if (!mounted) return;
      setState(() { cargando = false; mensaje = l10n.recoveryEmailSent; });
    } catch (e) {
      if (!mounted) return;
      ErrorHandler.showError(context, e);
      setState(() => cargando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              // Usar ResponsiveHelper para detectar desktop
              if (ResponsiveHelper.isDesktop(context)) {
                // Desktop Layout: Split Screen
                return Row(
                  children: [
                    // Left Side: Branding / Hero Image
                    const Expanded(
                      flex: 5,
                      child: LoginBranding(),
                    ),
                    // Right Side: Login Form
                    Expanded(
                      flex: 4,
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 400),
                          child: _buildLoginForm(),
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                // Mobile Layout: Centered Form
                return Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24.0),
                    child: _buildLoginForm(),
                  ),
                );
              }
            },
          ),
          Positioned(
            top: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: const LanguageSelector(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginForm() {
    return LoginForm(
      formKey: _formKey,
      emailController: emailController,
      passwordController: passwordController,
      nombreController: nombreController,
      usernameController: usernameController, // Added
      modoRegistro: modoRegistro,
      cargando: cargando,
      mensaje: mensaje,
      onToggleMode: () {
        setState(() {
          modoRegistro = !modoRegistro;
          mensaje = '';
        });
      },
      onLogin: login,
      onRegistro: registro,
      onRecuperarPassword: recuperarPassword,
    );
  }
}
