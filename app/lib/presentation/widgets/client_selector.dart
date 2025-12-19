
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:msasb_app/domain/entities/cliente.dart';
import 'package:msasb_app/presentation/providers/cliente_repository_provider.dart';
import 'package:msasb_app/presentation/providers/user_provider.dart';

class ClientSelector extends ConsumerStatefulWidget {
  final Function(Cliente?) onSelected;
  final Cliente? initialValue;

  const ClientSelector({super.key, required this.onSelected, this.initialValue});

  @override
  ConsumerState<ClientSelector> createState() => _ClientSelectorState();
}

class _ClientSelectorState extends ConsumerState<ClientSelector> {
  final TextEditingController _controller = TextEditingController();
  Cliente? _selectedClient;

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null) {
      _selectedClient = widget.initialValue;
      _controller.text = '${widget.initialValue!.nombre} ${widget.initialValue!.apellido ?? ''}';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Autocomplete<Cliente>(
          displayStringForOption: (Cliente option) => '${option.nombre} ${option.apellido ?? ''} (${option.documentoIdentidad ?? 'N/A'})',
          optionsBuilder: (TextEditingValue textEditingValue) {
             if (textEditingValue.text == '') {
               return const Iterable<Cliente>.empty();
             }
             
             // Single-tenant: No need to check for empresa, RLS handles it
             final repo = ref.read(clienteRepositoryProvider);
             return repo.searchClientes(textEditingValue.text);  // RLS filters by empresa_id=1
          },
          onSelected: (Cliente selection) {
             widget.onSelected(selection);
             setState(() {
               _selectedClient = selection;
             });
          },
          fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
             // If we have an initial value, we might want to set the text initially?
             // Autocomplete manages its own controller usually, but fieldViewBuilder exposes it.
             // If we just rebuilt, we might lose text.
             if (_selectedClient != null && textEditingController.text.isEmpty) {
                // Avoid rewriting if user is typing
                if (!focusNode.hasFocus) {
                  textEditingController.text = '${_selectedClient!.nombre} ${_selectedClient!.apellido ?? ''}';
                }
             }

             return TextField(
               controller: textEditingController,
               focusNode: focusNode,
               decoration: const InputDecoration(
                 labelText: 'Cliente (Opcional)',
                 border: OutlineInputBorder(),
                 suffixIcon: Icon(Icons.search),
                 helperText: 'Busca por nombre o documento',
               ),
               onChanged: (text) {
                 // Clear selection if user clears text or modifies it (optional logic)
                 if (_selectedClient != null && text != '${_selectedClient!.nombre} ${_selectedClient!.apellido ?? ''}') {
                    setState(() {
                      _selectedClient = null;
                    });
                    widget.onSelected(null);
                 }
               },
             );
          },
        ),
      ],
    );
  }
}
