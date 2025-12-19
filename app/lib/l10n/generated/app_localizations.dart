import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In es, this message translates to:
  /// **'Mi Primera App'**
  String get appTitle;

  /// No description provided for @loginTitle.
  ///
  /// In es, this message translates to:
  /// **'Iniciar Sesión'**
  String get loginTitle;

  /// No description provided for @emailLabel.
  ///
  /// In es, this message translates to:
  /// **'Correo Electrónico'**
  String get emailLabel;

  /// No description provided for @passwordLabel.
  ///
  /// In es, this message translates to:
  /// **'Contraseña'**
  String get passwordLabel;

  /// No description provided for @loginButton.
  ///
  /// In es, this message translates to:
  /// **'Ingresar'**
  String get loginButton;

  /// No description provided for @registerButton.
  ///
  /// In es, this message translates to:
  /// **'Registrarse'**
  String get registerButton;

  /// No description provided for @registerTitle.
  ///
  /// In es, this message translates to:
  /// **'Registro'**
  String get registerTitle;

  /// No description provided for @nameLabel.
  ///
  /// In es, this message translates to:
  /// **'Nombre'**
  String get nameLabel;

  /// No description provided for @welcomeMessage.
  ///
  /// In es, this message translates to:
  /// **'Bienvenido'**
  String get welcomeMessage;

  /// No description provided for @forgotPassword.
  ///
  /// In es, this message translates to:
  /// **'¿Olvidaste tu contraseña?'**
  String get forgotPassword;

  /// No description provided for @errorMessage.
  ///
  /// In es, this message translates to:
  /// **'Error: {error}'**
  String errorMessage(Object error);

  /// No description provided for @logout.
  ///
  /// In es, this message translates to:
  /// **'Cerrar Sesión'**
  String get logout;

  /// No description provided for @close.
  ///
  /// In es, this message translates to:
  /// **'Cerrar'**
  String get close;

  /// No description provided for @cancel.
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get cancel;

  /// No description provided for @roleDetected.
  ///
  /// In es, this message translates to:
  /// **'Rol detectado: {role}'**
  String roleDetected(Object role);

  /// No description provided for @none.
  ///
  /// In es, this message translates to:
  /// **'Ninguno'**
  String get none;

  /// No description provided for @debugMode.
  ///
  /// In es, this message translates to:
  /// **'Modo Debug'**
  String get debugMode;

  /// No description provided for @debugAdminMessage.
  ///
  /// In es, this message translates to:
  /// **'Para ver el Dashboard de Admin, tu usuario debe tener el rol \"admin\" en la base de datos.\n\n¿Quieres simular ser Admin ahora?'**
  String get debugAdminMessage;

  /// No description provided for @simulateNotImplemented.
  ///
  /// In es, this message translates to:
  /// **'Simular (No implementado)'**
  String get simulateNotImplemented;

  /// No description provided for @assignRoleMessage.
  ///
  /// In es, this message translates to:
  /// **'Por favor, asigna el rol \"admin\" en Supabase o usa un usuario admin.'**
  String get assignRoleMessage;

  /// No description provided for @whySeeThis.
  ///
  /// In es, this message translates to:
  /// **'¿Por qué veo esto?'**
  String get whySeeThis;

  /// No description provided for @emailLabelWithVal.
  ///
  /// In es, this message translates to:
  /// **'Email: {email}'**
  String emailLabelWithVal(Object email);

  /// No description provided for @permissions.
  ///
  /// In es, this message translates to:
  /// **'Permisos:'**
  String get permissions;

  /// No description provided for @companyLabelWithVal.
  ///
  /// In es, this message translates to:
  /// **'Empresa: {company}'**
  String companyLabelWithVal(Object company);

  /// No description provided for @branchLabelWithVal.
  ///
  /// In es, this message translates to:
  /// **'Sucursal: {branch}'**
  String branchLabelWithVal(Object branch);

  /// No description provided for @noCompanyAssigned.
  ///
  /// In es, this message translates to:
  /// **'No tienes empresa asignada.'**
  String get noCompanyAssigned;

  /// No description provided for @dashboardInactive.
  ///
  /// In es, this message translates to:
  /// **'Dashboard Inactivo'**
  String get dashboardInactive;

  /// No description provided for @dashboardDisabledMessage.
  ///
  /// In es, this message translates to:
  /// **'El módulo Dashboard está desactivado.'**
  String get dashboardDisabledMessage;

  /// No description provided for @adminActivateMessage.
  ///
  /// In es, this message translates to:
  /// **'Como administrador, puedes activarlo en el Marketplace.'**
  String get adminActivateMessage;

  /// No description provided for @goToMarketplace.
  ///
  /// In es, this message translates to:
  /// **'Ir al Marketplace'**
  String get goToMarketplace;

  /// No description provided for @accessDenied.
  ///
  /// In es, this message translates to:
  /// **'Acceso Denegado'**
  String get accessDenied;

  /// No description provided for @dashboardNotActive.
  ///
  /// In es, this message translates to:
  /// **'Dashboard no activo'**
  String get dashboardNotActive;

  /// No description provided for @contactAdminMessage.
  ///
  /// In es, this message translates to:
  /// **'Contacte a su administrador para activar este módulo.'**
  String get contactAdminMessage;

  /// No description provided for @userNotFoundDB.
  ///
  /// In es, this message translates to:
  /// **'No se encontró el usuario en la base de datos.'**
  String get userNotFoundDB;

  /// No description provided for @authenticatedUserId.
  ///
  /// In es, this message translates to:
  /// **'ID de usuario autenticado'**
  String get authenticatedUserId;

  /// No description provided for @viewUserId.
  ///
  /// In es, this message translates to:
  /// **'Ver ID de usuario'**
  String get viewUserId;

  /// No description provided for @companyPanel.
  ///
  /// In es, this message translates to:
  /// **'Panel de Empresa'**
  String get companyPanel;

  /// No description provided for @modulesMarketplace.
  ///
  /// In es, this message translates to:
  /// **'Marketplace de Módulos'**
  String get modulesMarketplace;

  /// No description provided for @summary.
  ///
  /// In es, this message translates to:
  /// **'Resumen'**
  String get summary;

  /// No description provided for @branches.
  ///
  /// In es, this message translates to:
  /// **'Sucursales'**
  String get branches;

  /// No description provided for @personnel.
  ///
  /// In es, this message translates to:
  /// **'Personal'**
  String get personnel;

  /// No description provided for @searchBranch.
  ///
  /// In es, this message translates to:
  /// **'Buscar Sucursal'**
  String get searchBranch;

  /// No description provided for @noBranchesFound.
  ///
  /// In es, this message translates to:
  /// **'No se encontraron sucursales'**
  String get noBranchesFound;

  /// No description provided for @noAddress.
  ///
  /// In es, this message translates to:
  /// **'Sin dirección'**
  String get noAddress;

  /// No description provided for @editBranch.
  ///
  /// In es, this message translates to:
  /// **'Editar Sucursal'**
  String get editBranch;

  /// No description provided for @newBranch.
  ///
  /// In es, this message translates to:
  /// **'Nueva Sucursal'**
  String get newBranch;

  /// No description provided for @branchUpdated.
  ///
  /// In es, this message translates to:
  /// **'Sucursal actualizada'**
  String get branchUpdated;

  /// No description provided for @branchCreated.
  ///
  /// In es, this message translates to:
  /// **'Sucursal creada'**
  String get branchCreated;

  /// No description provided for @addressLabel.
  ///
  /// In es, this message translates to:
  /// **'Dirección'**
  String get addressLabel;

  /// No description provided for @save.
  ///
  /// In es, this message translates to:
  /// **'Guardar'**
  String get save;

  /// No description provided for @create.
  ///
  /// In es, this message translates to:
  /// **'Crear'**
  String get create;

  /// No description provided for @clientUpdated.
  ///
  /// In es, this message translates to:
  /// **'Cliente actualizado'**
  String get clientUpdated;

  /// No description provided for @clientCreated.
  ///
  /// In es, this message translates to:
  /// **'Cliente creado'**
  String get clientCreated;

  /// No description provided for @deleteClient.
  ///
  /// In es, this message translates to:
  /// **'Eliminar Cliente'**
  String get deleteClient;

  /// No description provided for @deleteConfirmation.
  ///
  /// In es, this message translates to:
  /// **'¿Estás seguro de que deseas eliminar este cliente?'**
  String get deleteConfirmation;

  /// No description provided for @clientCannotUndo.
  ///
  /// In es, this message translates to:
  /// **'Esta acción no se puede deshacer.'**
  String get clientCannotUndo;

  /// No description provided for @clientDeleted.
  ///
  /// In es, this message translates to:
  /// **'Cliente eliminado'**
  String get clientDeleted;

  /// No description provided for @audioTestTitle.
  ///
  /// In es, this message translates to:
  /// **'Test de Grabación de Audio'**
  String get audioTestTitle;

  /// No description provided for @audioTestSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Prueba funcionalidad de grabación y transcripción'**
  String get audioTestSubtitle;

  /// No description provided for @toolsSection.
  ///
  /// In es, this message translates to:
  /// **'Herramientas de Testing'**
  String get toolsSection;

  /// No description provided for @audioTestCard.
  ///
  /// In es, this message translates to:
  /// **'Test de Audio'**
  String get audioTestCard;

  /// No description provided for @audioTestDescription.
  ///
  /// In es, this message translates to:
  /// **'Prueba grabación y transcripción de voz a texto'**
  String get audioTestDescription;

  /// No description provided for @branchInfoSection.
  ///
  /// In es, this message translates to:
  /// **'Información'**
  String get branchInfoSection;

  /// No description provided for @currentBranch.
  ///
  /// In es, this message translates to:
  /// **'Sucursal Actual'**
  String get currentBranch;

  /// No description provided for @branchName.
  ///
  /// In es, this message translates to:
  /// **'Nombre'**
  String get branchName;

  /// No description provided for @branchAddress.
  ///
  /// In es, this message translates to:
  /// **'Dirección'**
  String get branchAddress;

  /// No description provided for @limitedAccessStaff.
  ///
  /// In es, this message translates to:
  /// **'Acceso limitado: vista de staff'**
  String get limitedAccessStaff;

  /// No description provided for @recordingInstructions.
  ///
  /// In es, this message translates to:
  /// **'Toca el micrófono para comenzar a grabar'**
  String get recordingInstructions;

  /// No description provided for @tapToRecord.
  ///
  /// In es, this message translates to:
  /// **'Toca para grabar'**
  String get tapToRecord;

  /// No description provided for @recording.
  ///
  /// In es, this message translates to:
  /// **'GRABANDO'**
  String get recording;

  /// No description provided for @paused.
  ///
  /// In es, this message translates to:
  /// **'PAUSADO'**
  String get paused;

  /// No description provided for @maxDuration.
  ///
  /// In es, this message translates to:
  /// **'Máximo: {duration}'**
  String maxDuration(String duration);

  /// No description provided for @recordingControls.
  ///
  /// In es, this message translates to:
  /// **'Controles'**
  String get recordingControls;

  /// No description provided for @cancelRecording.
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get cancelRecording;

  /// No description provided for @pauseRecording.
  ///
  /// In es, this message translates to:
  /// **'Pausar'**
  String get pauseRecording;

  /// No description provided for @resumeRecording.
  ///
  /// In es, this message translates to:
  /// **'Resumir'**
  String get resumeRecording;

  /// No description provided for @stopRecording.
  ///
  /// In es, this message translates to:
  /// **'Finalizar'**
  String get stopRecording;

  /// No description provided for @permissionRequired.
  ///
  /// In es, this message translates to:
  /// **'Permiso Requerido'**
  String get permissionRequired;

  /// No description provided for @microphonePermissionMessage.
  ///
  /// In es, this message translates to:
  /// **'Se necesita acceso al micrófono para grabar audio. Por favor, habilita el permiso en la configuración de la app.'**
  String get microphonePermissionMessage;

  /// No description provided for @errorStartingRecording.
  ///
  /// In es, this message translates to:
  /// **'Error al iniciar grabación: {error}'**
  String errorStartingRecording(String error);

  /// No description provided for @recordedAudio.
  ///
  /// In es, this message translates to:
  /// **'Audio Grabado'**
  String get recordedAudio;

  /// No description provided for @fileName.
  ///
  /// In es, this message translates to:
  /// **'Archivo'**
  String get fileName;

  /// No description provided for @fileSize.
  ///
  /// In es, this message translates to:
  /// **'Tamaño'**
  String get fileSize;

  /// No description provided for @noRecordingsYet.
  ///
  /// In es, this message translates to:
  /// **'Sin grabaciones aún'**
  String get noRecordingsYet;

  /// No description provided for @transcribeAudio.
  ///
  /// In es, this message translates to:
  /// **'Transcribir Audio'**
  String get transcribeAudio;

  /// No description provided for @transcribing.
  ///
  /// In es, this message translates to:
  /// **'Transcribiendo...'**
  String get transcribing;

  /// No description provided for @transcription.
  ///
  /// In es, this message translates to:
  /// **'Transcripción'**
  String get transcription;

  /// No description provided for @copyToClipboard.
  ///
  /// In es, this message translates to:
  /// **'Copiar'**
  String get copyToClipboard;

  /// No description provided for @copiedToClipboard.
  ///
  /// In es, this message translates to:
  /// **'Copiado al portapapeles'**
  String get copiedToClipboard;

  /// No description provided for @transcriptionCompleted.
  ///
  /// In es, this message translates to:
  /// **'Transcripción completada ✅'**
  String get transcriptionCompleted;

  /// No description provided for @textCopied.
  ///
  /// In es, this message translates to:
  /// **'Texto copiado al portapapeles'**
  String get textCopied;

  /// No description provided for @recordingTest.
  ///
  /// In es, this message translates to:
  /// **'Test de Grabación'**
  String get recordingTest;

  /// No description provided for @transcriptionError.
  ///
  /// In es, this message translates to:
  /// **'Error en transcripción'**
  String get transcriptionError;

  /// No description provided for @backendConnectionError.
  ///
  /// In es, this message translates to:
  /// **'No se puede conectar al servidor. Verifica que el backend esté ejecutándose.'**
  String get backendConnectionError;

  /// No description provided for @transcriptionFailed.
  ///
  /// In es, this message translates to:
  /// **'Error al transcribir: {error}'**
  String transcriptionFailed(String error);

  /// No description provided for @searchPersonnel.
  ///
  /// In es, this message translates to:
  /// **'Buscar Personal'**
  String get searchPersonnel;

  /// No description provided for @noEmployeesFound.
  ///
  /// In es, this message translates to:
  /// **'No se encontraron empleados'**
  String get noEmployeesFound;

  /// No description provided for @noName.
  ///
  /// In es, this message translates to:
  /// **'Sin nombre'**
  String get noName;

  /// No description provided for @roleBranchLabel.
  ///
  /// In es, this message translates to:
  /// **'Rol: {role} - Sucursal: {branch}'**
  String roleBranchLabel(Object branch, Object role);

  /// No description provided for @matrix.
  ///
  /// In es, this message translates to:
  /// **'Matriz'**
  String get matrix;

  /// No description provided for @editPersonnel.
  ///
  /// In es, this message translates to:
  /// **'Editar Personal'**
  String get editPersonnel;

  /// No description provided for @invitePersonnel.
  ///
  /// In es, this message translates to:
  /// **'Invitar Personal'**
  String get invitePersonnel;

  /// No description provided for @lastNameLabel.
  ///
  /// In es, this message translates to:
  /// **'Apellido'**
  String get lastNameLabel;

  /// No description provided for @docIdLabel.
  ///
  /// In es, this message translates to:
  /// **'Documento Identidad'**
  String get docIdLabel;

  /// No description provided for @phoneLabel.
  ///
  /// In es, this message translates to:
  /// **'Teléfono'**
  String get phoneLabel;

  /// No description provided for @roleLabel.
  ///
  /// In es, this message translates to:
  /// **'Rol'**
  String get roleLabel;

  /// No description provided for @adminRole.
  ///
  /// In es, this message translates to:
  /// **'Administrador'**
  String get adminRole;

  /// No description provided for @managerRole.
  ///
  /// In es, this message translates to:
  /// **'Gerente'**
  String get managerRole;

  /// No description provided for @userRole.
  ///
  /// In es, this message translates to:
  /// **'Usuario / Staff'**
  String get userRole;

  /// No description provided for @branchOptionalLabel.
  ///
  /// In es, this message translates to:
  /// **'Sucursal (Opcional)'**
  String get branchOptionalLabel;

  /// No description provided for @noBranchMatrixLabel.
  ///
  /// In es, this message translates to:
  /// **'Sin Sucursal (Casa Matriz)'**
  String get noBranchMatrixLabel;

  /// No description provided for @invite.
  ///
  /// In es, this message translates to:
  /// **'Invitar'**
  String get invite;

  /// No description provided for @userUpdated.
  ///
  /// In es, this message translates to:
  /// **'Usuario actualizado'**
  String get userUpdated;

  /// No description provided for @invitationSent.
  ///
  /// In es, this message translates to:
  /// **'Invitación enviada'**
  String get invitationSent;

  /// No description provided for @generalSummary.
  ///
  /// In es, this message translates to:
  /// **'Resumen General'**
  String get generalSummary;

  /// No description provided for @incomeMonth.
  ///
  /// In es, this message translates to:
  /// **'Ingresos (Mes)'**
  String get incomeMonth;

  /// No description provided for @claims.
  ///
  /// In es, this message translates to:
  /// **'Reclamos'**
  String get claims;

  /// No description provided for @incomeByBranch.
  ///
  /// In es, this message translates to:
  /// **'Ingresos por Sucursal'**
  String get incomeByBranch;

  /// No description provided for @branchPanel.
  ///
  /// In es, this message translates to:
  /// **'Panel de Sucursal'**
  String get branchPanel;

  /// No description provided for @branchLabel.
  ///
  /// In es, this message translates to:
  /// **'Sucursal: {name}'**
  String branchLabel(Object name);

  /// No description provided for @branchManagementPanel.
  ///
  /// In es, this message translates to:
  /// **'Panel de Gestión de Sucursal'**
  String get branchManagementPanel;

  /// No description provided for @viewClaims.
  ///
  /// In es, this message translates to:
  /// **'Ver Reclamos'**
  String get viewClaims;

  /// No description provided for @viewInteractions.
  ///
  /// In es, this message translates to:
  /// **'Ver Interacciones'**
  String get viewInteractions;

  /// No description provided for @staffPortalTitle.
  ///
  /// In es, this message translates to:
  /// **'{name} - Portal Staff'**
  String staffPortalTitle(Object name);

  /// No description provided for @welcomeStaffPortal.
  ///
  /// In es, this message translates to:
  /// **'Bienvenido al Portal de Staff'**
  String get welcomeStaffPortal;

  /// No description provided for @staffPortalSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Gestiona tus tareas y fichajes desde aquí.'**
  String get staffPortalSubtitle;

  /// No description provided for @clockIn.
  ///
  /// In es, this message translates to:
  /// **'Fichar'**
  String get clockIn;

  /// No description provided for @myTasks.
  ///
  /// In es, this message translates to:
  /// **'Mis Tareas'**
  String get myTasks;

  /// No description provided for @requests.
  ///
  /// In es, this message translates to:
  /// **'Solicitudes'**
  String get requests;

  /// No description provided for @myProfile.
  ///
  /// In es, this message translates to:
  /// **'Mi Perfil'**
  String get myProfile;

  /// No description provided for @backofficeTitle.
  ///
  /// In es, this message translates to:
  /// **'Backoffice'**
  String get backofficeTitle;

  /// No description provided for @recentActivity.
  ///
  /// In es, this message translates to:
  /// **'Actividad Reciente'**
  String get recentActivity;

  /// No description provided for @searchUserPlaceholder.
  ///
  /// In es, this message translates to:
  /// **'Nombre o email'**
  String get searchUserPlaceholder;

  /// No description provided for @userCount.
  ///
  /// In es, this message translates to:
  /// **'{count} usuarios'**
  String userCount(Object count);

  /// No description provided for @paginationInfo.
  ///
  /// In es, this message translates to:
  /// **'Página {current} de {total}'**
  String paginationInfo(Object current, Object total);

  /// No description provided for @noResults.
  ///
  /// In es, this message translates to:
  /// **'Sin resultados'**
  String get noResults;

  /// No description provided for @clientFileTitle.
  ///
  /// In es, this message translates to:
  /// **'Ficha de Cliente'**
  String get clientFileTitle;

  /// No description provided for @interactionHistory.
  ///
  /// In es, this message translates to:
  /// **'Historial de Interacciones'**
  String get interactionHistory;

  /// No description provided for @reload.
  ///
  /// In es, this message translates to:
  /// **'Recargar'**
  String get reload;

  /// No description provided for @noInteractions.
  ///
  /// In es, this message translates to:
  /// **'No hay interacciones registradas'**
  String get noInteractions;

  /// No description provided for @addNote.
  ///
  /// In es, this message translates to:
  /// **'Agregar Nota'**
  String get addNote;

  /// No description provided for @notePlaceholder.
  ///
  /// In es, this message translates to:
  /// **'Escribe una nota sobre el cliente...'**
  String get notePlaceholder;

  /// No description provided for @errorLoadingInteractions.
  ///
  /// In es, this message translates to:
  /// **'Error al cargar interacciones: {error}'**
  String errorLoadingInteractions(Object error);

  /// No description provided for @errorSavingNote.
  ///
  /// In es, this message translates to:
  /// **'Error al guardar nota: {error}'**
  String errorSavingNote(Object error);

  /// No description provided for @claimsTitle.
  ///
  /// In es, this message translates to:
  /// **'Reclamos: {name}'**
  String claimsTitle(Object name);

  /// No description provided for @noClaims.
  ///
  /// In es, this message translates to:
  /// **'No hay reclamos registrados'**
  String get noClaims;

  /// No description provided for @newClaim.
  ///
  /// In es, this message translates to:
  /// **'Nuevo Reclamo'**
  String get newClaim;

  /// No description provided for @titleLabel.
  ///
  /// In es, this message translates to:
  /// **'Título'**
  String get titleLabel;

  /// No description provided for @descriptionLabel.
  ///
  /// In es, this message translates to:
  /// **'Descripción'**
  String get descriptionLabel;

  /// No description provided for @priorityLabel.
  ///
  /// In es, this message translates to:
  /// **'Prioridad'**
  String get priorityLabel;

  /// No description provided for @priorityLow.
  ///
  /// In es, this message translates to:
  /// **'Baja'**
  String get priorityLow;

  /// No description provided for @priorityMedium.
  ///
  /// In es, this message translates to:
  /// **'Media'**
  String get priorityMedium;

  /// No description provided for @priorityHigh.
  ///
  /// In es, this message translates to:
  /// **'Alta'**
  String get priorityHigh;

  /// No description provided for @errorLoadingClaims.
  ///
  /// In es, this message translates to:
  /// **'Error al cargar reclamos: {error}'**
  String errorLoadingClaims(Object error);

  /// No description provided for @errorCreatingClaim.
  ///
  /// In es, this message translates to:
  /// **'Error al crear reclamo: {error}'**
  String errorCreatingClaim(Object error);

  /// No description provided for @errorUpdatingClient.
  ///
  /// In es, this message translates to:
  /// **'Error al actualizar cliente'**
  String get errorUpdatingClient;

  /// No description provided for @branchManagementTitle.
  ///
  /// In es, this message translates to:
  /// **'Gestión de Sucursales'**
  String get branchManagementTitle;

  /// No description provided for @personnelManagementTitle.
  ///
  /// In es, this message translates to:
  /// **'Gestión de Personal'**
  String get personnelManagementTitle;

  /// No description provided for @errorNoCompanyContext.
  ///
  /// In es, this message translates to:
  /// **'Error: No se encontró empresa en el contexto'**
  String get errorNoCompanyContext;

  /// No description provided for @noBranchesRegistered.
  ///
  /// In es, this message translates to:
  /// **'No hay sucursales registradas'**
  String get noBranchesRegistered;

  /// No description provided for @noEmployeesRegistered.
  ///
  /// In es, this message translates to:
  /// **'No hay empleados registrados'**
  String get noEmployeesRegistered;

  /// No description provided for @clientFormTitleNew.
  ///
  /// In es, this message translates to:
  /// **'Nuevo Cliente'**
  String get clientFormTitleNew;

  /// No description provided for @clientFormTitleEdit.
  ///
  /// In es, this message translates to:
  /// **'Editar Cliente'**
  String get clientFormTitleEdit;

  /// No description provided for @labelBranch.
  ///
  /// In es, this message translates to:
  /// **'Sucursal'**
  String get labelBranch;

  /// No description provided for @labelHeadquarters.
  ///
  /// In es, this message translates to:
  /// **'Casa Matriz / Global'**
  String get labelHeadquarters;

  /// No description provided for @typePerson.
  ///
  /// In es, this message translates to:
  /// **'Persona'**
  String get typePerson;

  /// No description provided for @typeCompany.
  ///
  /// In es, this message translates to:
  /// **'Empresa'**
  String get typeCompany;

  /// No description provided for @labelBusinessName.
  ///
  /// In es, this message translates to:
  /// **'Razón Social *'**
  String get labelBusinessName;

  /// No description provided for @labelTaxId.
  ///
  /// In es, this message translates to:
  /// **'CUIT *'**
  String get labelTaxId;

  /// No description provided for @labelContactName.
  ///
  /// In es, this message translates to:
  /// **'Nombre Contacto *'**
  String get labelContactName;

  /// No description provided for @labelContactLastName.
  ///
  /// In es, this message translates to:
  /// **'Apellido Contacto'**
  String get labelContactLastName;

  /// No description provided for @labelName.
  ///
  /// In es, this message translates to:
  /// **'Nombre *'**
  String get labelName;

  /// No description provided for @labelLastName.
  ///
  /// In es, this message translates to:
  /// **'Apellido'**
  String get labelLastName;

  /// No description provided for @labelIdDocument.
  ///
  /// In es, this message translates to:
  /// **'DNI / Documento'**
  String get labelIdDocument;

  /// No description provided for @labelEmail.
  ///
  /// In es, this message translates to:
  /// **'Email'**
  String get labelEmail;

  /// No description provided for @labelPhone.
  ///
  /// In es, this message translates to:
  /// **'Teléfono'**
  String get labelPhone;

  /// No description provided for @labelAddress.
  ///
  /// In es, this message translates to:
  /// **'Dirección'**
  String get labelAddress;

  /// No description provided for @labelNotes.
  ///
  /// In es, this message translates to:
  /// **'Notas'**
  String get labelNotes;

  /// No description provided for @btnCancel.
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get btnCancel;

  /// No description provided for @btnSave.
  ///
  /// In es, this message translates to:
  /// **'Guardar'**
  String get btnSave;

  /// No description provided for @validationRequired.
  ///
  /// In es, this message translates to:
  /// **'Requerido'**
  String get validationRequired;

  /// No description provided for @marketplaceTitle.
  ///
  /// In es, this message translates to:
  /// **'Marketplace de Módulos'**
  String get marketplaceTitle;

  /// No description provided for @errorUpdatingStatus.
  ///
  /// In es, this message translates to:
  /// **'Error al actualizar estado: {error}'**
  String errorUpdatingStatus(Object error);

  /// No description provided for @viewFile.
  ///
  /// In es, this message translates to:
  /// **'Ver Ficha'**
  String get viewFile;

  /// No description provided for @permissionsLabel.
  ///
  /// In es, this message translates to:
  /// **'Permisos:'**
  String get permissionsLabel;

  /// No description provided for @statusPending.
  ///
  /// In es, this message translates to:
  /// **'Pendiente'**
  String get statusPending;

  /// No description provided for @statusInProgress.
  ///
  /// In es, this message translates to:
  /// **'En Proceso'**
  String get statusInProgress;

  /// No description provided for @statusResolved.
  ///
  /// In es, this message translates to:
  /// **'Resuelto'**
  String get statusResolved;

  /// No description provided for @statusClosed.
  ///
  /// In es, this message translates to:
  /// **'Cerrado'**
  String get statusClosed;

  /// No description provided for @priorityDisplay.
  ///
  /// In es, this message translates to:
  /// **'Prioridad: {priority}'**
  String priorityDisplay(Object priority);

  /// No description provided for @serverError.
  ///
  /// In es, this message translates to:
  /// **'Error en el servidor. Por favor, intente más tarde.'**
  String get serverError;

  /// No description provided for @authError.
  ///
  /// In es, this message translates to:
  /// **'Error de autenticación.'**
  String get authError;

  /// No description provided for @networkError.
  ///
  /// In es, this message translates to:
  /// **'Error de conexión. Verifique su internet.'**
  String get networkError;

  /// No description provided for @validationError.
  ///
  /// In es, this message translates to:
  /// **'Error de validación. Verifique los datos.'**
  String get validationError;

  /// No description provided for @unknownError.
  ///
  /// In es, this message translates to:
  /// **'Ha ocurrido un error inesperado.'**
  String get unknownError;

  /// No description provided for @superAdminDashboardTitle.
  ///
  /// In es, this message translates to:
  /// **'Panel de Super Admin'**
  String get superAdminDashboardTitle;

  /// No description provided for @companiesSection.
  ///
  /// In es, this message translates to:
  /// **'Empresas'**
  String get companiesSection;

  /// No description provided for @pendingInvitationsSection.
  ///
  /// In es, this message translates to:
  /// **'Invitaciones Pendientes'**
  String get pendingInvitationsSection;

  /// No description provided for @noPendingInvitations.
  ///
  /// In es, this message translates to:
  /// **'No hay invitaciones pendientes'**
  String get noPendingInvitations;

  /// No description provided for @errorLoadingCompanies.
  ///
  /// In es, this message translates to:
  /// **'Error cargando empresas: {error}'**
  String errorLoadingCompanies(Object error);

  /// No description provided for @codeLabel.
  ///
  /// In es, this message translates to:
  /// **'Código'**
  String get codeLabel;

  /// No description provided for @createdLabel.
  ///
  /// In es, this message translates to:
  /// **'Creada'**
  String get createdLabel;

  /// No description provided for @manageModulesTooltip.
  ///
  /// In es, this message translates to:
  /// **'Gestionar Módulos'**
  String get manageModulesTooltip;

  /// No description provided for @manageCompanyTooltip.
  ///
  /// In es, this message translates to:
  /// **'Gestionar Empresa'**
  String get manageCompanyTooltip;

  /// No description provided for @drawerHome.
  ///
  /// In es, this message translates to:
  /// **'Inicio'**
  String get drawerHome;

  /// No description provided for @drawerAdmin.
  ///
  /// In es, this message translates to:
  /// **'Admin / Gerencia'**
  String get drawerAdmin;

  /// No description provided for @drawerLogout.
  ///
  /// In es, this message translates to:
  /// **'Cerrar Sesión'**
  String get drawerLogout;

  /// No description provided for @drawerLanguage.
  ///
  /// In es, this message translates to:
  /// **'Idioma / Language'**
  String get drawerLanguage;

  /// No description provided for @loginLabel.
  ///
  /// In es, this message translates to:
  /// **'Usuario o Email'**
  String get loginLabel;

  /// No description provided for @usernameLabel.
  ///
  /// In es, this message translates to:
  /// **'Usuario'**
  String get usernameLabel;

  /// No description provided for @editProfile.
  ///
  /// In es, this message translates to:
  /// **'Editar Perfil'**
  String get editProfile;

  /// No description provided for @profileUpdated.
  ///
  /// In es, this message translates to:
  /// **'Perfil actualizado'**
  String get profileUpdated;

  /// No description provided for @usernameFieldLabel.
  ///
  /// In es, this message translates to:
  /// **'Nombre de Usuario'**
  String get usernameFieldLabel;

  /// No description provided for @clients.
  ///
  /// In es, this message translates to:
  /// **'Clientes'**
  String get clients;

  /// No description provided for @userNotFound.
  ///
  /// In es, this message translates to:
  /// **'Usuario no encontrado'**
  String get userNotFound;

  /// No description provided for @userFetchError.
  ///
  /// In es, this message translates to:
  /// **'No se pudo obtener el usuario.'**
  String get userFetchError;

  /// No description provided for @loginSuccess.
  ///
  /// In es, this message translates to:
  /// **'¡Login exitoso!'**
  String get loginSuccess;

  /// No description provided for @loginError.
  ///
  /// In es, this message translates to:
  /// **'Credenciales incorrectas o error desconocido.'**
  String get loginError;

  /// No description provided for @registerSuccess.
  ///
  /// In es, this message translates to:
  /// **'¡Registro exitoso! Revisa tu email para confirmar.'**
  String get registerSuccess;

  /// No description provided for @registerError.
  ///
  /// In es, this message translates to:
  /// **'No se pudo registrar. Verifica los datos o tu email.'**
  String get registerError;

  /// No description provided for @recoveryEmailInvalid.
  ///
  /// In es, this message translates to:
  /// **'Ingresa un email válido para recuperar la contraseña.'**
  String get recoveryEmailInvalid;

  /// No description provided for @recoveryEmailSent.
  ///
  /// In es, this message translates to:
  /// **'¡Email de recuperación enviado!'**
  String get recoveryEmailSent;

  /// No description provided for @badCredentials.
  ///
  /// In es, this message translates to:
  /// **'Email o contraseña incorrectos.'**
  String get badCredentials;

  /// No description provided for @claimsManagementTitle.
  ///
  /// In es, this message translates to:
  /// **'Gestión de Reclamos'**
  String get claimsManagementTitle;

  /// No description provided for @searchClaimsPlaceholder.
  ///
  /// In es, this message translates to:
  /// **'Buscar (ID, Titulo, Desc...)'**
  String get searchClaimsPlaceholder;

  /// No description provided for @allStatuses.
  ///
  /// In es, this message translates to:
  /// **'Todos los Estados'**
  String get allStatuses;

  /// No description provided for @allBranches.
  ///
  /// In es, this message translates to:
  /// **'Todas las Sucursales'**
  String get allBranches;

  /// No description provided for @itemsPerPage.
  ///
  /// In es, this message translates to:
  /// **'Items por pág:'**
  String get itemsPerPage;

  /// No description provided for @crmConfig.
  ///
  /// In es, this message translates to:
  /// **'Configuración CRM'**
  String get crmConfig;

  /// No description provided for @noClientAssigned.
  ///
  /// In es, this message translates to:
  /// **'Sin Cliente'**
  String get noClientAssigned;

  /// No description provided for @loading.
  ///
  /// In es, this message translates to:
  /// **'Cargando...'**
  String get loading;

  /// No description provided for @noClaimsFound.
  ///
  /// In es, this message translates to:
  /// **'No se encontraron reclamos'**
  String get noClaimsFound;

  /// No description provided for @importClients.
  ///
  /// In es, this message translates to:
  /// **'Importar Clientes'**
  String get importClients;

  /// No description provided for @pickFileCSV.
  ///
  /// In es, this message translates to:
  /// **'Seleccionar Archivo (CSV)'**
  String get pickFileCSV;

  /// No description provided for @preview.
  ///
  /// In es, this message translates to:
  /// **'Vista Previa'**
  String get preview;

  /// No description provided for @importBtn.
  ///
  /// In es, this message translates to:
  /// **'Importar'**
  String get importBtn;

  /// No description provided for @importSuccess.
  ///
  /// In es, this message translates to:
  /// **'Importación exitosa: {count} clientes'**
  String importSuccess(Object count);

  /// No description provided for @importError.
  ///
  /// In es, this message translates to:
  /// **'Error al importar: {error}'**
  String importError(Object error);

  /// No description provided for @rowsFound.
  ///
  /// In es, this message translates to:
  /// **'{count} filas encontradas'**
  String rowsFound(Object count);

  /// No description provided for @noClientsToExport.
  ///
  /// In es, this message translates to:
  /// **'No hay clientes para exportar.'**
  String get noClientsToExport;

  /// No description provided for @exportSuccess.
  ///
  /// In es, this message translates to:
  /// **'Exportado exitosamente a: {path}'**
  String exportSuccess(String path);

  /// No description provided for @exportError.
  ///
  /// In es, this message translates to:
  /// **'Error al exportar: {error}'**
  String exportError(String error);

  /// No description provided for @companyCreatedSuccess.
  ///
  /// In es, this message translates to:
  /// **'Empresa creada exitosamente'**
  String get companyCreatedSuccess;

  /// No description provided for @companyCodeExists.
  ///
  /// In es, this message translates to:
  /// **'El código de empresa ya existe.'**
  String get companyCodeExists;

  /// No description provided for @companyCreationError.
  ///
  /// In es, this message translates to:
  /// **'Error al crear empresa: {error}'**
  String companyCreationError(String error);

  /// No description provided for @invitationDeleteSuccess.
  ///
  /// In es, this message translates to:
  /// **'Invitación eliminada exitosamente'**
  String get invitationDeleteSuccess;

  /// No description provided for @invitationDeleteError.
  ///
  /// In es, this message translates to:
  /// **'Error al eliminar invitación: {error}'**
  String invitationDeleteError(String error);

  /// No description provided for @clientUpdateError.
  ///
  /// In es, this message translates to:
  /// **'Error actualizando datos: {error}'**
  String clientUpdateError(String error);

  /// No description provided for @clientDeleteError.
  ///
  /// In es, this message translates to:
  /// **'Error al eliminar: {error}'**
  String clientDeleteError(String error);

  /// No description provided for @claimDeleteSuccess.
  ///
  /// In es, this message translates to:
  /// **'Reclamo eliminado'**
  String get claimDeleteSuccess;

  /// No description provided for @configurationError.
  ///
  /// In es, this message translates to:
  /// **'Error en configuración: {error}'**
  String configurationError(String error);

  /// No description provided for @clientImportError.
  ///
  /// In es, this message translates to:
  /// **'Error al importar: {error}'**
  String clientImportError(String error);

  /// No description provided for @brandingCustomization.
  ///
  /// In es, this message translates to:
  /// **'Personalización de Marca'**
  String get brandingCustomization;

  /// No description provided for @brandingLoading.
  ///
  /// In es, this message translates to:
  /// **'Cargando...'**
  String get brandingLoading;

  /// No description provided for @brandingError.
  ///
  /// In es, this message translates to:
  /// **'Error: {error}'**
  String brandingError(String error);

  /// No description provided for @brandingNotFound.
  ///
  /// In es, this message translates to:
  /// **'No se encontró configuración de branding'**
  String get brandingNotFound;

  /// No description provided for @brandingTabLogos.
  ///
  /// In es, this message translates to:
  /// **'Logos'**
  String get brandingTabLogos;

  /// No description provided for @brandingTabColorsBase.
  ///
  /// In es, this message translates to:
  /// **'Colores Base'**
  String get brandingTabColorsBase;

  /// No description provided for @brandingTabColorsAdditional.
  ///
  /// In es, this message translates to:
  /// **'Colores Adicionales'**
  String get brandingTabColorsAdditional;

  /// No description provided for @brandingTabTypography.
  ///
  /// In es, this message translates to:
  /// **'Tipografía'**
  String get brandingTabTypography;

  /// No description provided for @brandingTabAdvanced.
  ///
  /// In es, this message translates to:
  /// **'Avanzado'**
  String get brandingTabAdvanced;

  /// No description provided for @brandingLogosTitle.
  ///
  /// In es, this message translates to:
  /// **'Logos de Empresa'**
  String get brandingLogosTitle;

  /// No description provided for @brandingLogosSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Sube los logos de tu empresa para personalizar la app'**
  String get brandingLogosSubtitle;

  /// No description provided for @brandingLogoPrimary.
  ///
  /// In es, this message translates to:
  /// **'Logo Principal'**
  String get brandingLogoPrimary;

  /// No description provided for @brandingLogoPrimarySubtitle.
  ///
  /// In es, this message translates to:
  /// **'Se muestra en el tema claro'**
  String get brandingLogoPrimarySubtitle;

  /// No description provided for @brandingLogoLight.
  ///
  /// In es, this message translates to:
  /// **'Logo Claro'**
  String get brandingLogoLight;

  /// No description provided for @brandingLogoLightSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Se muestra en el modo oscuro'**
  String get brandingLogoLightSubtitle;

  /// No description provided for @brandingColorsBaseTitle.
  ///
  /// In es, this message translates to:
  /// **'Colores Base'**
  String get brandingColorsBaseTitle;

  /// No description provided for @brandingColorsBaseSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Define los colores principales de tu marca'**
  String get brandingColorsBaseSubtitle;

  /// No description provided for @brandingColorPrimary.
  ///
  /// In es, this message translates to:
  /// **'Color Primario'**
  String get brandingColorPrimary;

  /// No description provided for @brandingColorSecondary.
  ///
  /// In es, this message translates to:
  /// **'Color Secundario'**
  String get brandingColorSecondary;

  /// No description provided for @brandingColorAccent.
  ///
  /// In es, this message translates to:
  /// **'Color de Acento'**
  String get brandingColorAccent;

  /// No description provided for @brandingDarkMode.
  ///
  /// In es, this message translates to:
  /// **'Dark Mode'**
  String get brandingDarkMode;

  /// No description provided for @brandingColorPrimaryDark.
  ///
  /// In es, this message translates to:
  /// **'Primario (Dark)'**
  String get brandingColorPrimaryDark;

  /// No description provided for @brandingColorSecondaryDark.
  ///
  /// In es, this message translates to:
  /// **'Secundario (Dark)'**
  String get brandingColorSecondaryDark;

  /// No description provided for @brandingColorsAdditionalTitle.
  ///
  /// In es, this message translates to:
  /// **'Colores Adicionales'**
  String get brandingColorsAdditionalTitle;

  /// No description provided for @brandingColorsAdditionalSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Personaliza colores de fondo, texto y estados'**
  String get brandingColorsAdditionalSubtitle;

  /// No description provided for @brandingColorsGeneral.
  ///
  /// In es, this message translates to:
  /// **'Colores Generales'**
  String get brandingColorsGeneral;

  /// No description provided for @brandingColorsStates.
  ///
  /// In es, this message translates to:
  /// **'Colores de Estado'**
  String get brandingColorsStates;

  /// No description provided for @brandingColorBackground.
  ///
  /// In es, this message translates to:
  /// **'Fondo'**
  String get brandingColorBackground;

  /// No description provided for @brandingColorText.
  ///
  /// In es, this message translates to:
  /// **'Texto'**
  String get brandingColorText;

  /// No description provided for @brandingColorError.
  ///
  /// In es, this message translates to:
  /// **'Error'**
  String get brandingColorError;

  /// No description provided for @brandingColorSuccess.
  ///
  /// In es, this message translates to:
  /// **'Éxito'**
  String get brandingColorSuccess;

  /// No description provided for @brandingColorWarning.
  ///
  /// In es, this message translates to:
  /// **'Advertencia'**
  String get brandingColorWarning;

  /// No description provided for @brandingColorInfo.
  ///
  /// In es, this message translates to:
  /// **'Información'**
  String get brandingColorInfo;

  /// No description provided for @brandingColorBackgroundDark.
  ///
  /// In es, this message translates to:
  /// **'Fondo (Dark)'**
  String get brandingColorBackgroundDark;

  /// No description provided for @brandingColorTextDark.
  ///
  /// In es, this message translates to:
  /// **'Texto (Dark)'**
  String get brandingColorTextDark;

  /// No description provided for @brandingColorErrorDark.
  ///
  /// In es, this message translates to:
  /// **'Error (Dark)'**
  String get brandingColorErrorDark;

  /// No description provided for @brandingColorSuccessDark.
  ///
  /// In es, this message translates to:
  /// **'Éxito (Dark)'**
  String get brandingColorSuccessDark;

  /// No description provided for @brandingColorWarningDark.
  ///
  /// In es, this message translates to:
  /// **'Advertencia (Dark)'**
  String get brandingColorWarningDark;

  /// No description provided for @brandingColorInfoDark.
  ///
  /// In es, this message translates to:
  /// **'Información (Dark)'**
  String get brandingColorInfoDark;

  /// No description provided for @brandingTypographyTitle.
  ///
  /// In es, this message translates to:
  /// **'Tipografía'**
  String get brandingTypographyTitle;

  /// No description provided for @brandingTypographySubtitle.
  ///
  /// In es, this message translates to:
  /// **'Selecciona las fuentes y tamaños de texto'**
  String get brandingTypographySubtitle;

  /// No description provided for @brandingFonts.
  ///
  /// In es, this message translates to:
  /// **'Fuentes'**
  String get brandingFonts;

  /// No description provided for @brandingFontPrimary.
  ///
  /// In es, this message translates to:
  /// **'Fuente Primaria'**
  String get brandingFontPrimary;

  /// No description provided for @brandingFontSecondary.
  ///
  /// In es, this message translates to:
  /// **'Fuente Secundaria (Headers)'**
  String get brandingFontSecondary;

  /// No description provided for @brandingSizes.
  ///
  /// In es, this message translates to:
  /// **'Tamaños'**
  String get brandingSizes;

  /// No description provided for @brandingTextSizeBase.
  ///
  /// In es, this message translates to:
  /// **'Tamaño de Texto Base: {size}px'**
  String brandingTextSizeBase(int size);

  /// No description provided for @brandingTextSizeHeader.
  ///
  /// In es, this message translates to:
  /// **'Tamaño de Headers: {size}px'**
  String brandingTextSizeHeader(int size);

  /// No description provided for @brandingTextSizeExample.
  ///
  /// In es, this message translates to:
  /// **'Texto de ejemplo con tamaño {size}px'**
  String brandingTextSizeExample(int size);

  /// No description provided for @brandingHeaderExample.
  ///
  /// In es, this message translates to:
  /// **'Título Ejemplo'**
  String get brandingHeaderExample;

  /// No description provided for @brandingAdvancedTitle.
  ///
  /// In es, this message translates to:
  /// **'Opciones Avanzadas'**
  String get brandingAdvancedTitle;

  /// No description provided for @brandingAdvancedSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Presets predefinidos y opciones avanzadas'**
  String get brandingAdvancedSubtitle;

  /// No description provided for @brandingPresets.
  ///
  /// In es, this message translates to:
  /// **'Presets de Tema'**
  String get brandingPresets;

  /// No description provided for @brandingPresetsSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Aplica un preset predefinido para configurar rápidamente los colores'**
  String get brandingPresetsSubtitle;

  /// No description provided for @brandingPresetNone.
  ///
  /// In es, this message translates to:
  /// **'Ninguno'**
  String get brandingPresetNone;

  /// No description provided for @brandingPresetSelect.
  ///
  /// In es, this message translates to:
  /// **'Seleccionar Preset'**
  String get brandingPresetSelect;

  /// No description provided for @brandingResetDefaults.
  ///
  /// In es, this message translates to:
  /// **'Restaurar a Defaults'**
  String get brandingResetDefaults;

  /// No description provided for @brandingInfo.
  ///
  /// In es, this message translates to:
  /// **'Información'**
  String get brandingInfo;

  /// No description provided for @brandingLastUpdated.
  ///
  /// In es, this message translates to:
  /// **'Última actualización: {date}'**
  String brandingLastUpdated(String date);

  /// No description provided for @brandingCreated.
  ///
  /// In es, this message translates to:
  /// **'Creado: {date}'**
  String brandingCreated(String date);

  /// No description provided for @brandingPresetApplied.
  ///
  /// In es, this message translates to:
  /// **'Preset \"{name}\" aplicado'**
  String brandingPresetApplied(String name);

  /// No description provided for @brandingResetDialogTitle.
  ///
  /// In es, this message translates to:
  /// **'Restaurar Defaults'**
  String get brandingResetDialogTitle;

  /// No description provided for @brandingResetDialogMessage.
  ///
  /// In es, this message translates to:
  /// **'¿Estás seguro de que quieres restaurar todos los valores a los defaults?'**
  String get brandingResetDialogMessage;

  /// No description provided for @brandingResetDialogConfirm.
  ///
  /// In es, this message translates to:
  /// **'Restaurar'**
  String get brandingResetDialogConfirm;

  /// No description provided for @brandingSelectColor.
  ///
  /// In es, this message translates to:
  /// **'Seleccionar Color'**
  String get brandingSelectColor;

  /// No description provided for @brandingSelectColorButton.
  ///
  /// In es, this message translates to:
  /// **'Seleccionar'**
  String get brandingSelectColorButton;

  /// No description provided for @brandingSaveChanges.
  ///
  /// In es, this message translates to:
  /// **'Guardar Cambios'**
  String get brandingSaveChanges;

  /// No description provided for @brandingSaveSuccess.
  ///
  /// In es, this message translates to:
  /// **'Branding actualizado exitosamente'**
  String get brandingSaveSuccess;

  /// No description provided for @brandingSaveError.
  ///
  /// In es, this message translates to:
  /// **'Error al guardar: {error}'**
  String brandingSaveError(String error);

  /// No description provided for @logoDeleteSuccess.
  ///
  /// In es, this message translates to:
  /// **'Logo eliminado correctamente'**
  String get logoDeleteSuccess;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
