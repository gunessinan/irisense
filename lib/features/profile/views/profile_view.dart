import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show TextInputFormatter, TextEditingValue, TextSelection;
import 'package:provider/provider.dart';
import 'package:irisense/core/constants/classic_theme.dart';
import 'package:irisense/core/models/user_model.dart';
import 'package:irisense/core/services/auth_service.dart';
import 'package:irisense/l10n/app_localizations.dart';
import '../view_models/profile_viewmodel.dart';

// ─── Telefon otomatik formatlayıcı: 0555 123 45 67 ──────────────────────────
class _PhoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final digits = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
    if (digits.length > 11) return oldValue;

    final buf = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      if (i == 4 || i == 7 || i == 9) buf.write(' ');
      buf.write(digits[i]);
    }

    final formatted = buf.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late ProfileViewModel _viewModel;

  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  /// Rol kodu: 'user' veya 'patient'
  String _selectedRole = 'user';
  bool _obscurePassword = true;

  // ── Düzenleme modu ────────────────────────────────────────────────────────
  bool _isEditing = false;
  final _editFormKey = GlobalKey<FormState>();
  final _editFirstNameController = TextEditingController();
  final _editLastNameController = TextEditingController();
  final _editPhoneController = TextEditingController();
  final _editNewPasswordController = TextEditingController();
  bool _obscureNewPassword = true;

  @override
  void initState() {
    super.initState();
    final authService = Provider.of<AuthService>(context, listen: false);
    _viewModel = ProfileViewModel(authService: authService);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _editFirstNameController.dispose();
    _editLastNameController.dispose();
    _editPhoneController.dispose();
    _editNewPasswordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;
    final success = await _viewModel.login(
      _usernameController.text,
      _passwordController.text,
    );
    if (success && mounted) Navigator.of(context).pop();
  }

  void _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;
    final success = await _viewModel.register(
      _firstNameController.text,
      _lastNameController.text,
      _usernameController.text,
      _phoneController.text,
      _passwordController.text,
      _selectedRole,
    );
    if (success && mounted) Navigator.of(context).pop();
  }

  void _handleLogout() async => await _viewModel.logout();

  void _startEditing(UserModel user) {
    _editFirstNameController.text = user.firstName;
    _editLastNameController.text = user.lastName;
    _editPhoneController.text = user.phone;
    _editNewPasswordController.clear();
    setState(() => _isEditing = true);
  }

  void _handleUpdate() async {
    if (!_editFormKey.currentState!.validate()) return;
    final newPw = _editNewPasswordController.text.trim();
    final success = await _viewModel.updateProfile(
      _editFirstNameController.text,
      _editLastNameController.text,
      _editPhoneController.text,
      newPw.isEmpty ? null : newPw,
    );
    if (success && mounted) setState(() => _isEditing = false);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Scaffold(
        backgroundColor: AppColors.darkBackground,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Consumer2<ProfileViewModel, AuthService>(
            builder: (context, vm, auth, _) {
              final l10n = AppLocalizations.of(context)!;
              final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
              return Column(
                children: [
                  _buildHeader(context, l10n),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // ── Sol panel ──────────────────────────────────────
                        _buildLeftPanel(auth, l10n),
                        VerticalDivider(
                          width: 1,
                          thickness: 1,
                          color: AppColors.accentGray.withValues(alpha: 0.2),
                        ),
                        // ── Sağ içerik ─────────────────────────────────────
                        Expanded(
                          child: SingleChildScrollView(
                            padding: EdgeInsets.fromLTRB(
                                32, 20, 32, keyboardHeight + 20),
                            child: auth.isLoggedIn
                                ? _buildProfileInfo(auth, l10n)
                                : _buildAuthForm(vm, auth, l10n),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  // ─── Sol panel ───────────────────────────────────────────────────────────────

  Widget _buildLeftPanel(AuthService auth, AppLocalizations l10n) {
    final isLoggedIn = auth.isLoggedIn && auth.currentUser != null;
    final user = auth.currentUser;
    final roleLabel = user?.role == 'patient'
        ? l10n.profileRolePatient
        : l10n.profileRoleUser;

    return Container(
      width: 200,
      color: AppColors.darkSurface,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.limeAccent.withValues(alpha: 0.15),
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.limeAccent, width: 2),
            ),
            child: Icon(Icons.person, color: AppColors.limeAccent, size: 36),
          ),
          const SizedBox(height: 16),
          if (isLoggedIn) ...[
            Text(
              user!.fullName,
              style: AppTextStyles.interBold18.copyWith(fontSize: 15),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.limeAccent.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: AppColors.limeAccent.withValues(alpha: 0.5)),
              ),
              child: Text(
                roleLabel,
                style: AppTextStyles.interMedium14
                    .copyWith(color: AppColors.limeAccent, fontSize: 12),
              ),
            ),
          ] else ...[
            Text(
              l10n.profileTitle,
              style: AppTextStyles.interBold18,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.profileGuestSubtitle,
              style: AppTextStyles.interMedium14
                  .copyWith(color: Colors.white54),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  // ─── Header ─────────────────────────────────────────────────────────────────

  Widget _buildHeader(BuildContext context, AppLocalizations l10n) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        border: Border(
          bottom:
              BorderSide(color: AppColors.accentGray.withValues(alpha: 0.3)),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.accentGray.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.arrow_back_ios_new,
                  color: Colors.white, size: 18),
            ),
          ),
          const SizedBox(width: 16),
          Text(l10n.profileTitle, style: AppTextStyles.interBold18),
        ],
      ),
    );
  }

  // ─── Profil Bilgileri (giriş yapılmış) ──────────────────────────────────────

  Widget _buildProfileInfo(AuthService auth, AppLocalizations l10n) {
    final user = auth.currentUser!;
    return _isEditing
        ? _buildEditForm(auth, l10n)
        : _buildInfoView(user, l10n);
  }

  Widget _buildInfoView(UserModel user, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _infoCard(Icons.person_outline, l10n.profileFullName, user.fullName),
        const SizedBox(height: 12),
        _infoCard(Icons.account_circle_outlined, l10n.profileUsername,
            user.username),
        if (user.phone.isNotEmpty) ...[
          const SizedBox(height: 12),
          _infoCard(Icons.phone_outlined, l10n.profilePhone, user.phone),
        ],
        const SizedBox(height: 12),
        _infoCard(
          Icons.calendar_today_outlined,
          l10n.profileRegDate,
          '${user.createdAt.day}.${user.createdAt.month}.${user.createdAt.year}',
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          height: 54,
          child: ElevatedButton.icon(
            onPressed: () => _startEditing(user),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.limeAccent.withValues(alpha: 0.15),
              foregroundColor: AppColors.limeAccent,
              side: BorderSide(color: AppColors.limeAccent.withValues(alpha: 0.5)),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              elevation: 0,
            ),
            icon: const Icon(Icons.edit_outlined, size: 20),
            label: Text(l10n.profileEdit,
                style: AppTextStyles.interBold18
                    .copyWith(color: AppColors.limeAccent, fontSize: 15)),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 54,
          child: ElevatedButton.icon(
            onPressed: _handleLogout,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.errorSurface,
              foregroundColor: AppColors.errorColor,
              side: BorderSide(color: AppColors.errorColor.withValues(alpha: 0.4)),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              elevation: 0,
            ),
            icon: const Icon(Icons.logout, size: 20),
            label: Text(l10n.profileLogout,
                style: AppTextStyles.interBold18
                    .copyWith(color: AppColors.errorColor)),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildEditForm(AuthService auth, AppLocalizations l10n) {
    return Form(
      key: _editFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 24),
          Text(l10n.profileEdit,
              style: AppTextStyles.interBold18.copyWith(fontSize: 20)),
          const SizedBox(height: 24),

          // İsim / Soyisim
          Row(
            children: [
              Expanded(
                child: _buildField(
                  controller: _editFirstNameController,
                  label: l10n.profileFirstName,
                  icon: Icons.badge_outlined,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty)
                      return l10n.profileFieldRequired(l10n.profileFirstName);
                    if (!_viewModel.isNameValid(v))
                      return l10n.profileFieldTooShort(l10n.profileFirstName);
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildField(
                  controller: _editLastNameController,
                  label: l10n.profileLastName,
                  icon: Icons.badge_outlined,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty)
                      return l10n.profileFieldRequired(l10n.profileLastName);
                    if (!_viewModel.isNameValid(v))
                      return l10n.profileFieldTooShort(l10n.profileLastName);
                    return null;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Opsiyonel telefon
          _buildField(
            controller: _editPhoneController,
            label: l10n.profilePhoneOptional,
            hint: l10n.profilePhoneHint,
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            inputFormatters: [_PhoneInputFormatter()],
            validator: (v) {
              if (!_viewModel.isPhoneValid(v)) return l10n.profilePhoneInvalid;
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Yeni şifre (opsiyonel)
          _buildField(
            controller: _editNewPasswordController,
            label: l10n.profileNewPassword,
            hint: l10n.profileNewPasswordHint,
            icon: Icons.lock_outline,
            obscureText: _obscureNewPassword,
            validator: (v) {
              if (v != null && v.isNotEmpty && !_viewModel.isPasswordValid(v))
                return l10n.profilePasswordTooShort;
              return null;
            },
            suffixIcon: GestureDetector(
              onTap: () =>
                  setState(() => _obscureNewPassword = !_obscureNewPassword),
              child: Icon(
                _obscureNewPassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: Colors.white54,
                size: 20,
              ),
            ),
          ),

          // Hata mesajı
          if (auth.error != null) ...[
            const SizedBox(height: 16),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.errorSurface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.errorColor.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.error_outline, color: AppColors.errorColor, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _viewModel.translateAuthError(auth.error, l10n) ?? '',
                      style: AppTextStyles.interMedium14
                          .copyWith(color: AppColors.errorColor, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 28),

          // Kaydet butonu
          SizedBox(
            height: 54,
            child: ElevatedButton(
              onPressed: auth.isLoading ? null : _handleUpdate,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.limeAccent,
                disabledBackgroundColor:
                    AppColors.limeAccent.withValues(alpha: 0.4),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                elevation: 0,
              ),
              child: auth.isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2.5),
                    )
                  : Text(l10n.profileSave,
                      style: AppTextStyles.interBold18
                          .copyWith(color: AppColors.darkBackground)),
            ),
          ),
          const SizedBox(height: 12),

          // İptal butonu
          SizedBox(
            height: 54,
            child: TextButton(
              onPressed: () => setState(() => _isEditing = false),
              style: TextButton.styleFrom(
                foregroundColor: Colors.white54,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
              ),
              child: Text(l10n.profileCancel,
                  style: AppTextStyles.interMedium14
                      .copyWith(color: Colors.white54)),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _infoCard(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.limeAccent, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: AppTextStyles.interMedium14
                        .copyWith(color: Colors.white54, fontSize: 12)),
                const SizedBox(height: 2),
                Text(value,
                    style: AppTextStyles.interMedium14,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Giriş / Kayıt Formu ────────────────────────────────────────────────────

  Widget _buildAuthForm(
      ProfileViewModel vm, AuthService auth, AppLocalizations l10n) {
    final isLogin = vm.mode == ProfileFormMode.login;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            isLogin ? l10n.profileLogin : l10n.profileCreateAccount,
            style: AppTextStyles.interBold18.copyWith(fontSize: 20),
          ),
          const SizedBox(height: 4),
          Text(
            isLogin
                ? l10n.profileLoginSubtitle
                : l10n.profileRegisterSubtitle,
            style:
                AppTextStyles.interMedium14.copyWith(color: Colors.white54),
          ),

          const SizedBox(height: 20),

          // ── KAYIT: İsim / Soyisim ──────────────────────────────────────────
          if (!isLogin) ...[
            Row(
              children: [
                Expanded(
                  child: _buildField(
                    controller: _firstNameController,
                    label: l10n.profileFirstName,
                    icon: Icons.badge_outlined,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty)
                        return l10n.profileFieldRequired(l10n.profileFirstName);
                      if (!vm.isNameValid(v))
                        return l10n.profileFieldTooShort(l10n.profileFirstName);
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildField(
                    controller: _lastNameController,
                    label: l10n.profileLastName,
                    icon: Icons.badge_outlined,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty)
                        return l10n.profileFieldRequired(l10n.profileLastName);
                      if (!vm.isNameValid(v))
                        return l10n.profileFieldTooShort(l10n.profileLastName);
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],

          // ── Kullanıcı adı ──────────────────────────────────────────────────
          _buildField(
            controller: _usernameController,
            label: l10n.profileUsername,
            hint: l10n.profileUsernameHint,
            icon: Icons.account_circle_outlined,
            keyboardType: TextInputType.text,
            validator: (v) {
              if (v == null || v.trim().isEmpty)
                return l10n.profileUsernameRequired;
              if (!vm.isUsernameFormatValid(v))
                return l10n.profileUsernameFormatInvalid;
              return null;
            },
          ),

          const SizedBox(height: 16),

          // ── KAYIT: Opsiyonel telefon ───────────────────────────────────────
          if (!isLogin) ...[
            _buildField(
              controller: _phoneController,
              label: l10n.profilePhoneOptional,
              hint: l10n.profilePhoneHint,
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              inputFormatters: [_PhoneInputFormatter()],
              validator: (v) {
                if (!vm.isPhoneValid(v)) return l10n.profilePhoneInvalid;
                return null;
              },
            ),
            const SizedBox(height: 16),
          ],

          // ── Şifre ──────────────────────────────────────────────────────────
          _buildField(
            controller: _passwordController,
            label: l10n.profilePassword,
            icon: Icons.lock_outline,
            obscureText: _obscurePassword,
            validator: (v) {
              if (v == null || v.isEmpty) return l10n.profilePasswordRequired;
              if (!vm.isPasswordValid(v)) return l10n.profilePasswordTooShort;
              return null;
            },
            suffixIcon: GestureDetector(
              onTap: () =>
                  setState(() => _obscurePassword = !_obscurePassword),
              child: Icon(
                _obscurePassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: Colors.white54,
                size: 20,
              ),
            ),
          ),

          // ── KAYIT: Rol seçimi ──────────────────────────────────────────────
          if (!isLogin) ...[
            const SizedBox(height: 24),
            Text(l10n.profileRoleQuestion,
                style: AppTextStyles.interMedium14
                    .copyWith(color: Colors.white70)),
            const SizedBox(height: 10),
            _buildRoleSelector(l10n),
          ],

          // ── Hata mesajı ────────────────────────────────────────────────────
          if (auth.error != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.errorSurface,
                borderRadius: BorderRadius.circular(12),
                border:
                    Border.all(color: AppColors.errorColor.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.error_outline,
                      color: AppColors.errorColor, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      vm.translateAuthError(auth.error, l10n) ?? '',
                      style: AppTextStyles.interMedium14.copyWith(
                          color: AppColors.errorColor, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 28),

          // ── Aksiyon butonu ─────────────────────────────────────────────────
          SizedBox(
            height: 54,
            child: ElevatedButton(
              onPressed: auth.isLoading
                  ? null
                  : (isLogin ? _handleLogin : _handleRegister),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.limeAccent,
                disabledBackgroundColor:
                    AppColors.limeAccent.withValues(alpha: 0.4),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                elevation: 0,
              ),
              child: auth.isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2.5),
                    )
                  : Text(
                      isLogin ? l10n.profileLogin : l10n.profileSignUp,
                      style: AppTextStyles.interBold18
                          .copyWith(color: AppColors.darkBackground),
                    ),
            ),
          ),

          const SizedBox(height: 20),

          // ── Mod geçiş linki ────────────────────────────────────────────────
          GestureDetector(
            onTap: () {
              _formKey.currentState?.reset();
              _firstNameController.clear();
              _lastNameController.clear();
              _usernameController.clear();
              _phoneController.clear();
              _passwordController.clear();
              vm.toggleMode();
            },
            child: Center(
              child: RichText(
                text: TextSpan(
                  style: AppTextStyles.interMedium14
                      .copyWith(color: Colors.white54),
                  children: [
                    TextSpan(
                      text: isLogin
                          ? l10n.profileNoAccount
                          : l10n.profileHaveAccount,
                    ),
                    TextSpan(
                      text:
                          isLogin ? l10n.profileSignUp : l10n.profileLogin,
                      style: AppTextStyles.interBold18.copyWith(
                          color: AppColors.limeAccent, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // ─── Rol seçici ─────────────────────────────────────────────────────────────

  Widget _buildRoleSelector(AppLocalizations l10n) {
    return Row(
      children: [
        _roleOption('user', l10n.profileRoleUser, Icons.person_outline),
        const SizedBox(width: 12),
        _roleOption('patient', l10n.profileRolePatient,
            Icons.accessibility_new_outlined),
      ],
    );
  }

  Widget _roleOption(String roleCode, String label, IconData icon) {
    final isSelected = _selectedRole == roleCode;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedRole = roleCode),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 64,
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.limeAccent.withValues(alpha: 0.15)
                : AppColors.darkSurface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected
                  ? AppColors.limeAccent
                  : AppColors.accentGray.withValues(alpha: 0.4),
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,
                  color:
                      isSelected ? AppColors.limeAccent : Colors.white54,
                  size: 22),
              const SizedBox(width: 8),
              Text(label,
                  style: AppTextStyles.interBold18.copyWith(
                    fontSize: 15,
                    color: isSelected
                        ? AppColors.limeAccent
                        : Colors.white70,
                  )),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Form alanı ─────────────────────────────────────────────────────────────

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    String? hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    String? Function(String?)? validator,
    Widget? suffixIcon,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      inputFormatters: inputFormatters,
      style: AppTextStyles.interMedium14,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        hintStyle:
            AppTextStyles.interMedium14.copyWith(color: Colors.white30),
        labelStyle:
            AppTextStyles.interMedium14.copyWith(color: Colors.white54),
        prefixIcon: Icon(icon, color: AppColors.limeAccent, size: 20),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: AppColors.darkSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
              color: AppColors.accentGray.withValues(alpha: 0.4)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide:
              BorderSide(color: AppColors.limeAccent, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide:
              BorderSide(color: AppColors.errorColor.withValues(alpha: 0.6)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppColors.errorColor),
        ),
        errorStyle: TextStyle(color: AppColors.errorColor, fontSize: 11),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }
}
