import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'empresa.dart';
import 'sucursal.dart';
import 'usuario_con_permisos.dart';

class UserSession extends Equatable {
  final UsuarioConPermisos? usuario;
  final Empresa? empresa;
  final Sucursal? sucursal;
  final Color? themeColor;
  final bool isLoading;

  const UserSession({
    this.usuario,
    this.empresa,
    this.sucursal,
    this.themeColor,
    this.isLoading = false,
  });

  UserSession copyWith({
    UsuarioConPermisos? usuario,
    Empresa? empresa,
    Sucursal? sucursal,
    Color? themeColor,
    bool? isLoading,
    bool clearEmpresa = false,
    bool clearSucursal = false,
  }) {
    return UserSession(
      usuario: usuario ?? this.usuario,
      empresa: clearEmpresa ? null : (empresa ?? this.empresa),
      sucursal: clearSucursal ? null : (sucursal ?? this.sucursal),
      themeColor: themeColor ?? this.themeColor,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  bool get isSuperAdmin => usuario?.tipoPerfil == 'super_admin';
  String? get currentRole => usuario?.rol;

  @override
  List<Object?> get props => [usuario, empresa, sucursal, themeColor, isLoading];
}
