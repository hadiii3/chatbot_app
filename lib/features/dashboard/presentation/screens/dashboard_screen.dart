import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:chatbot_app/core/theme/app_theme.dart';
import 'package:chatbot_app/features/auth/cubit/auth_cubit.dart';
import 'package:chatbot_app/features/dashboard/cubit/dashboard_cubit.dart';
import 'package:chatbot_app/features/dashboard/cubit/dashboard_state.dart';
import 'package:chatbot_app/features/auth/data/models/student_model.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardCubit, DashboardState>(
      builder: (context, state) {
        if (state is DashboardLoading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.guGreen),
          );
        }
        if (state is DashboardError) {
          return Center(
            child: Text(
              state.message,
              style: GoogleFonts.dmSans(color: AppColors.textSecondary),
            ),
          );
        }
        final student = (state as DashboardLoaded).student;
        return _DashboardBody(student: student);
      },
    );
  }
}

class _DashboardBody extends StatefulWidget {
  const _DashboardBody({required this.student});
  final StudentModel student;

  @override
  State<_DashboardBody> createState() => _DashboardBodyState();
}

class _DashboardBodyState extends State<_DashboardBody>
    with SingleTickerProviderStateMixin {
  late AnimationController _entranceCtrl;

  @override
  void initState() {
    super.initState();
    _entranceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();
  }

  @override
  void dispose() {
    _entranceCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final student = widget.student;
    final now = DateTime.now();
    final greeting = _getGreeting(now.hour);
    final percent = student.progressPercent.clamp(0.0, 1.0);

    return CustomScrollView(
      slivers: [
        // ── Hero Header ──────────────────────────────────────────────────
        SliverToBoxAdapter(
          child: FadeTransition(
            opacity: CurvedAnimation(
              parent: _entranceCtrl,
              curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
            ),
            child: Container(
              decoration: const BoxDecoration(
                gradient: AppColors.heroGradient,
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.borderSubtle,
                    width: 1.0,
                  ),
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top row: GU pill + avatar
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: AppColors.guNavy.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: AppColors.guNavy.withValues(alpha: 0.1),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: Image.asset(
                                    'assets/images/gu_logo.png',
                                    width: 16,
                                    height: 16,
                                    fit: BoxFit.contain,
                                    errorBuilder: (_, __, ___) => const Icon(
                                      Icons.school_rounded,
                                      size: 14,
                                      color: AppColors.guNavy,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'GALALA',
                                  style: GoogleFonts.dmSans(
                                    color: AppColors.guNavy,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          // Avatar
                          GestureDetector(
                            onTap: () => _showLogoutSheet(context),
                            child: Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                gradient: AppColors.greenGradient,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.guGreen
                                        .withValues(alpha: 0.25),
                                    blurRadius: 16,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  student.firstName[0].toUpperCase(),
                                  style: GoogleFonts.playfairDisplay(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),

                      // Greeting
                      Text(
                        greeting,
                        style: GoogleFonts.dmSans(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${student.firstName} ${student.lastName}',
                        style: GoogleFonts.playfairDisplay(
                          color: AppColors.textPrimary,
                          fontSize: 34,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Badges
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          _Badge(
                            icon: Icons.school_rounded,
                            label: student.faculty,
                            color: AppColors.guNavy,
                            bgColor: AppColors.guNavy.withValues(alpha: 0.05),
                            borderColor:
                                AppColors.guNavy.withValues(alpha: 0.1),
                          ),
                          _Badge(
                            icon: Icons.tag_rounded,
                            label: student.studentIdNumber,
                            color: AppColors.guGold,
                            bgColor: AppColors.guGold.withValues(alpha: 0.1),
                            borderColor:
                                AppColors.guGold.withValues(alpha: 0.2),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 24)),

        // ── Progress Card ────────────────────────────────────────────────
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          sliver: SliverToBoxAdapter(
            child: FadeTransition(
              opacity: CurvedAnimation(
                parent: _entranceCtrl,
                curve: const Interval(0.15, 0.6, curve: Curves.easeOut),
              ),
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.05),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: _entranceCtrl,
                  curve: const Interval(0.15, 0.6, curve: Curves.easeOutCubic),
                )),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: AppColors.borderSubtle,
                      width: 1.0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: AppColors.guGreen.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.trending_up_rounded,
                                size: 16, color: AppColors.guGreen),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'GRADUATION PROGRESS',
                            style: GoogleFonts.dmSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textSecondary,
                              letterSpacing: 1.5,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '${(percent * 100).toInt()}%',
                            style: GoogleFonts.dmSans(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              color: AppColors.guGreen,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Progress bar
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Stack(
                          children: [
                            Container(
                              height: 10,
                              decoration: BoxDecoration(
                                color: AppColors.surfaceSubtle,
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            FractionallySizedBox(
                              widthFactor: percent,
                              child: Container(
                                height: 10,
                                decoration: BoxDecoration(
                                  gradient: AppColors.greenGradient,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        '${student.creditsCompleted} / ${student.creditsRequired} credits completed',
                        style: GoogleFonts.dmSans(
                          color: AppColors.textMuted,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 16)),

        // ── Stat Cards ───────────────────────────────────────────────────
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          sliver: SliverToBoxAdapter(
            child: FadeTransition(
              opacity: CurvedAnimation(
                parent: _entranceCtrl,
                curve: const Interval(0.25, 0.7, curve: Curves.easeOut),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      icon: Icons.star_rounded,
                      iconColor: AppColors.guGold,
                      label: 'GPA',
                      value: student.gpa.toStringAsFixed(2),
                      sub: 'out of 4.00',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _StatCard(
                      icon: Icons.check_circle_rounded,
                      iconColor: AppColors.guGreen,
                      label: 'Credits',
                      value: '${student.creditsCompleted}',
                      sub: 'completed',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 24)),

        // ── Academic Details ─────────────────────────────────────────────
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          sliver: SliverToBoxAdapter(
            child: FadeTransition(
              opacity: CurvedAnimation(
                parent: _entranceCtrl,
                curve: const Interval(0.35, 0.8, curve: Curves.easeOut),
              ),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: AppColors.borderSubtle,
                    width: 1.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppColors.guNavy.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.school_rounded,
                              size: 16, color: AppColors.guNavy),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'ACADEMIC DETAILS',
                          style: GoogleFonts.dmSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textSecondary,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _DetailRow(
                      icon: Icons.account_balance_rounded,
                      iconColor: AppColors.guGreen,
                      label: 'Faculty',
                      value: student.faculty,
                    ),
                    _DetailRow(
                      icon: Icons.mail_rounded,
                      iconColor: AppColors.info,
                      label: 'Email',
                      value: student.email,
                      isLast: true,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 32)),

        // ── Sign Out ─────────────────────────────────────────────────────
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          sliver: SliverToBoxAdapter(
            child: FadeTransition(
              opacity: CurvedAnimation(
                parent: _entranceCtrl,
                curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
              ),
              child: OutlinedButton.icon(
                onPressed: () => _showLogoutSheet(context),
                icon: const Icon(Icons.logout_rounded, size: 18),
                label: const Text('Sign Out'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.error,
                  side:
                      BorderSide(color: AppColors.error.withValues(alpha: 0.3)),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 40)),
      ],
    );
  }

  void _showLogoutSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.borderMedium,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 28),
            Text(
              'Sign Out?',
              style: GoogleFonts.playfairDisplay(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'You will need to sign in again to access the portal.',
              style: GoogleFonts.dmSans(
                color: AppColors.textSecondary,
                fontSize: 15,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      context.read<AuthCubit>().logout();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Sign Out'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  String _getGreeting(int hour) {
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }
}

// ── Badge ─────────────────────────────────────────────────────────────────────
class _Badge extends StatelessWidget {
  const _Badge({
    required this.icon,
    required this.label,
    required this.color,
    required this.bgColor,
    required this.borderColor,
  });
  final IconData icon;
  final String label;
  final Color color, bgColor, borderColor;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.dmSans(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Stat Card ─────────────────────────────────────────────────────────────────
class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.sub,
  });
  final IconData icon;
  final Color iconColor;
  final String label, value, sub;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.borderSubtle, width: 1.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: GoogleFonts.playfairDisplay(
              color: AppColors.textPrimary,
              fontSize: 32,
              fontWeight: FontWeight.w800,
              height: 1,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: GoogleFonts.dmSans(
              color: AppColors.textSecondary,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            sub,
            style: GoogleFonts.dmSans(
              color: AppColors.textMuted,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Detail Row ────────────────────────────────────────────────────────────────
class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    this.isLast = false,
  });
  final IconData icon;
  final Color iconColor;
  final String label, value;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 20, color: iconColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label.toUpperCase(),
                  style: GoogleFonts.dmSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textMuted,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: GoogleFonts.dmSans(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
