import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:chatbot_app/core/theme/app_theme.dart';
import 'package:chatbot_app/features/auth/cubit/auth_cubit.dart';
import 'package:chatbot_app/features/auth/cubit/auth_state.dart';
import 'package:chatbot_app/core/utils/sanitizer.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _idCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscurePassword = true;

  late AnimationController _entranceCtrl;
  late AnimationController _glowCtrl;

  @override
  void initState() {
    super.initState();
    _entranceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..forward();

    _glowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _idCtrl.dispose();
    _passwordCtrl.dispose();
    _entranceCtrl.dispose();
    _glowCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      FocusScope.of(context).unfocus();
      context.read<AuthCubit>().login(
            studentId: InputSanitizer.sanitizeId(_idCtrl.text),
            password: _passwordCtrl.text, // Passwords should not be altered
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (ctx, state) {
          if (state is AuthAuthenticated) {
            Navigator.of(ctx).pushReplacementNamed('/home');
          }
        },
        builder: (ctx, state) {
          final isLoading = state is AuthLoading;
          final errorMsg = state is AuthError ? state.message : null;

          return Stack(
            children: [
              // ── Ambient green glow ────────────────────────────────────
              AnimatedBuilder(
                animation: _glowCtrl,
                builder: (_, __) => Positioned(
                  top: -100,
                  right: -80,
                  child: Container(
                    width: 350,
                    height: 350,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.guGreen
                              .withValues(alpha: 0.03 + _glowCtrl.value * 0.02),
                          blurRadius: 140 + _glowCtrl.value * 40,
                          spreadRadius: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ── Main content ──────────────────────────────────────────
              SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Back button
                      FadeTransition(
                        opacity: CurvedAnimation(
                          parent: _entranceCtrl,
                          curve:
                              const Interval(0.0, 0.3, curve: Curves.easeOut),
                        ),
                        child: GestureDetector(
                          onTap: () => Navigator.of(context).maybePop(),
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: AppColors.borderMedium,
                                width: 1,
                              ),
                            ),
                            child: const Icon(
                              Icons.arrow_back_rounded,
                              color: AppColors.guNavy,
                              size: 20,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(
                          height: MediaQuery.sizeOf(context).height * 0.05),

                      // ── Header ────────────────────────────────────────
                      FadeTransition(
                        opacity: CurvedAnimation(
                          parent: _entranceCtrl,
                          curve:
                              const Interval(0.1, 0.5, curve: Curves.easeOut),
                        ),
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, 0.1),
                            end: Offset.zero,
                          ).animate(CurvedAnimation(
                            parent: _entranceCtrl,
                            curve: const Interval(0.1, 0.5,
                                curve: Curves.easeOutCubic),
                          )),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: Image.asset(
                                    'assets/images/gu_logo.png',
                                    height: 36,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 32),
                              Center(
                                child: Text(
                                  'Welcome back.',
                                  style: GoogleFonts.dmSans(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.textPrimary,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Center(
                                child: Text(
                                  'Sign in with your university ID and password.',
                                  style: GoogleFonts.dmSans(
                                    fontSize: 15,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 44),

                      // ── Float Card Container ──────────────────────────
                      Container(
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.35),
                              blurRadius: 80,
                              offset: const Offset(0, 32),
                            ),
                          ],
                        ),
                        child:

                            // ── Form ──────────────────────────────────────────
                            FadeTransition(
                          opacity: CurvedAnimation(
                            parent: _entranceCtrl,
                            curve:
                                const Interval(0.3, 0.7, curve: Curves.easeOut),
                          ),
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0, 0.08),
                              end: Offset.zero,
                            ).animate(CurvedAnimation(
                              parent: _entranceCtrl,
                              curve: const Interval(0.3, 0.7,
                                  curve: Curves.easeOutCubic),
                            )),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Student ID field
                                  const _FieldLabel(text: 'Student ID'),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    controller: _idCtrl,
                                    keyboardType: TextInputType.number,
                                    textInputAction: TextInputAction.next,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(12),
                                    ],
                                    style: GoogleFonts.dmSans(
                                      color: AppColors.textPrimary,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 1.5,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: '221101678',
                                      prefixIcon: Container(
                                        padding: const EdgeInsets.only(
                                            left: 16, right: 12),
                                        child: const Icon(
                                          Icons.badge_outlined,
                                          size: 18,
                                        ),
                                      ),
                                      prefixIconConstraints:
                                          const BoxConstraints(minWidth: 0),
                                    ),
                                    validator: (v) {
                                      if (v == null || v.isEmpty) {
                                        return 'Student ID is required';
                                      }
                                      if (v.length < 6) {
                                        return 'Enter a valid student ID';
                                      }
                                      return null;
                                    },
                                  ),

                                  const SizedBox(height: 22),

                                  // Password field
                                  const _FieldLabel(text: 'Password'),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    controller: _passwordCtrl,
                                    obscureText: _obscurePassword,
                                    textInputAction: TextInputAction.done,
                                    onFieldSubmitted: (_) => _submit(),
                                    style: GoogleFonts.dmSans(
                                      color: AppColors.textPrimary,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: '••••••••',
                                      prefixIcon: Container(
                                        padding: const EdgeInsets.only(
                                            left: 16, right: 12),
                                        child: const Icon(
                                          Icons.lock_outline_rounded,
                                          size: 18,
                                        ),
                                      ),
                                      prefixIconConstraints:
                                          const BoxConstraints(minWidth: 0),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _obscurePassword
                                              ? Icons.visibility_off_outlined
                                              : Icons.visibility_outlined,
                                          size: 18,
                                          color: AppColors.textMuted,
                                        ),
                                        onPressed: () => setState(() =>
                                            _obscurePassword =
                                                !_obscurePassword),
                                      ),
                                    ),
                                    validator: (v) {
                                      if (v == null || v.isEmpty) {
                                        return 'Password is required';
                                      }
                                      return null;
                                    },
                                  ),

                                  // Error banner
                                  if (errorMsg != null) ...[
                                    const SizedBox(height: 16),
                                    Container(
                                      padding: const EdgeInsets.all(14),
                                      decoration: BoxDecoration(
                                        color: AppColors.error
                                            .withValues(alpha: 0.08),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: AppColors.error
                                              .withValues(alpha: 0.2),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(
                                              Icons.error_outline_rounded,
                                              size: 16,
                                              color: AppColors.error),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Text(
                                              errorMsg,
                                              style: GoogleFonts.dmSans(
                                                color: AppColors.error,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],

                                  const SizedBox(height: 32),

                                  // Sign in button — green
                                  Container(
                                    width: double.infinity,
                                    height: 56,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(14),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.guGreen
                                              .withValues(alpha: 0.2),
                                          blurRadius: 16,
                                          offset: const Offset(0, 6),
                                        ),
                                      ],
                                    ),
                                    child: ElevatedButton(
                                      onPressed: isLoading ? null : _submit,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.guGreen,
                                        foregroundColor: Colors.white,
                                        disabledBackgroundColor: AppColors
                                            .guGreen
                                            .withValues(alpha: 0.5),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(14),
                                        ),
                                        elevation: 0,
                                      ),
                                      child: isLoading
                                          ? const SizedBox(
                                              width: 22,
                                              height: 22,
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                                strokeWidth: 2.5,
                                              ),
                                            )
                                          : Text(
                                              'Sign In to Portal',
                                              style: GoogleFonts.dmSans(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700,
                                                letterSpacing: 0.3,
                                              ),
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ), // End of Float Card Container

                      const SizedBox(height: 36),

                      // ── Demo hint ─────────────────────────────────────
                      FadeTransition(
                        opacity: CurvedAnimation(
                          parent: _entranceCtrl,
                          curve:
                              const Interval(0.6, 1.0, curve: Curves.easeOut),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceSubtle,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.borderSubtle,
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.info_outline_rounded,
                                  size: 16, color: AppColors.guNavy),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text.rich(
                                  TextSpan(
                                    style: GoogleFonts.dmSans(
                                      fontSize: 12,
                                      color: AppColors.textSecondary,
                                    ),
                                    children: const [
                                      TextSpan(text: 'Use the '),
                                      TextSpan(
                                        text: 'ID number on your ID card',
                                        style: TextStyle(
                                          color: AppColors.guNavy,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                      TextSpan(
                                          text:
                                              ' with the password sent to you'),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Footer
                      FadeTransition(
                        opacity: CurvedAnimation(
                          parent: _entranceCtrl,
                          curve:
                              const Interval(0.7, 1.0, curve: Curves.easeOut),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: const BoxDecoration(
                                    color: AppColors.guGreen,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Secured & encrypted connection',
                                  style: GoogleFonts.dmSans(
                                    fontSize: 12,
                                    color: AppColors.textMuted,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'support@gu.edu.eg',
                              style: GoogleFonts.dmSans(
                                fontSize: 12,
                                color: AppColors.textGhost,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ── Field label ──────────────────────────────────────────────────────────────
class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: GoogleFonts.dmSans(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: AppColors.textSecondary,
        letterSpacing: 1.5,
      ),
    );
  }
}
