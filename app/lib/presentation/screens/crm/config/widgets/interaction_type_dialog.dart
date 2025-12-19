import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:msasb_app/domain/entities/tipo_interaccion.dart';
import 'package:msasb_app/presentation/providers/crm_config_repository_provider.dart';
import 'package:msasb_app/presentation/providers/user_provider.dart';
import 'package:msasb_app/utils/error_message.dart';

class InteractionTypeDialog extends ConsumerStatefulWidget {
  final TipoInteraccion? tipo;

  const InteractionTypeDialog({super.key, this.tipo});

  @override
  ConsumerState<InteractionTypeDialog> createState() => _InteractionTypeDialogState();
}

class _InteractionTypeDialogState extends ConsumerState<InteractionTypeDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nombreCtrl;
  late TextEditingController _iconoCtrl;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nombreCtrl = TextEditingController(text: widget.tipo?.nombre ?? '');
    _iconoCtrl = TextEditingController(text: widget.tipo?.icono ?? 'history');
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _iconoCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final repository = ref.read(crmConfigRepositoryProvider);
      final session = ref.read(userStateProvider).asData?.value;
      
      if (session?.empresa?.id == null) throw Exception('No hay empresa en sesión');

      final newTipo = TipoInteraccion(
        id: widget.tipo?.id ?? 0,
        empresaId: session!.empresa!.id,
        nombre: _nombreCtrl.text.trim(),
        icono: _iconoCtrl.text.trim().isEmpty ? null : _iconoCtrl.text.trim(),
        activo: true,
      );

      if (widget.tipo == null) {
        await repository.createTipoInteraccion(newTipo);
      } else {
        await repository.updateTipoInteraccion(newTipo);
      }

      if (mounted) {
        ErrorMessage.show(context, 'Tipo de Interacción guardado', isError: false);
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) ErrorMessage.show(context, 'Error: $e', isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 400,
        padding: EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                widget.tipo == null ? 'Nuevo Tipo de Interacción' : 'Editar Tipo',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 24),
              TextFormField(
                controller: _nombreCtrl,
                decoration: InputDecoration(labelText: 'Nombre (ej: WhatsApp, Llamada)', border: OutlineInputBorder()),
                validator: (v) => v!.isEmpty ? 'Requerido' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _iconoCtrl,
                decoration: InputDecoration(
                  labelText: 'Icono (Material Icon Name)', 
                  hintText: 'ej: phone, email, chat',
                  border: OutlineInputBorder(),
                  helperText: 'Nombre del icono de Material Design',
                ),
              ),
              SizedBox(height: 24),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _save,
                  child: _isLoading ? CircularProgressIndicator(color: Colors.white) : Text('Guardar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
