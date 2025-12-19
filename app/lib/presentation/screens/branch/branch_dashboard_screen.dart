import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:msasb_app/presentation/providers/user_provider.dart';
import 'widgets/staff_portal.dart';
import 'widgets/manager_dashboard.dart';

import 'package:msasb_app/domain/entities/user_session.dart';

class BranchDashboardScreen extends ConsumerWidget {
  final UserSession? session;
  
  const BranchDashboardScreen({super.key, this.session});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Use passed session or fallback to provider
    final effectiveSession = session ?? ref.watch(userStateProvider).asData?.value;
    final sucursal = effectiveSession?.sucursal;
    final usuario = effectiveSession?.usuario;

    // Si es Staff (o rol 'usuario'), mostrar vista simplificada
    if (effectiveSession?.currentRole == 'staff' || effectiveSession?.currentRole == 'usuario') {
      return StaffPortal(sucursal: sucursal);
    }

    return ManagerDashboard(
      sucursal: sucursal,
      usuario: usuario,
    );
  }
}

