import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:msasb_app/domain/entities/reclamo.dart';
import 'package:msasb_app/presentation/providers/reclamo_repository_provider.dart';
import 'package:msasb_app/presentation/providers/session_provider.dart';
import 'package:msasb_app/l10n/generated/app_localizations.dart';
import 'package:intl/intl.dart';
import 'create_claim_screen.dart';
import 'claim_detail_screen.dart';

/// Simplified claims screen for staff/ejecutivo users
/// Shows own claims and assigned claims with quick filters
class StaffClaimsScreen extends ConsumerStatefulWidget {
  const StaffClaimsScreen({super.key});

  @override
  ConsumerState<StaffClaimsScreen> createState() => _StaffClaimsScreenState();
}

class _StaffClaimsScreenState extends ConsumerState<StaffClaimsScreen> {
  String _filterMode = 'mis_claims'; // 'mis_claims' or 'todos'
  String _searchQuery = '';
  List<Reclamo> _claims = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadClaims();
  }

  Future<void> _loadClaims() async {
    final session = ref.read(sessionProvider);
    if (session == null) {
      setState(() {
        _error = 'No hay sesión activa';
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final repository = ref.read(reclamoRepositoryProvider);
      final claims = await repository.getClaims(
        session.userId,
        empresaId: session.empresaId,
        limit: 100, // Get more claims for staff view
      );
      setState(() {
        _claims = claims;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final session = ref.watch(sessionProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.claims),
        actions: [
          // Filter toggle
          IconButton(
            icon: Icon(
              _filterMode == 'mis_claims' ? Icons.person : Icons.group,
              color: Theme.of(context).colorScheme.primary,
            ),
            tooltip: _filterMode == 'mis_claims' 
                ? 'Ver todos los reclamos' 
                : 'Ver mis reclamos',
            onPressed: () {
              setState(() {
                _filterMode = _filterMode == 'mis_claims' ? 'todos' : 'mis_claims';
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Buscar reclamos...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surface,
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
          ),
          
          // Filter chip
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                ChoiceChip(
                  label: const Text('Mis Reclamos'),
                  selected: _filterMode == 'mis_claims',
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _filterMode = 'mis_claims';
                      });
                    }
                  },
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('Todos'),
                  selected: _filterMode == 'todos',
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _filterMode = 'todos';
                      });
                    }
                  },
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Claims list
          Expanded(
            child: _buildClaimsList(session),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreateClaimScreen()),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Crear Reclamo'),
      ),
    );
  }
  
  Widget _buildClaimsList(SessionData? session) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text('Error al cargar reclamos: $_error'),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _loadClaims,
              icon: const Icon(Icons.refresh),
              label: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }
    
    if (_claims.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No hay reclamos',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Crea tu primer reclamo usando el botón +',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }
    
    // Filter claims
    final filteredClaims = _claims.where((claim) {
      // Filter by user if in "mis_claims" mode
      if (_filterMode == 'mis_claims' && session != null) {
        if (claim.usuarioId != session.userId) {
          return false;
        }
      }
      
      // Search filter
      if (_searchQuery.isNotEmpty) {
        final matchesTitle = claim.titulo.toLowerCase().contains(_searchQuery);
        final matchesDescription = claim.descripcion?.toLowerCase().contains(_searchQuery) ?? false;
        return matchesTitle || matchesDescription;
      }
      
      return true;
    }).toList();
    
    if (filteredClaims.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              _filterMode == 'mis_claims' 
                  ? 'No tienes reclamos asignados'
                  : 'No se encontraron resultados',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredClaims.length,
      itemBuilder: (context, index) {
        final claim = filteredClaims[index];
        return _buildSimplifiedClaimCard(claim, session);
      },
    );
  }
  
  Widget _buildSimplifiedClaimCard(Reclamo claim, SessionData? session) {
    final dateFormatter = DateFormat('dd/MM/yy HH:mm');
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ClaimDetailScreen(claim: claim),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row
              Row(
                children: [
                  // Status indicator
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _getColorForStatus(claim.estado),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  
                  // Title
                  Expanded(
                    child: Text(
                      claim.titulo,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  
                  // Priority badge
                  _buildPriorityBadge(claim.prioridad),
                ],
              ),
              
              const SizedBox(height: 8),
              
              // Description (if available)
              if (claim.descripcion != null && claim.descripcion!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    claim.descripcion!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[700],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              
              // Footer row
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 14, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    dateFormatter.format(claim.fechaCreacion),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(width: 16),
                  
                  // Status chip
                  Chip(
                    label: Text(
                      claim.estado.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    backgroundColor: _getColorForStatus(claim.estado).withValues(alpha: 0.2),
                    labelStyle: TextStyle(color: _getColorForStatus(claim.estado)),
                    padding: EdgeInsets.zero,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  
                  const Spacer(),
                  
                  // "Mine" indicator
                  if (session != null && claim.usuarioId == session.userId)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Mio',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildPriorityBadge(String priority) {
    Color color;
    IconData icon;
    
    switch (priority.toLowerCase()) {
      case 'alta':
        color = Colors.red;
        icon = Icons.priority_high;
        break;
      case 'media':
        color = Colors.orange;
        icon = Icons.remove;
        break;
      case 'baja':
        color = Colors.green;
        icon = Icons.arrow_downward;
        break;
      default:
        color = Colors.grey;
        icon = Icons.help_outline;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            priority.toUpperCase(),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
  
  Color _getColorForStatus(String status) {
    switch (status.toLowerCase()) {
      case 'pendiente':
        return Colors.orange;
      case 'en_proceso':
        return Colors.blue;
      case 'resuelto':
        return Colors.green;
      case 'cerrado':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }
}
