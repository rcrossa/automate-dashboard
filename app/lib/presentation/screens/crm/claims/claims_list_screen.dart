import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:msasb_app/domain/entities/reclamo.dart';
import 'package:msasb_app/presentation/providers/reclamo_repository_provider.dart';
import 'package:msasb_app/presentation/providers/user_provider.dart';
import 'package:msasb_app/utils/error_message.dart';
import 'package:msasb_app/presentation/providers/company_repository_provider.dart';
import 'create_claim_screen.dart';
import 'claim_detail_screen.dart';
import 'package:intl/intl.dart';
import 'package:msasb_app/l10n/generated/app_localizations.dart';
import 'package:msasb_app/utils/responsive_helper.dart';

class ClaimsListScreen extends ConsumerStatefulWidget {
  const ClaimsListScreen({super.key});

  @override
  ConsumerState<ClaimsListScreen> createState() => _ClaimsListScreenState();
}

class _ClaimsListScreenState extends ConsumerState<ClaimsListScreen> {
  bool _isLoading = true;
  List<Reclamo> _claims = [];
  final _searchCtrl = TextEditingController();
  Timer? _debounce;
  
  // Pagination & Filters
  int _limit = 20;
  int _offset = 0;
  String _estadoFilter = 'todos';
  int? _sucursalFilter; // null = todas
  List<Map<String, dynamic>> _sucursales = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadSucursales();
      _loadClaims();
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _loadSucursales() async {
    try {
      final userState = ref.read(userStateProvider);
      final session = userState.asData?.value;
      if (session?.empresa?.id == null) return;
      
      final repo = ref.read(companyRepositoryProvider);
      final branches = await repo.getBranches(companyId: session!.empresa!.id);
      if (mounted) {
        setState(() {
          _sucursales = branches;
        });
      }
    } catch (_) {
      // Silent error or retry? For now silent.
    }
  }

  Future<void> _loadClaims() async {
    setState(() => _isLoading = true);
    try {
      final userState = ref.read(userStateProvider);
      final session = userState.asData?.value;
      if (session?.usuario == null) return;

      final repo = ref.read(reclamoRepositoryProvider);
      
      final isManager = session?.usuario?.rol == 'admin' || session?.usuario?.rol == 'super_admin';
      
      final claims = await repo.getClaims(
        session!.usuario!.id, 
        empresaId: isManager ? session.empresa?.id : null,
        query: _searchCtrl.text.trim(),
        limit: _limit,
        offset: _offset,
        sucursalId: _sucursalFilter,
        estadoFilter: _estadoFilter,
      );

      if (mounted) {
        setState(() {
          _claims = claims;
        });
      }
    } catch (e) {
      if (mounted) ErrorMessage.show(context, 'Error cargando reclamos: $e', isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _offset = 0; // Reset pagination on search
      _loadClaims();
    });
  }

