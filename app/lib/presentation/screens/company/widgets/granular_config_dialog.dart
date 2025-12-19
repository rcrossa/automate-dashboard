import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:msasb_app/utils/responsive_helper.dart';
import 'package:msasb_app/presentation/providers/company_repository_provider.dart';
import 'package:msasb_app/presentation/providers/module_repository_provider.dart';
import 'package:msasb_app/utils/error_handler.dart';

class GranularConfigDialog extends ConsumerStatefulWidget {
  final Map<String, dynamic> modulo;
  final int empresaId;


  const GranularConfigDialog({
    super.key,
    required this.modulo,
    required this.empresaId,
  });

  @override
  ConsumerState<GranularConfigDialog> createState() => _GranularConfigDialogState();
}

class _GranularConfigDialogState extends ConsumerState<GranularConfigDialog> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Map<String, dynamic>> _sucursales = [];
  List<Map<String, dynamic>> _empleados = [];
  Set<String> _sucursalesActivas = {}; 
  Set<String> _usuariosActivos = {}; 
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    setState(() => _cargando = true);
    try {
      // 1. Cargar Sucursales y Empleados
      final repo = ref.read(companyRepositoryProvider);
      final sucursales = await repo.getBranches(companyId: widget.empresaId);
      final empleados = await repo.getEmployees(companyId: widget.empresaId);

      // 2. Verificar activaciones
      // 2. Verificar activaciones
      final codigo = widget.modulo['codigo'];
      final sucursalesActivas = <String>{};
      final usuariosActivos = <String>{};
      
      final moduleRepo = ref.read(moduleRepositoryProvider);

      for (var s in sucursales) {
        final mods = await moduleRepo.getBranchModules(branchId: s['id']);
        if (mods.contains(codigo)) sucursalesActivas.add(s['id'].toString());
      }

      for (var u in empleados) {
        final mods = await moduleRepo.getUserModules(userId: u['id']);
        if (mods.contains(codigo)) usuariosActivos.add(u['id'].toString());
      }

      if (mounted) {
        setState(() {
          _sucursales = sucursales;
          _empleados = empleados;
          _sucursalesActivas = sucursalesActivas;
          _usuariosActivos = usuariosActivos;
        });
      }
    } catch (e) {
      debugPrint('Error parsing config: $e');
    } finally {
      if (mounted) setState(() => _cargando = false);
    }
  }

  Future<double?> _pedirPrecio() async {
    final controller = TextEditingController();
    return showDialog<double>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Precio Personalizado'),
        content: TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            labelText: 'Precio Mensual (Opcional)',
            hintText: 'Dejar vacío para precio de lista',
            prefixText: '\$ ',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              final val = double.tryParse(controller.text);
              Navigator.pop(context, val);
            },
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }

  Future<void> _toggleSucursal(int id, bool activar) async {
    try {
      final moduleRepo = ref.read(moduleRepositoryProvider);
      if (activar) {
        final precio = await _pedirPrecio();
        await moduleRepo.toggleBranchModule(
          branchId: id,
          moduleCode: widget.modulo['codigo'],
          isActive: true,
          customPrice: precio,
        );
        setState(() => _sucursalesActivas.add(id.toString()));
      } else {
        await moduleRepo.toggleBranchModule(
          branchId: id,
          moduleCode: widget.modulo['codigo'],
          isActive: false,
        );
        setState(() => _sucursalesActivas.remove(id.toString()));
      }
    } catch (e) {
      if (mounted) {
        ErrorHandler.showError(context, e);
      }
    }
  }

  Future<void> _toggleUsuario(String id, bool activar) async {
    try {
      final moduleRepo = ref.read(moduleRepositoryProvider);
      if (activar) {
        final precio = await _pedirPrecio();
        await moduleRepo.toggleUserModule(
          userId: id,
          moduleCode: widget.modulo['codigo'],
          isActive: true,
          customPrice: precio,
        );
        setState(() => _usuariosActivos.add(id));
      } else {
        await moduleRepo.toggleUserModule(
          userId: id,
          moduleCode: widget.modulo['codigo'],
          isActive: false,
        );
        setState(() => _usuariosActivos.remove(id));
      }
    } catch (e) {
      if (mounted) {
        ErrorHandler.showError(context, e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: ResponsiveHelper.getMaxContentWidth(context),
        ),
        child: AlertDialog(
      title: Text('Configurar ${widget.modulo['nombre']}'),
      content: SizedBox(
        width: double.maxFinite,
        height: 400,
        child: Column(
          children: [
            TabBar(
              controller: _tabController,
              labelColor: Colors.blue,
              unselectedLabelColor: Colors.grey,
              tabs: const [
                Tab(text: 'Sucursales'),
                Tab(text: 'Usuarios'),
              ],
            ),
            Expanded(
              child: _cargando
                  ? const Center(child: CircularProgressIndicator())
                  : TabBarView(
                      controller: _tabController,
                      children: [
                        // Tab Sucursales
                        ListView.builder(
                          itemCount: _sucursales.length,
                          itemBuilder: (context, index) {
                            final s = _sucursales[index];
                            final id = s['id'];
                            final activo = _sucursalesActivas.contains(id.toString());
                            return SwitchListTile(
                              title: Text(s['nombre']),
                              subtitle: Text(s['direccion'] ?? ''),
                              value: activo,
                              onChanged: (val) => _toggleSucursal(id, val),
                            );
                          },
                        ),
                        // Tab Usuarios
                        ListView.builder(
                          itemCount: _empleados.length,
                          itemBuilder: (context, index) {
                            final u = _empleados[index];
                            final id = u['id'];
                            final activo = _usuariosActivos.contains(id);
                            return SwitchListTile(
                              title: Text('${u['nombre'] ?? ''} ${u['apellido'] ?? ''}'),
                              subtitle: Text(u['email'] ?? ''),
                              value: activo,
                              onChanged: (val) => _toggleUsuario(id, val),
                            );
                          },
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cerrar')),
      ],
        ),
      ),
    );
  }
}
