import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:msasb_app/presentation/providers/branding_provider.dart';

/// Widget reutilizable para mostrar el logo de la empresa
/// 
/// Características:
/// - Adapta a dark mode (usa logoUrl o logoLightUrl)
/// - Caché automático con CachedNetworkImage
/// - Fallback a icono si no hay logo
/// - Tamaño configurable
class CompanyLogo extends ConsumerWidget {
  final double? width;
  final double? height;
  final bool adaptToDarkMode;
  final BoxFit fit;

  const CompanyLogo({
    super.key,
    this.width,
    this.height,
    this.adaptToDarkMode = true,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brandingAsync = ref.watch(companyBrandingProvider);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return brandingAsync.when(
      data: (branding) {
        if (branding == null) {
          return _buildFallback(context);
        }

        // Seleccionar logo según dark mode
        final logoUrl = adaptToDarkMode && isDarkMode && branding.logoLightUrl != null
            ? branding.logoLightUrl
            : branding.logoUrl;

        if (logoUrl == null || logoUrl.isEmpty) {
          return _buildFallback(context);
        }

        return CachedNetworkImage(
          imageUrl: logoUrl,
          width: width,
          height: height,
          fit: fit,
          placeholder: (context, url) => _buildPlaceholder(),
          errorWidget: (context, url, error) => _buildFallback(context),
        );
      },
      loading: () => _buildPlaceholder(),
      error: (_, _) => _buildFallback(context),
    );
  }

  Widget _buildPlaceholder() {
    return SizedBox(
      width: width,
      height: height,
      child: const Center(
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    );
  }

  Widget _buildFallback(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Icon(
        Icons.business,
        size: (height ?? 40) * 0.7,
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
      ),
    );
  }
}
