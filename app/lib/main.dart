import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/generated/app_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'presentation/screens/user/pantalla_principal.dart';
import 'presentation/screens/auth/login_pantalla.dart';
import 'package:msasb_app/presentation/providers/user_provider.dart';
import 'package:msasb_app/presentation/providers/locale_provider.dart';
import 'package:msasb_app/presentation/providers/theme_provider.dart';  // Theme provider

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );
  runApp(const ProviderScope(child: MiApp()));
}

class MiApp extends ConsumerWidget {
  const MiApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    
    // Try to use branding theme, fallback to themeColor from user
    final isDark = ref.watch(darkModeProvider);
    final brandingTheme = ref.watch(appThemeProvider(isDark: isDark));

    return MaterialApp(
      title: 'Mi Primera App',
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('es'), // Spanish
        Locale('en'), // English
      ],
      theme: brandingTheme,  // Use branding theme (has fallback to default)
      home: const SessionControl(),
    );
  }
}

class SessionControl extends ConsumerStatefulWidget {
  const SessionControl({super.key});
  @override
  ConsumerState<SessionControl> createState() => _SessionControlState();
}

class _SessionControlState extends ConsumerState<SessionControl> {
  bool loggedIn = Supabase.instance.client.auth.currentSession != null;

  @override
  void initState() {
    super.initState();
    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      final session = data.session;
      if (session != null && !loggedIn) {
        // Deferir la actualización para evitar "Modifying a provider..." error
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ref.read(userStateProvider.notifier).refresh().then((_) {
            if (mounted) {
              setState(() {
                loggedIn = true;
              });
            }
          });
        });
      } else if (session == null) {
        if (mounted) {
          setState(() {
            loggedIn = false;
          });
        }
        // También deferir esto por si acaso
        WidgetsBinding.instance.addPostFrameCallback((_) => ref.read(userStateProvider.notifier).clear());
      }
    });

    // Carga inicial si ya hay sesión
    if (loggedIn) {
      WidgetsBinding.instance.addPostFrameCallback((_) => ref.read(userStateProvider.notifier).refresh());
    }
  }

  void onLoginSuccess() {
    if (mounted) {
      setState(() {
        loggedIn = true;
      });
      // Asegurar que se carguen los datos al loguearse manualmente, deferido
      WidgetsBinding.instance.addPostFrameCallback((_) => ref.read(userStateProvider.notifier).refresh());
    }
  }

  void onLogout() {
    if (mounted) {
      setState(() {
        loggedIn = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: loggedIn
            ? PantallaPrincipal(key: const ValueKey('Principal'), onLogout: onLogout)
            : LoginPantalla(key: const ValueKey('Login'), onLoginSuccess: onLoginSuccess),
      ),
    );
  }
}

// ...existing code...
// El constructor con onLogout ya está definido en pantalla_principal.dart