  void _changePage(int direction) {
    setState(() {
      if (direction > 0) {
        _offset += _limit;
      } else {
        _offset -= _limit;
        if (_offset < 0) _offset = 0;
      }
    });
    _loadClaims();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.claimsManagementTitle),
        actions: [
          // Desktop only: Button with text label
          if (!ResponsiveHelper.isMobile(context))
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.add_task),
                label: Text(AppLocalizations.of(context)!.newClaim),
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CreateClaimScreen()),
                  );
                  if (result == true) {
                    _loadClaims();
                  }
                },
              ),
            ),
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: AppLocalizations.of(context)!.crmConfig,
            onPressed: () => Navigator.pushNamed(context, '/crm/config'),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadClaims,
          ),
        ],
      ),
      // Mobile only: FAB for primary action
      floatingActionButton: ResponsiveHelper.isMobile(context)
          ? FloatingActionButton(
              heroTag: 'create_claim_fab',
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CreateClaimScreen()),
                );
                if (result == true) {
                  _loadClaims();
                }
              },
              tooltip: AppLocalizations.of(context)!.newClaim,
              child: const Icon(Icons.add),
            )
          : null,

      body: Column(
        children: [
          // Filtros
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  // Buscador
                  SizedBox(
                    width: ResponsiveHelper.isMobile(context) ? 200 : 250,
                    child: TextField(
                      controller: _searchCtrl,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search),
                        border: const OutlineInputBorder(),
                        hintText: AppLocalizations.of(context)!.searchClaimsPlaceholder,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: ResponsiveHelper.isMobile(context) ? 8 : 16,
                        ),
                      ),
                      onChanged: _onSearchChanged,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Dropdown Estado
                  DropdownButton<String>(
                    value: _estadoFilter,
                    hint: Text(AppLocalizations.of(context)!.allStatuses),
                    items: [
                       DropdownMenuItem(value: 'todos', child: Text(AppLocalizations.of(context)!.allStatuses)),
                       DropdownMenuItem(value: 'pendiente', child: Text(AppLocalizations.of(context)!.statusPending)),
                       DropdownMenuItem(value: 'en_proceso', child: Text(AppLocalizations.of(context)!.statusInProgress)),
                       DropdownMenuItem(value: 'resuelto', child: Text(AppLocalizations.of(context)!.statusResolved)),
                       DropdownMenuItem(value: 'cerrado', child: Text(AppLocalizations.of(context)!.statusClosed)),
                    ],
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          _estadoFilter = val;
                          _offset = 0;
                        });
                        _loadClaims();
                      }
                    },
                  ),
                  const SizedBox(width: 8),
                  // Dropdown Sucursal
                  if (_sucursales.isNotEmpty)
                    DropdownButton<int?>(
                      value: _sucursalFilter,
                      hint: Text(AppLocalizations.of(context)!.allBranches),
                      items: [
                        DropdownMenuItem(value: null, child: Text(AppLocalizations.of(context)!.allBranches)),
                        ..._sucursales.map((s) => DropdownMenuItem(
                              value: s['id'] as int,
                              child: Text(s['nombre'] ?? 'Sin Nombre'),
                            )),
                      ],
                      onChanged: (val) {
                         setState(() {
                           _sucursalFilter = val;
                           _offset = 0;
                         });
                         _loadClaims();
                      },
                    ),
                ],
              ),
            ),
          ),
          const Divider(),
          // Lista
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _claims.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.assignment_turned_in_outlined, size: 64, color: Colors.grey),
                            const SizedBox(height: 16),
                            Text(AppLocalizations.of(context)!.noClaimsFound, style: const TextStyle(color: Colors.grey)),
                          ],
                        ),
                      )
                     : ResponsiveHelper.isMobile(context)
                        ? _buildMobileList()
                        : _buildDesktopGrid(),
          ),
          // Paginación Footer
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.grey.shade300))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(AppLocalizations.of(context)!.itemsPerPage),
                DropdownButton<int>(
                   value: _limit,
                   items: const [
                     DropdownMenuItem(value: 10, child: Text('10')),
                     DropdownMenuItem(value: 20, child: Text('20')),
                     DropdownMenuItem(value: 50, child: Text('50')),
                   ],
                   onChanged: (val) {
                     if (val != null) {
                       setState(() {
                         _limit = val;
                         _offset = 0;
                       });
                       _loadClaims();
                     }
                   },
                ),
                const SizedBox(width: 20),
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: _offset > 0 ? () => _changePage(-1) : null,
                ),
                Text('Pág ${_offset ~/ _limit + 1}'),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  // Disable if fetched less than limit (end of list)
                  onPressed: _claims.length == _limit ? () => _changePage(1) : null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getColorForStatus(String status) {
    switch (status) {
      case 'pendiente': return Colors.orange;
      case 'en_proceso': return Colors.blue;
      case 'resuelto': return Colors.green;
      case 'cerrado': return Colors.grey;
      default: return Colors.orange;
    }
  }

  IconData _getIconForStatus(String status) {
    switch (status) {
      case 'pendiente': return Icons.pending;
      case 'en_proceso': return Icons.work;
      case 'resuelto': return Icons.check_circle;
      case 'cerrado': return Icons.lock;
      default: return Icons.help;
    }
  }

  Widget _buildPriorityTag(String priority) {
    Color color;
    switch (priority) {
      case 'alta':
      case 'urgente':
        color = Colors.red;
        break;
      case 'media':
        color = Colors.orange;
        break;
      default:
        color = Colors.green;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        priority.toUpperCase(),
        style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildMobileList() {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: _claims.length,
      itemBuilder: (context, index) => _buildClaimCard(_claims[index]),
    );
  }

  Widget _buildDesktopGrid() {
    return GridView.builder(
      padding: EdgeInsets.all(ResponsiveHelper.getResponsivePadding(context)),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: ResponsiveHelper.getGridCrossAxisCount(context),
        childAspectRatio: 2.5,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: _claims.length,
      itemBuilder: (context, index) => _buildClaimCard(_claims[index]),
    );
  }

  Widget _buildClaimCard(Reclamo claim) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getColorForStatus(claim.estado),
          child: Icon(_getIconForStatus(claim.estado), color: Colors.white, size: 20),
        ),
        title: Text('#${claim.id} ${claim.titulo}', style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (claim.sucursalNombre != null || claim.clienteNombre != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Row(
                  children: [
                    if (claim.sucursalNombre != null) ...[
                      const Icon(Icons.store, size: 12, color: Colors.blueGrey),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          claim.sucursalNombre!,
                          style: const TextStyle(fontSize: 11),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (claim.clienteNombre != null) const SizedBox(width: 10),
                    ],
                    if (claim.clienteNombre != null && claim.clienteNombre!.isNotEmpty) ...[
                      const Icon(Icons.person, size: 12, color: Colors.indigo),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          claim.clienteNombre!,
                          style: const TextStyle(fontSize: 11, color: Colors.indigo),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            if (claim.descripcion != null)
              Text(claim.descripcion!, maxLines: 1, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 12, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  DateFormat('dd/MM/yyyy HH:mm').format(claim.fechaCreacion),
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                const SizedBox(width: 8),
                _buildPriorityTag(claim.prioridad),
              ],
            ),
          ],
        ),
        isThreeLine: true,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ClaimDetailScreen(claim: claim)),
          );
        },
      ),
    );
  }
}
