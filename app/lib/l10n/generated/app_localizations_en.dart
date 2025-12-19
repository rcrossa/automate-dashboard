// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'My First App';

  @override
  String get loginTitle => 'Login';

  @override
  String get emailLabel => 'Email';

  @override
  String get passwordLabel => 'Password';

  @override
  String get loginButton => 'Sign In';

  @override
  String get registerButton => 'Register';

  @override
  String get registerTitle => 'Register';

  @override
  String get nameLabel => 'Name';

  @override
  String get welcomeMessage => 'Welcome';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String errorMessage(Object error) {
    return 'Error: $error';
  }

  @override
  String get logout => 'Logout';

  @override
  String get close => 'Close';

  @override
  String get cancel => 'Cancel';

  @override
  String roleDetected(Object role) {
    return 'Role detected: $role';
  }

  @override
  String get none => 'None';

  @override
  String get debugMode => 'Debug Mode';

  @override
  String get debugAdminMessage =>
      'To see the Admin Dashboard, your user must have the \"admin\" role in the database.\n\nDo you want to simulate being Admin now?';

  @override
  String get simulateNotImplemented => 'Simulate (Not implemented)';

  @override
  String get assignRoleMessage =>
      'Please assign the \"admin\" role in Supabase or use an admin user.';

  @override
  String get whySeeThis => 'Why am I seeing this?';

  @override
  String emailLabelWithVal(Object email) {
    return 'Email: $email';
  }

  @override
  String get permissions => 'Permissions:';

  @override
  String companyLabelWithVal(Object company) {
    return 'Company: $company';
  }

  @override
  String branchLabelWithVal(Object branch) {
    return 'Branch: $branch';
  }

  @override
  String get noCompanyAssigned => 'No company assigned.';

  @override
  String get dashboardInactive => 'Dashboard Inactive';

  @override
  String get dashboardDisabledMessage => 'The Dashboard module is disabled.';

  @override
  String get adminActivateMessage =>
      'As an administrator, you can activate it in the Marketplace.';

  @override
  String get goToMarketplace => 'Go to Marketplace';

  @override
  String get accessDenied => 'Access Denied';

  @override
  String get dashboardNotActive => 'Dashboard not active';

  @override
  String get contactAdminMessage =>
      'Contact your administrator to activate this module.';

  @override
  String get userNotFoundDB => 'User not found in database.';

  @override
  String get authenticatedUserId => 'Authenticated User ID';

  @override
  String get viewUserId => 'View User ID';

  @override
  String get companyPanel => 'Company Panel';

  @override
  String get modulesMarketplace => 'Modules Marketplace';

  @override
  String get summary => 'Summary';

  @override
  String get branches => 'Branches';

  @override
  String get personnel => 'Personnel';

  @override
  String get searchBranch => 'Search Branch';

  @override
  String get noBranchesFound => 'No branches found';

  @override
  String get noAddress => 'No address';

  @override
  String get editBranch => 'Edit Branch';

  @override
  String get newBranch => 'New Branch';

  @override
  String get branchUpdated => 'Branch updated';

  @override
  String get branchCreated => 'Branch created';

  @override
  String get addressLabel => 'Address';

  @override
  String get save => 'Save';

  @override
  String get create => 'Create';

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
  String get audioTestTitle => 'Audio Recording Test';

  @override
  String get audioTestSubtitle =>
      'Test recording and transcription functionality';

  @override
  String get toolsSection => 'Testing Tools';

  @override
  String get audioTestCard => 'Audio Test';

  @override
  String get audioTestDescription =>
      'Test voice recording and speech-to-text transcription';

  @override
  String get branchInfoSection => 'Information';

  @override
  String get currentBranch => 'Current Branch';

  @override
  String get branchName => 'Name';

  @override
  String get branchAddress => 'Address';

  @override
  String get limitedAccessStaff => 'Limited access: staff view';

  @override
  String get recordingInstructions => 'Tap the microphone to start recording';

  @override
  String get tapToRecord => 'Tap to record';

  @override
  String get recording => 'RECORDING';

  @override
  String get paused => 'PAUSED';

  @override
  String maxDuration(String duration) {
    return 'Maximum: $duration';
  }

  @override
  String get recordingControls => 'Controls';

  @override
  String get cancelRecording => 'Cancel';

  @override
  String get pauseRecording => 'Pause';

  @override
  String get resumeRecording => 'Resume';

  @override
  String get stopRecording => 'Finish';

  @override
  String get permissionRequired => 'Permission Required';

  @override
  String get microphonePermissionMessage =>
      'Microphone access is needed to record audio. Please enable the permission in app settings.';

  @override
  String errorStartingRecording(String error) {
    return 'Error starting recording: $error';
  }

  @override
  String get recordedAudio => 'Recorded Audio';

  @override
  String get fileName => 'File';

  @override
  String get fileSize => 'Size';

  @override
  String get noRecordingsYet => 'No recordings yet';

  @override
  String get transcribeAudio => 'Transcribe Audio';

  @override
  String get transcribing => 'Transcribing...';

  @override
  String get transcription => 'Transcription';

  @override
  String get copyToClipboard => 'Copy';

  @override
  String get copiedToClipboard => 'Copied to clipboard';

  @override
  String get transcriptionCompleted => 'Transcription completed ✅';

  @override
  String get textCopied => 'Text copied to clipboard';

  @override
  String get recordingTest => 'Recording Test';

  @override
  String get transcriptionError => 'Transcription error';

  @override
  String get backendConnectionError =>
      'Cannot connect to server. Verify that the backend is running.';

  @override
  String transcriptionFailed(String error) {
    return 'Transcription failed: $error';
  }

  @override
  String get searchPersonnel => 'Search Personnel';

  @override
  String get noEmployeesFound => 'No employees found';

  @override
  String get noName => 'No name';

  @override
  String roleBranchLabel(Object branch, Object role) {
    return 'Role: $role - Branch: $branch';
  }

  @override
  String get matrix => 'HQ';

  @override
  String get editPersonnel => 'Edit Personnel';

  @override
  String get invitePersonnel => 'Invite Personnel';

  @override
  String get lastNameLabel => 'Last Name';

  @override
  String get docIdLabel => 'Document ID';

  @override
  String get phoneLabel => 'Phone';

  @override
  String get roleLabel => 'Role';

  @override
  String get adminRole => 'Administrator';

  @override
  String get managerRole => 'Manager';

  @override
  String get userRole => 'User / Staff';

  @override
  String get branchOptionalLabel => 'Branch (Optional)';

  @override
  String get noBranchMatrixLabel => 'No Branch (HQ)';

  @override
  String get invite => 'Invite';

  @override
  String get userUpdated => 'User updated';

  @override
  String get invitationSent => 'Invitation sent';

  @override
  String get generalSummary => 'General Summary';

  @override
  String get incomeMonth => 'Income (Month)';

  @override
  String get claims => 'Claims';

  @override
  String get incomeByBranch => 'Income by Branch';

  @override
  String get branchPanel => 'Branch Panel';

  @override
  String branchLabel(Object name) {
    return 'Branch: $name';
  }

  @override
  String get branchManagementPanel => 'Branch Management Panel';

  @override
  String get viewClaims => 'View Claims';

  @override
  String get viewInteractions => 'View Interactions';

  @override
  String staffPortalTitle(Object name) {
    return '$name - Staff Portal';
  }

  @override
  String get welcomeStaffPortal => 'Welcome to Staff Portal';

  @override
  String get staffPortalSubtitle =>
      'Manage your tasks and clock-ins from here.';

  @override
  String get clockIn => 'Clock In';

  @override
  String get myTasks => 'My Tasks';

  @override
  String get requests => 'Requests';

  @override
  String get myProfile => 'My Profile';

  @override
  String get backofficeTitle => 'Backoffice';

  @override
  String get recentActivity => 'Recent Activity';

  @override
  String get searchUserPlaceholder => 'Name or email';

  @override
  String userCount(Object count) {
    return '$count users';
  }

  @override
  String paginationInfo(Object current, Object total) {
    return 'Page $current of $total';
  }

  @override
  String get noResults => 'No results';

  @override
  String get clientFileTitle => 'Client File';

  @override
  String get interactionHistory => 'Interaction History';

  @override
  String get reload => 'Reload';

  @override
  String get noInteractions => 'No interactions registered';

  @override
  String get addNote => 'Add Note';

  @override
  String get notePlaceholder => 'Write a note about the client...';

  @override
  String errorLoadingInteractions(Object error) {
    return 'Error loading interactions: $error';
  }

  @override
  String errorSavingNote(Object error) {
    return 'Error saving note: $error';
  }

  @override
  String claimsTitle(Object name) {
    return 'Claims: $name';
  }

  @override
  String get noClaims => 'No claims registered';

  @override
  String get newClaim => 'New Claim';

  @override
  String get titleLabel => 'Title';

  @override
  String get descriptionLabel => 'Description';

  @override
  String get priorityLabel => 'Priority';

  @override
  String get priorityLow => 'Low';

  @override
  String get priorityMedium => 'Medium';

  @override
  String get priorityHigh => 'High';

  @override
  String errorLoadingClaims(Object error) {
    return 'Error loading claims: $error';
  }

  @override
  String errorCreatingClaim(Object error) {
    return 'Error creating claim: $error';
  }

  @override
  String get errorUpdatingClient => 'Error updating client';

  @override
  String get branchManagementTitle => 'Branch Management';

  @override
  String get personnelManagementTitle => 'Personnel Management';

  @override
  String get errorNoCompanyContext => 'Error: No company found in context';

  @override
  String get noBranchesRegistered => 'No branches registered';

  @override
  String get noEmployeesRegistered => 'No employeesRegistered';

  @override
  String get clientFormTitleNew => 'New Client';

  @override
  String get clientFormTitleEdit => 'Edit Client';

  @override
  String get labelBranch => 'Branch';

  @override
  String get labelHeadquarters => 'Headquarters / Global';

  @override
  String get typePerson => 'Person';

  @override
  String get typeCompany => 'Company';

  @override
  String get labelBusinessName => 'Business Name *';

  @override
  String get labelTaxId => 'Tax ID *';

  @override
  String get labelContactName => 'Contact Name *';

  @override
  String get labelContactLastName => 'Contact Last Name';

  @override
  String get labelName => 'Name *';

  @override
  String get labelLastName => 'Last Name';

  @override
  String get labelIdDocument => 'ID Document';

  @override
  String get labelEmail => 'Email';

  @override
  String get labelPhone => 'Phone';

  @override
  String get labelAddress => 'Address';

  @override
  String get labelNotes => 'Notes';

  @override
  String get btnCancel => 'Cancel';

  @override
  String get btnSave => 'Save';

  @override
  String get validationRequired => 'Required';

  @override
  String get marketplaceTitle => 'Module Marketplace';

  @override
  String errorUpdatingStatus(Object error) {
    return 'Error updating status: $error';
  }

  @override
  String get viewFile => 'View File';

  @override
  String get permissionsLabel => 'Permissions:';

  @override
  String get statusPending => 'Pending';

  @override
  String get statusInProgress => 'In Progress';

  @override
  String get statusResolved => 'Resolved';

  @override
  String get statusClosed => 'Closed';

  @override
  String priorityDisplay(Object priority) {
    return 'Priority: $priority';
  }

  @override
  String get serverError => 'Server error. Please try again later.';

  @override
  String get authError => 'Authentication error.';

  @override
  String get networkError => 'Connection error. Check your internet.';

  @override
  String get validationError => 'Validation error. Check your data.';

  @override
  String get unknownError => 'An unexpected error occurred.';

  @override
  String get superAdminDashboardTitle => 'Super Admin Dashboard';

  @override
  String get companiesSection => 'Companies';

  @override
  String get pendingInvitationsSection => 'Pending Invitations';

  @override
  String get noPendingInvitations => 'No pending invitations';

  @override
  String errorLoadingCompanies(Object error) {
    return 'Error loading companies: $error';
  }

  @override
  String get codeLabel => 'Code';

  @override
  String get createdLabel => 'Created';

  @override
  String get manageModulesTooltip => 'Manage Modules';

  @override
  String get manageCompanyTooltip => 'Manage Company';

  @override
  String get drawerHome => 'Home';

  @override
  String get drawerAdmin => 'Admin / Management';

  @override
  String get drawerLogout => 'Logout';

  @override
  String get drawerLanguage => 'Language / Idioma';

  @override
  String get loginLabel => 'Username or Email';

  @override
  String get usernameLabel => 'Username';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get profileUpdated => 'Profile updated';

  @override
  String get usernameFieldLabel => 'Username';

  @override
  String get clients => 'Clients';

  @override
  String get userNotFound => 'User not found';

  @override
  String get userFetchError => 'Could not fetch user.';

  @override
  String get loginSuccess => 'Login successful!';

  @override
  String get loginError => 'Incorrect credentials or unknown error.';

  @override
  String get registerSuccess =>
      'Registration successful! Check your email to confirm.';

  @override
  String get registerError => 'Could not register. Check data or email.';

  @override
  String get recoveryEmailInvalid => 'Enter a valid email to recover password.';

  @override
  String get recoveryEmailSent => 'Recovery email sent!';

  @override
  String get badCredentials => 'Incorrect email or password.';

  @override
  String get claimsManagementTitle => 'Claims Management';

  @override
  String get searchClaimsPlaceholder => 'Search (ID, Title, Desc...)';

  @override
  String get allStatuses => 'All Statuses';

  @override
  String get allBranches => 'All Branches';

  @override
  String get itemsPerPage => 'Items per page:';

  @override
  String get crmConfig => 'CRM Configuration';

  @override
  String get noClientAssigned => 'No Client';

  @override
  String get loading => 'Loading...';

  @override
  String get noClaimsFound => 'No claims found';

  @override
  String get importClients => 'Import Clients';

  @override
  String get pickFileCSV => 'Pick File (CSV)';

  @override
  String get preview => 'Preview';

  @override
  String get importBtn => 'Import';

  @override
  String importSuccess(Object count) {
    return 'Import successful: $count clients';
  }

  @override
  String importError(Object error) {
    return 'Error importing: $error';
  }

  @override
  String rowsFound(Object count) {
    return '$count rows found';
  }

  @override
  String get noClientsToExport => 'No clients to export.';

  @override
  String exportSuccess(String path) {
    return 'Successfully exported to: $path';
  }

  @override
  String exportError(String error) {
    return 'Export error: $error';
  }

  @override
  String get companyCreatedSuccess => 'Company created successfully';

  @override
  String get companyCodeExists => 'Company code already exists.';

  @override
  String companyCreationError(String error) {
    return 'Error creating company: $error';
  }

  @override
  String get invitationDeleteSuccess => 'Invitation deleted successfully';

  @override
  String invitationDeleteError(String error) {
    return 'Error deleting invitation: $error';
  }

  @override
  String clientUpdateError(String error) {
    return 'Error updating data: $error';
  }

  @override
  String clientDeleteError(String error) {
    return 'Error deleting: $error';
  }

  @override
  String get claimDeleteSuccess => 'Claim deleted';

  @override
  String configurationError(String error) {
    return 'Configuration error: $error';
  }

  @override
  String clientImportError(String error) {
    return 'Import error: $error';
  }

  @override
  String get brandingCustomization => 'Brand Customization';

  @override
  String get brandingLoading => 'Loading...';

  @override
  String brandingError(String error) {
    return 'Error: $error';
  }

  @override
  String get brandingNotFound => 'Branding configuration not found';

  @override
  String get brandingTabLogos => 'Logos';

  @override
  String get brandingTabColorsBase => 'Base Colors';

  @override
  String get brandingTabColorsAdditional => 'Additional Colors';

  @override
  String get brandingTabTypography => 'Typography';

  @override
  String get brandingTabAdvanced => 'Advanced';

  @override
  String get brandingLogosTitle => 'Company Logos';

  @override
  String get brandingLogosSubtitle =>
      'Upload your company logos to customize the app';

  @override
  String get brandingLogoPrimary => 'Primary Logo';

  @override
  String get brandingLogoPrimarySubtitle => 'Shown in light theme';

  @override
  String get brandingLogoLight => 'Light Logo';

  @override
  String get brandingLogoLightSubtitle => 'Shown in dark mode';

  @override
  String get brandingColorsBaseTitle => 'Base Colors';

  @override
  String get brandingColorsBaseSubtitle => 'Define your brand\'s main colors';

  @override
  String get brandingColorPrimary => 'Primary Color';

  @override
  String get brandingColorSecondary => 'Secondary Color';

  @override
  String get brandingColorAccent => 'Accent Color';

  @override
  String get brandingDarkMode => 'Dark Mode';

  @override
  String get brandingColorPrimaryDark => 'Primary (Dark)';

  @override
  String get brandingColorSecondaryDark => 'Secondary (Dark)';

  @override
  String get brandingColorsAdditionalTitle => 'Additional Colors';

  @override
  String get brandingColorsAdditionalSubtitle =>
      'Customize background, text and state colors';

  @override
  String get brandingColorsGeneral => 'General Colors';

  @override
  String get brandingColorsStates => 'State Colors';

  @override
  String get brandingColorBackground => 'Background';

  @override
  String get brandingColorText => 'Text';

  @override
  String get brandingColorError => 'Error';

  @override
  String get brandingColorSuccess => 'Success';

  @override
  String get brandingColorWarning => 'Warning';

  @override
  String get brandingColorInfo => 'Information';

  @override
  String get brandingColorBackgroundDark => 'Background (Dark)';

  @override
  String get brandingColorTextDark => 'Text (Dark)';

  @override
  String get brandingColorErrorDark => 'Error (Dark)';

  @override
  String get brandingColorSuccessDark => 'Success (Dark)';

  @override
  String get brandingColorWarningDark => 'Warning (Dark)';

  @override
  String get brandingColorInfoDark => 'Information (Dark)';

  @override
  String get brandingTypographyTitle => 'Typography';

  @override
  String get brandingTypographySubtitle => 'Select fonts and text sizes';

  @override
  String get brandingFonts => 'Fonts';

  @override
  String get brandingFontPrimary => 'Primary Font';

  @override
  String get brandingFontSecondary => 'Secondary Font (Headers)';

  @override
  String get brandingSizes => 'Sizes';

  @override
  String brandingTextSizeBase(int size) {
    return 'Base Text Size: ${size}px';
  }

  @override
  String brandingTextSizeHeader(int size) {
    return 'Header Size: ${size}px';
  }

  @override
  String brandingTextSizeExample(int size) {
    return 'Example text with ${size}px size';
  }

  @override
  String get brandingHeaderExample => 'Example Title';

  @override
  String get brandingAdvancedTitle => 'Advanced Options';

  @override
  String get brandingAdvancedSubtitle =>
      'Predefined presets and advanced options';

  @override
  String get brandingPresets => 'Theme Presets';

  @override
  String get brandingPresetsSubtitle =>
      'Apply a predefined preset to quickly configure colors';

  @override
  String get brandingPresetNone => 'None';

  @override
  String get brandingPresetSelect => 'Select Preset';

  @override
  String get brandingResetDefaults => 'Reset to Defaults';

  @override
  String get brandingInfo => 'Information';

  @override
  String brandingLastUpdated(String date) {
    return 'Last updated: $date';
  }

  @override
  String brandingCreated(String date) {
    return 'Created: $date';
  }

  @override
  String brandingPresetApplied(String name) {
    return 'Preset \"$name\" applied';
  }

  @override
  String get brandingResetDialogTitle => 'Reset Defaults';

  @override
  String get brandingResetDialogMessage =>
      'Are you sure you want to reset all values to defaults?';

  @override
  String get brandingResetDialogConfirm => 'Reset';

  @override
  String get brandingSelectColor => 'Select Color';

  @override
  String get brandingSelectColorButton => 'Select';

  @override
  String get brandingSaveChanges => 'Save Changes';

  @override
  String get brandingSaveSuccess => 'Branding updated successfully';

  @override
  String brandingSaveError(String error) {
    return 'Error saving: $error';
  }

  @override
  String get logoDeleteSuccess => 'Logo deleted successfully';
}
