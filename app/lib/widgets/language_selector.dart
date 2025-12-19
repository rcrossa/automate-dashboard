import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:msasb_app/presentation/providers/locale_provider.dart';

class LanguageSelector extends ConsumerWidget {
  final bool isDropdown;

  const LanguageSelector({super.key, this.isDropdown = true});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);

    if (isDropdown) {
      return DropdownButton<Locale>(
        value: currentLocale,
        icon: const Icon(Icons.language, color: Colors.grey),
        underline: Container(),
        onChanged: (Locale? newLocale) {
          if (newLocale != null) {
            ref.read(localeProvider.notifier).setLocale(newLocale);
          }
        },
        items: const [
          DropdownMenuItem(
            value: Locale('es'),
            child: Text('Español'),
          ),
          DropdownMenuItem(
            value: Locale('en'),
            child: Text('English'),
          ),
        ],
      );
    } else {
      // Toggle Style
      return IconButton(
        icon: Text(
          currentLocale.languageCode == 'es' ? 'ES' : 'EN',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          final newLocale = currentLocale.languageCode == 'es' 
              ? const Locale('en') 
              : const Locale('es');
          ref.read(localeProvider.notifier).setLocale(newLocale);
        },
      );
    }
  }
}
