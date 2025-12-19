import 'package:flutter/material.dart';

/// Dialog para obtener consentimiento antes de grabar conversación
class ConsentDialog extends StatefulWidget {
  final VoidCallback onAccept;
  
  const ConsentDialog({
    super.key,
    required this.onAccept,
  });

  @override
  State<ConsentDialog> createState() => _ConsentDialogState();
}

class _ConsentDialogState extends State<ConsentDialog> {
  bool _consentGiven = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.privacy_tip, color: Colors.orange.shade700),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'Grabación de Conversación',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '⚠️ IMPORTANTE',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Antes de iniciar la grabación, debes informar '
              'al cliente que la conversación será grabada.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Uso de la grabación:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  _buildBullet('Análisis de oportunidades de negocio'),
                  _buildBullet('Identificación de productos sugeridos'),
                  _buildBullet('Mejora del servicio al cliente'),
                  const SizedBox(height: 8),
                  Text(
                    'Solo se guardará la transcripción (texto), NO el audio.',
                    style: TextStyle(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text(
                'Confirmo que el cliente dio su consentimiento '
                'verbal para grabar esta conversación',
                style: TextStyle(fontSize: 13),
              ),
              value: _consentGiven,
              onChanged: (val) => setState(() => _consentGiven = val ?? false),
              controlAffinity: ListTileControlAffinity.leading,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton.icon(
          icon: const Icon(Icons.fiber_manual_record, size: 18),
          label: const Text('Iniciar Grabación'),
          onPressed: _consentGiven
              ? () {
                  Navigator.of(context).pop();
                  widget.onAccept();
                }
              : null,
        ),
      ],
    );
  }

  Widget _buildBullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 14)),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 13))),
        ],
      ),
    );
  }
}
