import 'package:flutter/material.dart';
import 'package:msasb_app/presentation/widgets/company_logo.dart';

class LoginBranding extends StatelessWidget {
  const LoginBranding({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue.shade900,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Logo de la empresa (o fallback a ícono)
          const CompanyLogo(
            width: 150,
            height: 100,
            adaptToDarkMode: false, // Login siempre usa logo principal
          ),
          const SizedBox(height: 20),
          const Text(
            'Mi Primera App',
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Gestión empresarial simplificada',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}
