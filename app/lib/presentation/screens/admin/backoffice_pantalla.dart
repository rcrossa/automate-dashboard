import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:msasb_app/presentation/providers/user_repository_provider.dart';
import 'package:msasb_app/domain/entities/usuario_con_permisos.dart';
import 'package:msasb_app/widgets/app_drawer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'widgets/usuario_card.dart';
import 'widgets/paginacion_widget.dart';
import 'package:msasb_app/l10n/generated/app_localizations.dart';
import 'package:msasb_app/widgets/language_selector.dart';

class BackofficePantalla extends ConsumerStatefulWidget {
  const BackofficePantalla({super.key});

  @override
  ConsumerState<BackofficePantalla> createState() => _BackofficePantallaState();
}

class _BackofficePantallaState extends ConsumerState<BackofficePantalla> {
  List<dynamic> usuarios = [];
  List<dynamic> roles = [];
  List<dynamic> permisosDisponibles = [];
  Map<String, Set<int>> usuarioPermisos = {};
  bool cargando = true;
  UsuarioConPermisos? usuarioActual;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Búsqueda
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  
  // Paginación
  int paginaActual = 0;
  final int usuariosPorPagina = 10;

  @override
  void initState() {
    super.initState();
    cargarDatos();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
        paginaActual = 0; // Resetear paginación al buscar
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> cargarDatos() async {
    final u = await obtenerUsuarioConPermisos();
    final repo = ref.read(userRepositoryProvider);
    
    final usuariosResp = await repo.getUsers();
    final rolesResp = await repo.getRoles();
    final permisosResp = await repo.getPermissions();
    
    final Map<String, Set<int>> permisosMap = {};
    for (var usuario in usuariosResp) {
      final usuarioId = usuario['id'].toString();
      final perms = await repo.getUserPermissions(usuarioId);
      permisosMap[usuarioId] = perms.toSet();
    }
    
    setState(() {
      usuarioActual = u;
      usuarios = usuariosResp;
      roles = rolesResp;
      permisosDisponibles = permisosResp;
      usuarioPermisos = permisosMap;
      cargando = false;
    });
  }

  Future<void> cambiarRol(String usuarioId, int nuevoRolId) async {
    final repo = ref.read(userRepositoryProvider);
    await repo.changeUserRole(usuarioId, nuevoRolId);
    cargarDatos();
  }

  Future<void> togglePermiso(String usuarioId, int permisoId, bool tienePermiso) async {
    final repo = ref.read(userRepositoryProvider);
    if (tienePermiso) {
      await repo.removePermission(usuarioId, permisoId);
    } else {
      await repo.assignPermission(usuarioId, permisoId);
    }
    cargarDatos();
  }

  List<dynamic> get usuariosFiltrados {
    if (_searchQuery.isEmpty) return usuarios;
    return usuarios.where((u) {
      final nombre = (u['nombre'] ?? '').toString().toLowerCase();
      final email = (u['email'] ?? '').toString().toLowerCase();
      return nombre.contains(_searchQuery) || email.contains(_searchQuery);
    }).toList();
  }

  List<dynamic> get usuariosPaginados {
    final lista = usuariosFiltrados;
    final inicio = paginaActual * usuariosPorPagina;
    final fin = (inicio + usuariosPorPagina).clamp(0, lista.length);
    return lista.sublist(inicio, fin);
  }

  int get totalPaginas => (usuariosFiltrados.length / usuariosPorPagina).ceil();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(l10n.backofficeTitle, style: const TextStyle(fontSize: 18)),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        actions: const [
          LanguageSelector(),
          SizedBox(width: 8),
        ],
      ),
      drawer: AppDrawer(
        usuario: usuarioActual,
        onLogout: () async {
          await Supabase.instance.client.auth.signOut();
          if (context.mounted) Navigator.of(context).popUntil((route) => route.isFirst);
        },
      ),
      body: cargando
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Buscador
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: l10n.searchUserPlaceholder,
                      hintText: l10n.searchUserPlaceholder,
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                    ),
                  ),
                ),
                // Info de paginación
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  color: Colors.grey[100],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.userCount(usuariosFiltrados.length),
                        style: TextStyle(color: Colors.grey[600], fontSize: 13),
                      ),
                      Text(
                        totalPaginas > 0 
                          ? l10n.paginationInfo(paginaActual + 1, totalPaginas)
                          : l10n.noResults,
                        style: TextStyle(color: Colors.grey[600], fontSize: 13),
                      ),
                    ],
                  ),
                ),
                // Lista de usuarios
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    itemCount: usuariosPaginados.length,
                    itemBuilder: (context, index) {
                      final usuario = usuariosPaginados[index];
                      final usuarioId = usuario['id'].toString();
                      return UsuarioCard(
                        usuario: usuario,
                        roles: roles,
                        permisosDisponibles: permisosDisponibles,
                        permisosUsuario: usuarioPermisos[usuarioId] ?? {},
                        onRolChanged: cambiarRol,
                        onPermisoToggled: togglePermiso,
                      );
                    },
                  ),
                ),
                // Controles de paginación
                if (totalPaginas > 1) 
                  PaginacionWidget(
                    paginaActual: paginaActual,
                    totalPaginas: totalPaginas,
                    onPageChanged: (page) => setState(() => paginaActual = page),
                  ),
              ],
            ),
    );
  }
}
