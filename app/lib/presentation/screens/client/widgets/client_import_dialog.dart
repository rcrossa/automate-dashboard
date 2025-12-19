import 'dart:convert';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:msasb_app/l10n/generated/app_localizations.dart';
import 'package:msasb_app/utils/responsive_helper.dart';
import 'package:msasb_app/domain/entities/cliente.dart';
import 'package:msasb_app/presentation/providers/client_repository_provider.dart';
import 'package:msasb_app/utils/error_handler.dart';

class ClientImportDialog extends ConsumerStatefulWidget {
  final int empresaId;
  final int? sucursalId; // Optional default branch

  const ClientImportDialog({
    super.key,
    required this.empresaId,
    this.sucursalId,
  });

  @override
  ConsumerState<ClientImportDialog> createState() => _ClientImportDialogState();
}

class _ClientImportDialogState extends ConsumerState<ClientImportDialog> {
  bool _isLoading = false;
  List<List<dynamic>> _csvData = [];
  bool _fileSelected = false;

  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
        withData: true, // Needed for bytes on web/desktop if path fails
      );

      if (result != null && result.files.single.bytes != null) {
        final bytes = result.files.single.bytes!;
        // Decode utf8
        final csvString = utf8.decode(bytes);
        final fields = const CsvToListConverter().convert(csvString);
        
        setState(() {
          _csvData = fields;
          _fileSelected = true;
        });
      }
    } catch (e) {
      if (mounted) {
         ErrorHandler.showError(context, e);
      }
    }
  }

  Future<void> _import() async {
    if (_csvData.isEmpty) return;
    setState(() => _isLoading = true);

    try {
      // Basic mapping assumption: Headers match our expectation or we assume order?
      // For MVP V1: Assume order or simple header check.
      // Let's assume standard order: Nombre, Apellido, Email, Telefono, DNI
      // Or better: Skip first row if it looks like header.
      
      final rows = List<List<dynamic>>.from(_csvData);
      bool hasHeader = false;
      if (rows.isNotEmpty) {
          // Check if first row strings look like headers
          final first = rows.first;
          if (first.any((c) => c.toString().toLowerCase().contains('nombre') || c.toString().toLowerCase().contains('email'))) {
             hasHeader = true;
          }
      }
      
      if (hasHeader) rows.removeAt(0);
      
      final clientsToInsert = <Cliente>[];
      final now = DateTime.now();

      for (final row in rows) {
        if (row.isEmpty) continue;
        // Simple mapping structure:
        // 0: Nombre (Required)
        // 1: Apellido
        // 2: Email
        // 3: Telefono
        // 4: DNI
        // If row has less data, safely access or defaults.
        
        // Helper to safe string
        String s(int i) => (i < row.length) ? row[i].toString().trim() : '';
        
        final nombre = s(0);
        if (nombre.isEmpty) continue; // Skip invalid
        
        final cliente = Cliente(
          id: 0, // Placeholder
          empresaId: widget.empresaId,
          sucursalId: widget.sucursalId,
          nombre: nombre,
          apellido: s(1),
          email: s(2).isEmpty ? null : s(2),
          telefono: s(3).isEmpty ? null : s(3),
          documentoIdentidad: s(4).isEmpty ? null : s(4),
          tipoCliente: 'persona', // Default
          estado: 'activo',
          fechaCreacion: now,
          actualizadoEn: now,
        );
        clientsToInsert.add(cliente);
      }
      
      if (clientsToInsert.isEmpty) {
        throw Exception('No valid data found');
      }

      final count = await ref.read(clientRepositoryProvider).bulkCreateClients(clientsToInsert);
      
      if (mounted) {
        Navigator.pop(context, true);
        final l10n = AppLocalizations.of(context)!;
        ErrorHandler.showSuccess(context, l10n.importSuccess(count));
      }

    } catch (e) {
      if (mounted) {
        ErrorHandler.showError(context, e);
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: ResponsiveHelper.getMaxContentWidth(context),
        ),
        child: AlertDialog(
      title: Text(l10n.importClients),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!_fileSelected)
              Center(
                child: ElevatedButton.icon(
                  onPressed: _pickFile,
                  icon: const Icon(Icons.upload_file),
                  label: Text(l10n.pickFileCSV),
                ),
              )
            else ...[
              Text(l10n.rowsFound(_csvData.length)),
              const SizedBox(height: 8),
              const Text('Format: Nombre, Apellido, Email, Tel, DNI', style: TextStyle(fontSize: 12, color: Colors.grey)),
              const SizedBox(height: 8),
              Flexible(
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300)),
                  child: SingleChildScrollView(
                    child: Table(
                      border: TableBorder.all(color: Colors.grey.shade200),
                      children: _csvData.take(5).map((row) {
                        return TableRow(children: row.map((cell) => Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(cell.toString(), style: const TextStyle(fontSize: 10)),
                        )).toList());
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ],
            if (_isLoading) 
               const Padding(
                 padding: EdgeInsets.only(top: 16),
                 child: LinearProgressIndicator(),
               ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.btnCancel),
        ),
        if (_fileSelected)
          ElevatedButton(
            onPressed: _isLoading ? null : _import,
            child: Text(l10n.importBtn),
          ),
      ],
    ),
      ),
    );
  }
}
