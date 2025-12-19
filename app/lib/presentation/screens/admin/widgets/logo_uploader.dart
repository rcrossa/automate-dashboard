import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:msasb_app/l10n/generated/app_localizations.dart';
import 'package:msasb_app/utils/error_handler.dart';

/// Widget para subir y mostrar logo de empresa
class LogoUploader extends ConsumerStatefulWidget {
  final String? currentLogoUrl;
  final int empresaId;
  final Function(XFile?) onLogoSelected; // Solo XFile - funciona en web y móvil
  final Future<void> Function()? onLogoDeleted; // Callback para eliminar
  final String title;
  final String? subtitle;
  final double size;
  final bool isLightVersion; // true para logo claro (dark mode)

  const LogoUploader({
    super.key,
    required this.empresaId,
    required this.onLogoSelected,
    this.onLogoDeleted,
    this.currentLogoUrl,
    this.title = 'Logo',
    this.subtitle,
    this.size = 120,
    this.isLightVersion = false,
  });

  @override
  ConsumerState<LogoUploader> createState() => _LogoUploaderState();
}

class _LogoUploaderState extends ConsumerState<LogoUploader> {
  final ImagePicker _picker = ImagePicker();
  XFile? _selectedImage;
  bool _isDeleting = false;

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImage = image;
        });

        // No notificar XFile - funciona tanto en web como móvil
        widget.onLogoSelected(image);
      }
    } catch (e) {
      if (mounted) {
        ErrorHandler.showError(context, e);
      }
    }
  }

  Future<void> _takePicture() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImage = image;
        });

        widget.onLogoSelected(image);
      }
    } catch (e) {
      if (mounted) {
        ErrorHandler.showError(context, e);
      }
    }
  }

  void _showPickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Galería'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage();
                },
              ),
              if (!kIsWeb) // Cámara solo disponible en móvil
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('Cámara'),
                  onTap: () {
                    Navigator.of(context).pop();
                    _takePicture();
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  bool get _hasLogo => widget.currentLogoUrl != null || _selectedImage != null;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Título y subtítulo
            Text(
              widget.title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            if (widget.subtitle != null) ...[
              const SizedBox(height: 4),
              Text(
                widget.subtitle!,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
            const SizedBox(height: 16),

            // Preview del logo
            GestureDetector(
              onTap: _showPickerOptions,
              child: Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: _selectedImage != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: kIsWeb
                            ? Image.network(
                                _selectedImage!.path,
                                fit: BoxFit.contain,
                              )
                            : Image.file(
                                File(_selectedImage!.path),
                                fit: BoxFit.contain,
                              ),
                      )
                    : widget.currentLogoUrl != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CachedNetworkImage(
                              imageUrl: widget.currentLogoUrl!,
                              fit: BoxFit.contain,
                              placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator(),
                              ),
                              errorWidget: (context, url, error) => Icon(
                                Icons.error,
                                size: widget.size * 0.4,
                                color: Colors.red,
                              ),
                            ),
                          )
                        : Icon(
                            Icons.add_photo_alternate,
                            size: widget.size * 0.4,
                            color: Colors.grey,
                          ),
              ),
            ),

            const SizedBox(height: 16),

            // Botones de acción
            Wrap(
              spacing: 8,
              alignment: WrapAlignment.center,
              children: [
                // Botón cambiar
                ElevatedButton.icon(
                  onPressed: _showPickerOptions,
                  icon: const Icon(Icons.upload, size: 18),
                  label: Text(_hasLogo ? 'Cambiar' : 'Subir'),
                ),
                // Botón eliminar
                if (_hasLogo)
                  OutlinedButton.icon(
                    onPressed: _isDeleting ? null : () async {
                      // Confirmar antes de eliminar
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Eliminar logo'),
                          content: const Text('¿Estás seguro de eliminar este logo?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Cancelar'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.red,
                              ),
                              child: const Text('Eliminar'),
                            ),
                          ],
                        ),
                      );

                       if (confirm == true && mounted) {
                        setState(() {
                          _isDeleting = true;
                        });

                        // Capture context before async operations
                        final localContext = context;

                        try {
                          // Llamar callback de delete si existe
                          if (widget.onLogoDeleted != null) {
                            await widget.onLogoDeleted!();
                          }

                          // Limpiar selección local
                          setState(() {
                            _selectedImage = null;
                            _isDeleting = false;
                          });
                          widget.onLogoSelected(null);

                          if (localContext.mounted) {
                            final l10n = AppLocalizations.of(localContext)!;
                            ErrorHandler.showSuccess(localContext, l10n.logoDeleteSuccess);
                          }
                        } catch (e) {
                          setState(() {
                            _isDeleting = false;
                          });

                          if (localContext.mounted) {
                            ErrorHandler.showError(localContext, e);
                          }
                        }
                      }
                    },
                    icon: _isDeleting
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.delete, size: 18),
                    label: Text(_isDeleting ? 'Eliminando...' : 'Eliminar'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                    ),
                  ),
              ],
            ),

            // Info de formato
            const SizedBox(height: 12),
            Text(
              'Formatos: PNG, JPG, SVG. Máximo 5MB.',
              style: TextStyle(fontSize: 11, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
