import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:msasb_app/l10n/generated/app_localizations.dart';
import 'package:msasb_app/domain/entities/empresa_branding.dart';
import 'package:msasb_app/presentation/screens/admin/widgets/logo_uploader.dart';
import 'package:msasb_app/presentation/providers/branding_provider.dart';

/// Tab para configuración de logos (principal y light version)
class LogosTab extends ConsumerWidget {
  final EmpresaBranding branding;
  final Function(XFile?) onLogoSelected;
  final Function(XFile?) onLogoLightSelected;

  const LogosTab({
    super.key,
    required this.branding,
    required this.onLogoSelected,
    required this.onLogoLightSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.brandingLogosTitle,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.brandingLogosSubtitle,
            style: TextStyle(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 32),
          
          // Logo principal
          LogoUploader(
            empresaId: branding.empresaId,
            currentLogoUrl: branding.logoUrl,
            title: l10n.brandingLogoPrimary,
            subtitle: l10n.brandingLogoPrimarySubtitle,
            onLogoSelected: onLogoSelected,
            onLogoDeleted: () => _deleteLogo(ref, branding, isLightVersion: false),
          ),
          const SizedBox(height: 24),
          
          // Logo claro (para dark mode)
          LogoUploader(
            empresaId: branding.empresaId,
            currentLogoUrl: branding.logoLightUrl,
            title: l10n.brandingLogoLight,
            subtitle: l10n.brandingLogoLightSubtitle,
            isLightVersion: true,
            onLogoSelected: onLogoLightSelected,
            onLogoDeleted: () => _deleteLogo(ref, branding, isLightVersion: true),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteLogo(WidgetRef ref, EmpresaBranding branding, {required bool isLightVersion}) async {
    await ref.read(companyBrandingProvider.notifier).deleteLogo(
      branding.empresaId,
      isLightVersion: isLightVersion,
    );
    
    final updatedBranding = branding.copyWith(
      logoUrl: isLightVersion ? branding.logoUrl : null,
      logoLightUrl: isLightVersion ? null : branding.logoLightUrl,
      actualizadoEn: DateTime.now(),
    );
    await ref.read(companyBrandingProvider.notifier).updateBranding(updatedBranding);
  }
}
