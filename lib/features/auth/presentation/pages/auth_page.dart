import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/router/app_route_enum.dart';
import '../../../../core/styles/app_text_style.dart';
import '../../../../core/styles/brand_colors.dart';
import '../../../../core/styles/game_colors.dart';
import '../../../../core/styles/game_theme.dart';
import '../../../../core/translations/l10n.dart';
import '../../../../core/widgets/app_logo.dart';
import '../../../match/presentation/widgets/game_kit.dart';
import '../bloc/auth_bloc.dart';

/// Sign in or create an account (email + password). The competition needs
/// one; reading the Quran does not. On success it continues to the match
/// screen when [continueToMatch], else it pops.
class AuthPage extends StatefulWidget {
  final bool continueToMatch;

  const AuthPage({super.key, this.continueToMatch = true});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _register = false;
  bool _showPassword = false;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  bool get _valid =>
      _email.text.trim().isNotEmpty &&
      _password.text.isNotEmpty &&
      (!_register || _name.text.trim().isNotEmpty);

  void _submit() {
    if (!_valid) return;
    FocusScope.of(context).unfocus();
    final bloc = context.read<AuthBloc>();
    bloc.add(
      _register
          ? AuthRegisterRequested(
              email: _email.text.trim(),
              password: _password.text,
              name: _name.text.trim(),
            )
          : AuthLoginRequested(
              email: _email.text.trim(),
              password: _password.text,
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Theme(
      data: gameTheme,
      child: BlocConsumer<AuthBloc, AuthState>(
        listenWhen: (a, b) => !a.signedIn && b.signedIn,
        listener: (context, state) {
          if (widget.continueToMatch) {
            Navigator.pushReplacementNamed(context, AppRouteEnum.match.name);
          } else {
            Navigator.pop(context, true);
          }
        },
        builder: (context, state) => GameStage(
          child: Scaffold(
            appBar: AppBar(
              forceMaterialTransparency: true,
              title: Text(
                _register ? s.auth_register_title : s.auth_login_title,
              ),
            ),
            body: ListView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 32.h),
              children: [
                Center(
                  child: Container(
                    padding: EdgeInsets.all(14.r),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: GameColors.panel,
                      boxShadow: [
                        BoxShadow(
                          color: GameColors.whatDoYouKnow.withValues(
                            alpha: 0.5,
                          ),
                          blurRadius: 40,
                        ),
                      ],
                    ),
                    child: AppLogo(size: 72.r),
                  ),
                ),
                SizedBox(height: 14.h),
                Text(
                  s.auth_gate_title,
                  textAlign: TextAlign.center,
                  style: AppTextStyle.xxLarge.copyWith(
                    color: GameColors.text,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  s.auth_gate_subtitle,
                  textAlign: TextAlign.center,
                  style: AppTextStyle.small.copyWith(
                    color: GameColors.textMuted,
                    height: 1.6,
                  ),
                ),
                SizedBox(height: 22.h),
                GamePanel(
                  child: AutofillGroup(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _ModeSwitch(
                          register: _register,
                          onChanged: (v) => setState(() => _register = v),
                        ),
                        SizedBox(height: 16.h),
                        AnimatedSize(
                          duration: const Duration(milliseconds: 200),
                          child: _register
                              ? Padding(
                                  padding: EdgeInsets.only(bottom: 12.h),
                                  child: TextField(
                                    controller: _name,
                                    onChanged: (_) => setState(() {}),
                                    textInputAction: TextInputAction.next,
                                    autofillHints: const [
                                      AutofillHints.nickname,
                                    ],
                                    style: AppTextStyle.medium.copyWith(
                                      color: GameColors.text,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: s.auth_name,
                                      prefixIcon: const Icon(
                                        Icons.badge_outlined,
                                      ),
                                    ),
                                  ),
                                )
                              : const SizedBox(width: double.infinity),
                        ),
                        TextField(
                          controller: _email,
                          onChanged: (_) => setState(() {}),
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          autocorrect: false,
                          textDirection: TextDirection.ltr,
                          autofillHints: const [AutofillHints.email],
                          style: AppTextStyle.medium.copyWith(
                            color: GameColors.text,
                          ),
                          decoration: InputDecoration(
                            hintText: s.auth_email,
                            prefixIcon: const Icon(
                              Icons.alternate_email_rounded,
                            ),
                          ),
                        ),
                        SizedBox(height: 12.h),
                        TextField(
                          controller: _password,
                          onChanged: (_) => setState(() {}),
                          obscureText: !_showPassword,
                          textInputAction: TextInputAction.go,
                          textDirection: TextDirection.ltr,
                          onSubmitted: (_) => _submit(),
                          autofillHints: [
                            _register
                                ? AutofillHints.newPassword
                                : AutofillHints.password,
                          ],
                          style: AppTextStyle.medium.copyWith(
                            color: GameColors.text,
                          ),
                          decoration: InputDecoration(
                            hintText: s.auth_password,
                            prefixIcon: const Icon(Icons.lock_outline_rounded),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _showPassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                              ),
                              onPressed: () => setState(
                                () => _showPassword = !_showPassword,
                              ),
                            ),
                          ),
                        ),
                        if (state.error case final error?) ...[
                          SizedBox(height: 12.h),
                          Row(
                            children: [
                              Icon(
                                Icons.error_outline_rounded,
                                color: GameColors.wrong,
                                size: 18.r,
                              ),
                              SizedBox(width: 6.w),
                              Expanded(
                                child: Text(
                                  authErrorText(s, error),
                                  style: AppTextStyle.small.copyWith(
                                    color: Brand.wrong,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                        SizedBox(height: 18.h),
                        GameButton(
                          label: _register ? s.auth_register : s.auth_login,
                          icon: _register
                              ? Icons.person_add_alt_1_rounded
                              : Icons.login_rounded,
                          busy: state.busy,
                          onPressed: _valid ? _submit : null,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                Center(
                  child: TextButton(
                    onPressed: () => setState(() => _register = !_register),
                    child: Text(
                      _register ? s.auth_to_login : s.auth_to_register,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Sign in / New account as a two-part switch.
class _ModeSwitch extends StatelessWidget {
  final bool register;
  final ValueChanged<bool> onChanged;

  const _ModeSwitch({required this.register, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    Widget part(String label, bool selected, bool value) => Expanded(
      child: GestureDetector(
        onTap: () => onChanged(value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: EdgeInsets.symmetric(vertical: 10.h),
          decoration: BoxDecoration(
            gradient: selected ? GameColors.promo : null,
            borderRadius: BorderRadius.circular(12.r),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: AppTextStyle.medium.copyWith(
              color: selected ? Colors.white : GameColors.textMuted,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
    return Container(
      padding: EdgeInsets.all(4.r),
      decoration: BoxDecoration(
        color: GameColors.panel,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          part(s.auth_login_title, !register, false),
          part(s.auth_register_title, register, true),
        ],
      ),
    );
  }
}

/// The message for an account error code.
String authErrorText(S s, String code) => switch (code) {
  'invalid_email' => s.auth_err_invalid_email,
  'weak_password' => s.auth_err_weak_password,
  'name_required' => s.auth_err_name,
  'email_taken' => s.auth_err_email_taken,
  'invalid_credentials' => s.auth_err_invalid_credentials,
  'unreachable' => s.match_err_unreachable,
  _ => s.auth_err_generic,
};
