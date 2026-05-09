import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:chatbot_app/core/theme/app_theme.dart';
import 'package:chatbot_app/features/auth/presentation/screens/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseCtrl;
  late AnimationController _fadeCtrl;
  late AnimationController _orbCtrl;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _heroSlide;
  late Animation<double> _heroScale;

  @override
  void initState() {
    super.initState();

    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _orbCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _fadeAnim = CurvedAnimation(
      parent: _fadeCtrl,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    );
    _heroSlide = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _fadeCtrl,
      curve: const Interval(0.1, 0.7, curve: Curves.easeOutCubic),
    ));
    _heroScale = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(
        parent: _fadeCtrl,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack),
      ),
    );

    _fadeCtrl.forward();
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    _fadeCtrl.dispose();
    _orbCtrl.dispose();
    super.dispose();
  }

  void _navigateToLogin() {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 700),
        reverseTransitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (_, __, ___) => const LoginScreen(),
        transitionsBuilder: (_, anim, __, child) {
          return FadeTransition(
            opacity: CurvedAnimation(parent: anim, curve: Curves.easeInOut),
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.05),
                end: Offset.zero,
              ).animate(
                  CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
              child: child,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: Stack(
        children: [
          // ── Ambient orbs ───────────────────────────────────────────────
          AnimatedBuilder(
            animation: _orbCtrl,
            builder: (_, __) => CustomPaint(
              size: size,
              painter: _OrbPainter(
                progress: _orbCtrl.value,
                pulseValue: _pulseCtrl.value,
              ),
            ),
          ),

          // ── Radial glow pulse ──────────────────────────────────────────
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _pulseCtrl,
              builder: (_, __) => Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: const Alignment(0, -0.3),
                    radius: 1.0 + _pulseCtrl.value * 0.2,
                    colors: [
                      AppColors.guGreen
                          .withValues(alpha: 0.03 + _pulseCtrl.value * 0.02),
                      Colors.transparent,
                      AppColors.guGold.withValues(alpha: 0.01),
                    ],
                    stops: const [0.0, 0.45, 1.0],
                  ),
                ),
              ),
            ),
          ),

          // ── Main content ───────────────────────────────────────────────
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                children: [
                  const Spacer(flex: 2),

                  // Logo + name
                  FadeTransition(
                    opacity: _fadeAnim,
                    child: SlideTransition(
                      position: _heroSlide,
                      child: ScaleTransition(
                        scale: _heroScale,
                        child: Column(
                          children: [
                            // Glowing logo
                            AnimatedBuilder(
                              animation: _pulseCtrl,
                              builder: (_, child) => Container(
                                width: 110,
                                height: 110,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.guGreen.withValues(
                                          alpha:
                                              0.08 + _pulseCtrl.value * 0.05),
                                      blurRadius: 50 + _pulseCtrl.value * 25,
                                      spreadRadius: 4,
                                    ),
                                    BoxShadow(
                                      color: AppColors.guGold.withValues(
                                          alpha:
                                              0.03 + _pulseCtrl.value * 0.02),
                                      blurRadius: 30,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.surface,
                                    borderRadius: BorderRadius.circular(30),
                                    border: Border.all(
                                      color: AppColors.guGreen
                                          .withValues(alpha: 0.15),
                                      width: 1.5,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black
                                            .withValues(alpha: 0.04),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  padding: const EdgeInsets.all(12),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(22),
                                    child: Image.asset(
                                      'assets/images/gu_logo.png',
                                      fit: BoxFit.contain,
                                      errorBuilder: (_, __, ___) => const Icon(
                                        Icons.school_rounded,
                                        size: 48,
                                        color: AppColors.guNavy,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 36),

                            // University name — editorial
                            Text(
                              'GALALA',
                              style: GoogleFonts.playfairDisplay(
                                fontSize: 54,
                                fontWeight: FontWeight.w800,
                                color: AppColors.guNavy,
                                letterSpacing: 8,
                                height: 1.0,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'UNIVERSITY',
                              style: GoogleFonts.dmSans(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: AppColors.guGold,
                                letterSpacing: 12,
                                height: 1.0,
                              ),
                            ),

                            const SizedBox(height: 30),

                            // Decorative divider with GU diamond
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _GradientLine(
                                  width: 50,
                                  colors: [
                                    AppColors.guNavy.withValues(alpha: 0.0),
                                    AppColors.guNavy.withValues(alpha: 0.15),
                                  ],
                                ),
                                const SizedBox(width: 14),
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    gradient: AppColors.greenGradient,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.guGreen
                                            .withValues(alpha: 0.3),
                                        blurRadius: 8,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 14),
                                _GradientLine(
                                  width: 50,
                                  colors: [
                                    AppColors.guNavy.withValues(alpha: 0.15),
                                    AppColors.guNavy.withValues(alpha: 0.0),
                                  ],
                                ),
                              ],
                            ),

                            const SizedBox(height: 30),

                            Text(
                              'Student Portal',
                              style: GoogleFonts.playfairDisplay(
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textSecondary,
                                fontStyle: FontStyle.italic,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const Spacer(flex: 2),

                  // ── Feature hints ─────────────────────────────────────────
                  FadeTransition(
                    opacity: CurvedAnimation(
                      parent: _fadeCtrl,
                      curve: const Interval(0.4, 0.9, curve: Curves.easeOut),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _FeatureChip(
                          icon: Icons.dashboard_rounded,
                          label: 'Dashboard',
                          color: AppColors.guNavy,
                        ),
                        _FeatureChip(
                          icon: Icons.auto_awesome_rounded,
                          label: 'AI Assistant',
                          color: AppColors.guGold,
                        ),
                        _FeatureChip(
                          icon: Icons.directions_car_rounded,
                          label: 'Vehicle',
                          color: AppColors.guNavy,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // ── CTA Button ────────────────────────────────────────────
                  FadeTransition(
                    opacity: CurvedAnimation(
                      parent: _fadeCtrl,
                      curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
                    ),
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.3),
                        end: Offset.zero,
                      ).animate(CurvedAnimation(
                        parent: _fadeCtrl,
                        curve: const Interval(0.5, 1.0,
                            curve: Curves.easeOutCubic),
                      )),
                      child: Container(
                        width: double.infinity,
                        height: 58,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.guGreen.withValues(alpha: 0.25),
                              blurRadius: 20,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: _navigateToLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.guGreen,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Enter Portal',
                                style: GoogleFonts.dmSans(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Icon(Icons.arrow_forward_rounded, size: 20),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  FadeTransition(
                    opacity: CurvedAnimation(
                      parent: _fadeCtrl,
                      curve: const Interval(0.7, 1.0, curve: Curves.easeOut),
                    ),
                    child: Text(
                      'Secured access for registered students',
                      style: GoogleFonts.dmSans(
                        fontSize: 12,
                        color: AppColors.textMuted,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Feature chip ─────────────────────────────────────────────────────────────
class _FeatureChip extends StatelessWidget {
  const _FeatureChip({
    required this.icon,
    required this.label,
    required this.color,
  });
  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: color.withValues(alpha: 0.1),
              width: 1,
            ),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: GoogleFonts.dmSans(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }
}

// ── Gradient line widget ─────────────────────────────────────────────────────
class _GradientLine extends StatelessWidget {
  const _GradientLine({required this.width, required this.colors});
  final double width;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: colors),
      ),
    );
  }
}

// ── Ambient orb painter ──────────────────────────────────────────────────────
class _OrbPainter extends CustomPainter {
  final double progress;
  final double pulseValue;
  _OrbPainter({required this.progress, required this.pulseValue});

  @override
  void paint(Canvas canvas, Size size) {
    // Green orb — top right
    final greenOrb = Offset(
      size.width * 0.8 + math.sin(progress * 2 * math.pi) * 30,
      size.height * 0.15 + math.cos(progress * 2 * math.pi) * 20,
    );
    canvas.drawCircle(
      greenOrb,
      130 + pulseValue * 30,
      Paint()
        ..color = AppColors.guGreen.withValues(alpha: 0.03 + pulseValue * 0.01)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 80),
    );

    // Gold orb — bottom left
    final goldOrb = Offset(
      size.width * 0.15 + math.cos(progress * 2 * math.pi + 1) * 25,
      size.height * 0.8 + math.sin(progress * 2 * math.pi + 1) * 30,
    );
    canvas.drawCircle(
      goldOrb,
      100 + pulseValue * 20,
      Paint()
        ..color = AppColors.guGold.withValues(alpha: 0.03 + pulseValue * 0.015)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 70),
    );
  }

  @override
  bool shouldRepaint(covariant _OrbPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.pulseValue != pulseValue;
}
