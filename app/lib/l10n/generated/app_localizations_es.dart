// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Mi Primera App';

  @override
  String get loginTitle => 'Iniciar Sesión';

  @override
  String get emailLabel => 'Correo Electrónico';

  @override
  String get passwordLabel => 'Contraseña';

  @override
  String get loginButton => 'Ingresar';

  @override
  String get registerButton => 'Registrarse';

  @override
  String get registerTitle => 'Registro';

  @override
  String get nameLabel => 'Nombre';

  @override
  String get welcomeMessage => 'Bienvenido';

  @override
  String get forgotPassword => '¿Olvidaste tu contraseña?';

  @override
  String errorMessage(Object error) {
    return 'Error: $error';
  }

  @override
  String get logout => 'Cerrar Sesión';

  @override
  String get close => 'Cerrar';

  @override
  String get cancel => 'Cancelar';

  @override
  String roleDetected(Object role) {
    return 'Rol detectado: $role';
  }

  @override
  String get none => 'Ninguno';

  @override
  String get debugMode => 'Modo Debug';

  @override
  String get debugAdminMessage =>
      'Para ver el Dashboard de Admin, tu usuario debe tener el rol \"admin\" en la base de datos.\n\n¿Quieres simular ser Admin ahora?';

  @override
  String get simulateNotImplemented => 'Simular (No implementado)';

  @override
  String get assignRoleMessage =>
      'Por favor, asigna el rol \"admin\" en Supabase o usa un usuario admin.';

  @override
  String get whySeeThis => '¿Por qué veo esto?';

  @override
  String emailLabelWithVal(Object email) {
    return 'Email: $email';
  }

  @override
  String get permissions => 'Permisos:';

  @override
  String companyLabelWithVal(Object company) {
    return 'Empresa: $company';
  }

  @override
  String branchLabelWithVal(Object branch) {
    return 'Sucursal: $branch';
  }

  @override
  String get noCompanyAssigned => 'No tienes empresa asignada.';

  @override
  String get dashboardInactive => 'Dashboard Inactivo';

  @override
  String get dashboardDisabledMessage =>
      'El módulo Dashboard está desactivado.';

  @override
  String get adminActivateMessage =>
      'Como administrador, puedes activarlo en el Marketplace.';

  @override
  String get goToMarketplace => 'Ir al Marketplace';

  @override
  String get accessDenied => 'Acceso Denegado';

  @override
  String get dashboardNotActive => 'Dashboard no activo';

  @override
  String get contactAdminMessage =>
      'Contacte a su administrador para activar este módulo.';

  @override
  String get userNotFoundDB => 'No se encontró el usuario en la base de datos.';

  @override
  String get authenticatedUserId => 'ID de usuario autenticado';

  @override
  String get viewUserId => 'Ver ID de usuario';

  @override
  String get companyPanel => 'Panel de Empresa';

  @override
  String get modulesMarketplace => 'Marketplace de Módulos';

  @override
  String get summary => 'Resumen';

  @override
  String get branches => 'Sucursales';

  @override
  String get personnel => 'Personal';

  @override
  String get searchBranch => 'Buscar Sucursal';

  @override
  String get noBranchesFound => 'No se encontraron sucursales';

  @override
  String get noAddress => 'Sin dirección';

  @override
  String get editBranch => 'Editar Sucursal';

  @override
  String get newBranch => 'Nueva Sucursal';

  @override
  String get branchUpdated => 'Sucursal actualizada';

  @override
  String get branchCreated => 'Sucursal creada';

  @override
  String get addressLabel => 'Dirección';

  @override
  String get save => 'Guardar';

  @override
  String get create => 'Crear';

  @override
  String get clientUpdated => 'Cliente actualizado';

  @override
  String get clientCreated => 'Cliente creado';

  @override
  String get deleteClient => 'Eliminar Cliente';

  @override
  String get deleteConfirmation =>
      '¿Estás seguro de que deseas eliminar este cliente?';

  @override
  String get clientCannotUndo => 'Esta acción no se puede deshacer.';

  @override
  String get clientDeleted => 'Cliente eliminado';

  @override
  String get audioTestTitle => 'Test de Grabación de Audio';

  @override
  String get audioTestSubtitle =>
      'Prueba funcionalidad de grabación y transcripción';

  @override
  String get toolsSection => 'Herramientas de Testing';

  @override
  String get audioTestCard => 'Test de Audio';

  @override
  String get audioTestDescription =>
      'Prueba grabación y transcripción de voz a texto';

  @override
  String get branchInfoSection => 'Información';

  @override
  String get currentBranch => 'Sucursal Actual';

  @override
  String get branchName => 'Nombre';

  @override
  String get branchAddress => 'Dirección';

  @override
  String get limitedAccessStaff => 'Acceso limitado: vista de staff';

  @override
  String get recordingInstructions =>
      'Toca el micrófono para comenzar a grabar';

  @override
  String get tapToRecord => 'Toca para grabar';

  @override
  String get recording => 'GRABANDO';

  @override
  String get paused => 'PAUSADO';

  @override
  String maxDuration(String duration) {
    return 'Máximo: $duration';
  }

  @override
  String get recordingControls => 'Controles';

  @override
  String get cancelRecording => 'Cancelar';

  @override
  String get pauseRecording => 'Pausar';

  @override
  String get resumeRecording => 'Resumir';

  @override
  String get stopRecording => 'Finalizar';

  @override
  String get permissionRequired => 'Permiso Requerido';

  @override
  String get microphonePermissionMessage =>
      'Se necesita acceso al micrófono para grabar audio. Por favor, habilita el permiso en la configuración de la app.';

  @override
  String errorStartingRecording(String error) {
    return 'Error al iniciar grabación: $error';
  }

  @override
  String get recordedAudio => 'Audio Grabado';

  @override
  String get fileName => 'Archivo';

  @override
  String get fileSize => 'Tamaño';

  @override
  String get noRecordingsYet => 'Sin grabaciones aún';

  @override
  String get transcribeAudio => 'Transcribir Audio';

  @override
  String get transcribing => 'Transcribiendo...';

  @override
  String get transcription => 'Transcripción';

  @override
  String get copyToClipboard => 'Copiar';

  @override
  String get copiedToClipboard => 'Copiado al portapapeles';

  @override
  String get transcriptionCompleted => 'Transcripción completada ✅';

  @override
  String get textCopied => 'Texto copiado al portapapeles';

  @override
  String get recordingTest => 'Test de Grabación';

  @override
  String get transcriptionError => 'Error en transcripción';

  @override
  String get backendConnectionError =>
      'No se puede conectar al servidor. Verifica que el backend esté ejecutándose.';

  @override
  String transcriptionFailed(String error) {
    return 'Error al transcribir: $error';
  }

  @override
  String get searchPersonnel => 'Buscar Personal';

  @override
  String get noEmployeesFound => 'No se encontraron empleados';

  @override
  String get noName => 'Sin nombre';

  @override
  String roleBranchLabel(Object branch, Object role) {
    return 'Rol: $role - Sucursal: $branch';
  }

  @override
  String get matrix => 'Matriz';

  @override
  String get editPersonnel => 'Editar Personal';

  @override
  String get invitePersonnel => 'Invitar Personal';

  @override
  String get lastNameLabel => 'Apellido';

  @override
  String get docIdLabel => 'Documento Identidad';

  @override
  String get phoneLabel => 'Teléfono';

  @override
  String get roleLabel => 'Rol';

  @override
  String get adminRole => 'Administrador';

  @override
  String get managerRole => 'Gerente';

  @override
  String get userRole => 'Usuario / Staff';

  @override
  String get branchOptionalLabel => 'Sucursal (Opcional)';

  @override
  String get noBranchMatrixLabel => 'Sin Sucursal (Casa Matriz)';

  @override
  String get invite => 'Invitar';

  @override
  String get userUpdated => 'Usuario actualizado';

  @override
  String get invitationSent => 'Invitación enviada';

  @override
  String get generalSummary => 'Resumen General';

  @override
  String get incomeMonth => 'Ingresos (Mes)';

  @override
  String get claims => 'Reclamos';

  @override
  String get incomeByBranch => 'Ingresos por Sucursal';

  @override
  String get branchPanel => 'Panel de Sucursal';

  @override
  String branchLabel(Object name) {
    return 'Sucursal: $name';
  }

  @override
  String get branchManagementPanel => 'Panel de Gestión de Sucursal';

  @override
  String get viewClaims => 'Ver Reclamos';

  @override
  String get viewInteractions => 'Ver Interacciones';

  @override
  String staffPortalTitle(Object name) {
    return '$name - Portal Staff';
  }

  @override
  String get welcomeStaffPortal => 'Bienvenido al Portal de Staff';

  @override
  String get staffPortalSubtitle =>
      'Gestiona tus tareas y fichajes desde aquí.';

  @override
  String get clockIn => 'Fichar';

  @override
  String get myTasks => 'Mis Tareas';

  @override
  String get requests => 'Solicitudes';

  @override
  String get myProfile => 'Mi Perfil';

  @override
  String get backofficeTitle => 'Backoffice';

  @override
  String get recentActivity => 'Actividad Reciente';

  @override
  String get searchUserPlaceholder => 'Nombre o email';

  @override
  String userCount(Object count) {
    return '$count usuarios';
  }

  @override
  String paginationInfo(Object current, Object total) {
    return 'Página $current de $total';
  }

  @override
  String get noResults => 'Sin resultados';

  @override
  String get clientFileTitle => 'Ficha de Cliente';

  @override
  String get interactionHistory => 'Historial de Interacciones';

  @override
  String get reload => 'Recargar';

  @override
  String get noInteractions => 'No hay interacciones registradas';

  @override
  String get addNote => 'Agregar Nota';

  @override
  String get notePlaceholder => 'Escribe una nota sobre el cliente...';

  @override
  String errorLoadingInteractions(Object error) {
    return 'Error al cargar interacciones: $error';
  }

  @override
  String errorSavingNote(Object error) {
    return 'Error al guardar nota: $error';
  }

  @override
  String claimsTitle(Object name) {
    return 'Reclamos: $name';
  }

  @override
  String get noClaims => 'No hay reclamos registrados';

  @override
  String get newClaim => 'Nuevo Reclamo';

  @override
  String get titleLabel => 'Título';

  @override
  String get descriptionLabel => 'Descripción';

  @override
  String get priorityLabel => 'Prioridad';

  @override
  String get priorityLow => 'Baja';

  @override
  String get priorityMedium => 'Media';

  @override
  String get priorityHigh => 'Alta';

  @override
  String errorLoadingClaims(Object error) {
    return 'Error al cargar reclamos: $error';
  }

  @override
  String errorCreatingClaim(Object error) {
    return 'Error al crear reclamo: $error';
  }

  @override
  String get errorUpdatingClient => 'Error al actualizar cliente';

  @override
  String get branchManagementTitle => 'Gestión de Sucursales';

  @override
  String get personnelManagementTitle => 'Gestión de Personal';

  @override
  String get errorNoCompanyContext =>
      'Error: No se encontró empresa en el contexto';

  @override
  String get noBranchesRegistered => 'No hay sucursales registradas';

  @override
  String get noEmployeesRegistered => 'No hay empleados registrados';

  @override
  String get clientFormTitleNew => 'Nuevo Cliente';

  @override
  String get clientFormTitleEdit => 'Editar Cliente';

  @override
  String get labelBranch => 'Sucursal';

  @override
  String get labelHeadquarters => 'Casa Matriz / Global';

  @override
  String get typePerson => 'Persona';

  @override
  String get typeCompany => 'Empresa';

  @override
  String get labelBusinessName => 'Razón Social *';

  @override
  String get labelTaxId => 'CUIT *';

  @override
  String get labelContactName => 'Nombre Contacto *';

  @override
  String get labelContactLastName => 'Apellido Contacto';

  @override
  String get labelName => 'Nombre *';

  @override
  String get labelLastName => 'Apellido';

  @override
  String get labelIdDocument => 'DNI / Documento';

  @override
  String get labelEmail => 'Email';

  @override
  String get labelPhone => 'Teléfono';

  @override
  String get labelAddress => 'Dirección';

  @override
  String get labelNotes => 'Notas';

  @override
  String get btnCancel => 'Cancelar';

  @override
  String get btnSave => 'Guardar';

  @override
  String get validationRequired => 'Requerido';

  @override
  String get marketplaceTitle => 'Marketplace de Módulos';

  @override
  String errorUpdatingStatus(Object error) {
    return 'Error al actualizar estado: $error';
  }

  @override
  String get viewFile => 'Ver Ficha';

  @override
  String get permissionsLabel => 'Permisos:';

  @override
  String get statusPending => 'Pendiente';

  @override
  String get statusInProgress => 'En Proceso';

  @override
  String get statusResolved => 'Resuelto';

  @override
  String get statusClosed => 'Cerrado';

  @override
  String priorityDisplay(Object priority) {
    return 'Prioridad: $priority';
  }

  @override
  String get serverError =>
      'Error en el servidor. Por favor, intente más tarde.';

  @override
  String get authError => 'Error de autenticación.';

  @override
  String get networkError => 'Error de conexión. Verifique su internet.';

  @override
  String get validationError => 'Error de validación. Verifique los datos.';

  @override
  String get unknownError => 'Ha ocurrido un error inesperado.';

  @override
  String get superAdminDashboardTitle => 'Panel de Super Admin';

  @override
  String get companiesSection => 'Empresas';

  @override
  String get pendingInvitationsSection => 'Invitaciones Pendientes';

  @override
  String get noPendingInvitations => 'No hay invitaciones pendientes';

  @override
  String errorLoadingCompanies(Object error) {
    return 'Error cargando empresas: $error';
  }

  @override
  String get codeLabel => 'Código';

  @override
  String get createdLabel => 'Creada';

  @override
  String get manageModulesTooltip => 'Gestionar Módulos';

  @override
  String get manageCompanyTooltip => 'Gestionar Empresa';

  @override
  String get drawerHome => 'Inicio';

  @override
  String get drawerAdmin => 'Admin / Gerencia';

  @override
  String get drawerLogout => 'Cerrar Sesión';

  @override
  String get drawerLanguage => 'Idioma / Language';

  @override
  String get loginLabel => 'Usuario o Email';

  @override
  String get usernameLabel => 'Usuario';

  @override
  String get editProfile => 'Editar Perfil';

  @override
  String get profileUpdated => 'Perfil actualizado';

  @override
  String get usernameFieldLabel => 'Nombre de Usuario';

  @override
  String get clients => 'Clientes';

  @override
  String get userNotFound => 'Usuario no encontrado';

  @override
  String get userFetchError => 'No se pudo obtener el usuario.';

  @override
  String get loginSuccess => '¡Login exitoso!';

  @override
  String get loginError => 'Credenciales incorrectas o error desconocido.';

  @override
  String get registerSuccess =>
      '¡Registro exitoso! Revisa tu email para confirmar.';

  @override
  String get registerError =>
      'No se pudo registrar. Verifica los datos o tu email.';

  @override
  String get recoveryEmailInvalid =>
      'Ingresa un email válido para recuperar la contraseña.';

  @override
  String get recoveryEmailSent => '¡Email de recuperación enviado!';

  @override
  String get badCredentials => 'Email o contraseña incorrectos.';

  @override
  String get claimsManagementTitle => 'Gestión de Reclamos';

  @override
  String get searchClaimsPlaceholder => 'Buscar (ID, Titulo, Desc...)';

  @override
  String get allStatuses => 'Todos los Estados';

  @override
  String get allBranches => 'Todas las Sucursales';

  @override
  String get itemsPerPage => 'Items por pág:';

  @override
  String get crmConfig => 'Configuración CRM';

  @override
  String get noClientAssigned => 'Sin Cliente';

  @override
  String get loading => 'Cargando...';

  @override
  String get noClaimsFound => 'No se encontraron reclamos';

  @override
  String get importClients => 'Importar Clientes';

  @override
  String get pickFileCSV => 'Seleccionar Archivo (CSV)';

  @override
  String get preview => 'Vista Previa';

  @override
  String get importBtn => 'Importar';

  @override
  String importSuccess(Object count) {
    return 'Importación exitosa: $count clientes';
  }

  @override
  String importError(Object error) {
    return 'Error al importar: $error';
  }

  @override
  String rowsFound(Object count) {
    return '$count filas encontradas';
  }

  @override
  String get noClientsToExport => 'No hay clientes para exportar.';

  @override
  String exportSuccess(String path) {
    return 'Exportado exitosamente a: $path';
  }

  @override
  String exportError(String error) {
    return 'Error al exportar: $error';
  }

  @override
  String get companyCreatedSuccess => 'Empresa creada exitosamente';

  @override
  String get companyCodeExists => 'El código de empresa ya existe.';

  @override
  String companyCreationError(String error) {
    return 'Error al crear empresa: $error';
  }

  @override
  String get invitationDeleteSuccess => 'Invitación eliminada exitosamente';

  @override
  String invitationDeleteError(String error) {
    return 'Error al eliminar invitación: $error';
  }

  @override
  String clientUpdateError(String error) {
    return 'Error actualizando datos: $error';
  }

  @override
  String clientDeleteError(String error) {
    return 'Error al eliminar: $error';
  }

  @override
  String get claimDeleteSuccess => 'Reclamo eliminado';

  @override
  String configurationError(String error) {
    return 'Error en configuración: $error';
  }

  @override
  String clientImportError(String error) {
    return 'Error al importar: $error';
  }

  @override
  String get brandingCustomization => 'Personalización de Marca';

  @override
  String get brandingLoading => 'Cargando...';

  @override
  String brandingError(String error) {
    return 'Error: $error';
  }

  @override
  String get brandingNotFound => 'No se encontró configuración de branding';

  @override
  String get brandingTabLogos => 'Logos';

  @override
  String get brandingTabColorsBase => 'Colores Base';

  @override
  String get brandingTabColorsAdditional => 'Colores Adicionales';

  @override
  String get brandingTabTypography => 'Tipografía';

  @override
  String get brandingTabAdvanced => 'Avanzado';

  @override
  String get brandingLogosTitle => 'Logos de Empresa';

  @override
  String get brandingLogosSubtitle =>
      'Sube los logos de tu empresa para personalizar la app';

  @override
  String get brandingLogoPrimary => 'Logo Principal';

  @override
  String get brandingLogoPrimarySubtitle => 'Se muestra en el tema claro';

  @override
  String get brandingLogoLight => 'Logo Claro';

  @override
  String get brandingLogoLightSubtitle => 'Se muestra en el modo oscuro';

  @override
  String get brandingColorsBaseTitle => 'Colores Base';

  @override
  String get brandingColorsBaseSubtitle =>
      'Define los colores principales de tu marca';

  @override
  String get brandingColorPrimary => 'Color Primario';

  @override
  String get brandingColorSecondary => 'Color Secundario';

  @override
  String get brandingColorAccent => 'Color de Acento';

  @override
  String get brandingDarkMode => 'Dark Mode';

  @override
  String get brandingColorPrimaryDark => 'Primario (Dark)';

  @override
  String get brandingColorSecondaryDark => 'Secundario (Dark)';

  @override
  String get brandingColorsAdditionalTitle => 'Colores Adicionales';

  @override
  String get brandingColorsAdditionalSubtitle =>
      'Personaliza colores de fondo, texto y estados';

  @override
  String get brandingColorsGeneral => 'Colores Generales';

  @override
  String get brandingColorsStates => 'Colores de Estado';

  @override
  String get brandingColorBackground => 'Fondo';

  @override
  String get brandingColorText => 'Texto';

  @override
  String get brandingColorError => 'Error';

  @override
  String get brandingColorSuccess => 'Éxito';

  @override
  String get brandingColorWarning => 'Advertencia';

  @override
  String get brandingColorInfo => 'Información';

  @override
  String get brandingColorBackgroundDark => 'Fondo (Dark)';

  @override
  String get brandingColorTextDark => 'Texto (Dark)';

  @override
  String get brandingColorErrorDark => 'Error (Dark)';

  @override
  String get brandingColorSuccessDark => 'Éxito (Dark)';

  @override
  String get brandingColorWarningDark => 'Advertencia (Dark)';

  @override
  String get brandingColorInfoDark => 'Información (Dark)';

  @override
  String get brandingTypographyTitle => 'Tipografía';

  @override
  String get brandingTypographySubtitle =>
      'Selecciona las fuentes y tamaños de texto';

  @override
  String get brandingFonts => 'Fuentes';

  @override
  String get brandingFontPrimary => 'Fuente Primaria';

  @override
  String get brandingFontSecondary => 'Fuente Secundaria (Headers)';

  @override
  String get brandingSizes => 'Tamaños';

  @override
  String brandingTextSizeBase(int size) {
    return 'Tamaño de Texto Base: ${size}px';
  }

  @override
  String brandingTextSizeHeader(int size) {
    return 'Tamaño de Headers: ${size}px';
  }

  @override
  String brandingTextSizeExample(int size) {
    return 'Texto de ejemplo con tamaño ${size}px';
  }

  @override
  String get brandingHeaderExample => 'Título Ejemplo';

  @override
  String get brandingAdvancedTitle => 'Opciones Avanzadas';

  @override
  String get brandingAdvancedSubtitle =>
      'Presets predefinidos y opciones avanzadas';

  @override
  String get brandingPresets => 'Presets de Tema';

  @override
  String get brandingPresetsSubtitle =>
      'Aplica un preset predefinido para configurar rápidamente los colores';

  @override
  String get brandingPresetNone => 'Ninguno';

  @override
  String get brandingPresetSelect => 'Seleccionar Preset';

  @override
  String get brandingResetDefaults => 'Restaurar a Defaults';

  @override
  String get brandingInfo => 'Información';

  @override
  String brandingLastUpdated(String date) {
    return 'Última actualización: $date';
  }

  @override
  String brandingCreated(String date) {
    return 'Creado: $date';
  }

  @override
  String brandingPresetApplied(String name) {
    return 'Preset \"$name\" aplicado';
  }

  @override
  String get brandingResetDialogTitle => 'Restaurar Defaults';

  @override
  String get brandingResetDialogMessage =>
      '¿Estás seguro de que quieres restaurar todos los valores a los defaults?';

  @override
  String get brandingResetDialogConfirm => 'Restaurar';

  @override
  String get brandingSelectColor => 'Seleccionar Color';

  @override
  String get brandingSelectColorButton => 'Seleccionar';

  @override
  String get brandingSaveChanges => 'Guardar Cambios';

  @override
  String get brandingSaveSuccess => 'Branding actualizado exitosamente';

  @override
  String brandingSaveError(String error) {
    return 'Error al guardar: $error';
  }

  @override
  String get logoDeleteSuccess => 'Logo eliminado correctamente';
}
