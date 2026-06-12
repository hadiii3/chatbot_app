import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:chatbot_app/core/theme/app_theme.dart';
import 'package:chatbot_app/features/vehicle/cubit/vehicle_cubit.dart';
import 'package:chatbot_app/features/vehicle/cubit/vehicle_state.dart';
import 'package:chatbot_app/features/vehicle/data/models/vehicle_permit.dart';
import 'package:chatbot_app/core/utils/sanitizer.dart';

class VehicleScreen extends StatefulWidget {
  const VehicleScreen({super.key});
  @override
  State<VehicleScreen> createState() => _VehicleScreenState();
}

class _VehicleScreenState extends State<VehicleScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _plateCtrl = TextEditingController();
  final _makeCtrl = TextEditingController();
  final _modelCtrl = TextEditingController();
  final _colorCtrl = TextEditingController();
  bool _showForm = false;
  late AnimationController _entranceCtrl;

  @override
  void initState() {
    super.initState();
    _entranceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..forward();
  }

  @override
  void dispose() {
    _plateCtrl.dispose();
    _makeCtrl.dispose();
    _modelCtrl.dispose();
    _colorCtrl.dispose();
    _entranceCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      FocusScope.of(context).unfocus();
      context.read<VehicleCubit>().submitPermit(
            licensePlate: InputSanitizer.sanitize(_plateCtrl.text),
            make: InputSanitizer.sanitize(_makeCtrl.text),
            model: InputSanitizer.sanitize(_modelCtrl.text),
            color: InputSanitizer.sanitize(_colorCtrl.text),
          );
      _plateCtrl.clear();
      _makeCtrl.clear();
      _modelCtrl.clear();
      _colorCtrl.clear();
      setState(() => _showForm = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: BlocConsumer<VehicleCubit, VehicleState>(
        listener: (ctx, state) {
          if (state is VehicleSubmitted) {
            ScaffoldMessenger.of(ctx).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.check_circle_rounded,
                        color: Colors.white, size: 20),
                    const SizedBox(width: 12),
                    Text(
                      'Permit submitted — pending review.',
                      style: GoogleFonts.dmSans(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                backgroundColor: AppColors.guGreen,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                margin: const EdgeInsets.all(20),
                elevation: 10,
              ),
            );
          }
        },
        builder: (ctx, state) {
          final permits = state.permits;
          final isSubmitting = state is VehicleSubmitting;

          return CustomScrollView(
            slivers: [
              // ── Header (Dashboard style) ───────────────────────────────
              SliverToBoxAdapter(
                child: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Campus Parking',
                          style: GoogleFonts.dmSans(
                            color: AppColors.textSecondary,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Vehicle Access',
                          style: GoogleFonts.dmSans(
                            color: AppColors.textPrimary,
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            _StatChip(
                              value: '${permits.length}',
                              label: 'Total',
                              color: AppColors.guNavy,
                            ),
                            const SizedBox(width: 12),
                            _StatChip(
                              value:
                                  '${permits.where((p) => p.status == PermitStatus.approved).length}',
                              label: 'Approved',
                              color: AppColors.guGreen,
                            ),
                            const SizedBox(width: 12),
                            _StatChip(
                              value:
                                  '${permits.where((p) => p.status == PermitStatus.pending).length}',
                              label: 'Pending',
                              color: AppColors.guGold,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 24)),

              // ── New Permit CTA / Form ──────────────────────────────────
              if (state.currentPermit == null ||
                  state.currentPermit!.status != PermitStatus.pending)
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverToBoxAdapter(
                    child: FadeTransition(
                      opacity: CurvedAnimation(
                        parent: _entranceCtrl,
                        curve: const Interval(0.2, 0.6, curve: Curves.easeOut),
                      ),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        switchInCurve: Curves.easeOutCubic,
                        switchOutCurve: Curves.easeIn,
                        child: _showForm
                            ? _PermitForm(
                                key: const ValueKey('form'),
                                formKey: _formKey,
                                plateCtrl: _plateCtrl,
                                makeCtrl: _makeCtrl,
                                modelCtrl: _modelCtrl,
                                colorCtrl: _colorCtrl,
                                isSubmitting: isSubmitting,
                                onSubmit: _submit,
                                onCancel: () =>
                                    setState(() => _showForm = false),
                              )
                            : _NewPermitButton(
                                key: const ValueKey('btn'),
                                onTap: () => setState(() => _showForm = true),
                              ),
                      ),
                    ),
                  ),
                ),

              if (state.currentPermit == null ||
                  state.currentPermit!.status != PermitStatus.pending)
                const SliverToBoxAdapter(child: SizedBox(height: 24)),

              // ── Permits list ──────────────────────────────────────────
              if (permits.isEmpty)
                SliverToBoxAdapter(
                  child: FadeTransition(
                    opacity: CurvedAnimation(
                      parent: _entranceCtrl,
                      curve: const Interval(0.3, 0.8, curve: Curves.easeOut),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 48),
                      child: Column(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.borderSubtle,
                                width: 1.0,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.02),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Icon(Icons.no_transfer_rounded,
                                size: 36, color: AppColors.textMuted),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'No permits yet',
                            style: GoogleFonts.dmSans(
                              color: AppColors.textPrimary,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Register your vehicle for campus access',
                            style: GoogleFonts.dmSans(
                              color: AppColors.textSecondary,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              else ...[
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverToBoxAdapter(
                    child: Row(
                      children: [
                        const Icon(Icons.receipt_long_rounded,
                            size: 16, color: AppColors.textMuted),
                        const SizedBox(width: 8),
                        Text(
                          'YOUR PERMITS',
                          style: GoogleFonts.dmSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textSecondary,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 12)),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (ctx, i) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _PermitCard(
                            permit: permits[permits.length - 1 - i]),
                      ),
                      childCount: permits.length,
                    ),
                  ),
                ),
              ],

              const SliverToBoxAdapter(child: SizedBox(height: 40)),
            ],
          );
        },
      ),
    );
  }
}

// ── Stat Chip ─────────────────────────────────────────────────────────────────
class _StatChip extends StatelessWidget {
  const _StatChip(
      {required this.value, required this.label, required this.color});
  final String value, label;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderSubtle, width: 1.0),
        boxShadow: const [
          BoxShadow(
            color: AppColors.guNavy,
            blurRadius: 0,
            offset: Offset(4, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: GoogleFonts.playfairDisplay(
              color: color,
              fontSize: 32,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.dmSans(
              color: AppColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

// ── New Permit Button ─────────────────────────────────────────────────────────
class _NewPermitButton extends StatelessWidget {
  const _NewPermitButton({super.key, required this.onTap});
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.guNavy,
            width: 2.0,
          ),
          boxShadow: const [
            BoxShadow(
              color: AppColors.guNavy,
              blurRadius: 0,
              offset: Offset(4, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                gradient: AppColors.greenGradient,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.guGreen.withValues(alpha: 0.25),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child:
                  const Icon(Icons.add_rounded, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'New Permit Request',
                    style: GoogleFonts.dmSans(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Register vehicle for campus access',
                    style: GoogleFonts.dmSans(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded,
                color: AppColors.guGreen, size: 24),
          ],
        ),
      ),
    );
  }
}

// ── Permit Form ───────────────────────────────────────────────────────────────
class _PermitForm extends StatelessWidget {
  const _PermitForm({
    super.key,
    required this.formKey,
    required this.plateCtrl,
    required this.makeCtrl,
    required this.modelCtrl,
    required this.colorCtrl,
    required this.isSubmitting,
    required this.onSubmit,
    required this.onCancel,
  });
  final GlobalKey<FormState> formKey;
  final TextEditingController plateCtrl, makeCtrl, modelCtrl, colorCtrl;
  final bool isSubmitting;
  final VoidCallback onSubmit, onCancel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.borderMedium, width: 1.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Icon(Icons.edit_note_rounded,
                    size: 18, color: AppColors.guNavy),
                const SizedBox(width: 8),
                Text(
                  'VEHICLE DETAILS',
                  style: GoogleFonts.dmSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.guNavy,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'All fields required',
              style: GoogleFonts.dmSans(
                fontSize: 13,
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 24),
            _formField(plateCtrl, 'License Plate', 'ABC 1234',
                Icons.credit_card_rounded),
            const SizedBox(height: 12),
            _formField(
                makeCtrl, 'Make', 'Toyota', Icons.directions_car_rounded),
            const SizedBox(height: 12),
            _formField(modelCtrl, 'Model', 'Corolla', Icons.car_rental_rounded),
            const SizedBox(height: 12),
            _formField(colorCtrl, 'Color', 'Silver', Icons.palette_rounded),
            const SizedBox(height: 28),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: isSubmitting ? null : onCancel,
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: isSubmitting ? null : onSubmit,
                    child: isSubmitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2.5),
                          )
                        : const Text('Submit Request'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _formField(
      TextEditingController ctrl, String label, String hint, IconData icon) {
    return TextFormField(
      controller: ctrl,
      style: GoogleFonts.dmSans(
        color: AppColors.textPrimary,
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, size: 20),
      ),
      validator: (v) => (v == null || v.isEmpty) ? '$label is required' : null,
    );
  }
}

// ── Permit Card ───────────────────────────────────────────────────────────────
class _PermitCard extends StatelessWidget {
  const _PermitCard({required this.permit});
  final VehiclePermit permit;

  static const _statusColors = {
    PermitStatus.pending: AppColors.guGold,
    PermitStatus.approved: AppColors.guGreen,
    PermitStatus.rejected: AppColors.error,
    PermitStatus.none: AppColors.textMuted,
  };
  static const _statusIcons = {
    PermitStatus.pending: Icons.hourglass_top_rounded,
    PermitStatus.approved: Icons.check_circle_rounded,
    PermitStatus.rejected: Icons.cancel_rounded,
    PermitStatus.none: Icons.not_interested_rounded,
  };

  @override
  Widget build(BuildContext context) {
    final color = _statusColors[permit.status] ?? AppColors.textMuted;
    final icon = _statusIcons[permit.status] ?? Icons.help_outline;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderSubtle, width: 1.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.guGold.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: AppColors.guGold.withValues(alpha: 0.2),
              ),
            ),
            child: const Icon(Icons.directions_car_rounded,
                color: AppColors.guGold, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  permit.licensePlate,
                  style: GoogleFonts.dmSans(
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${permit.make} ${permit.model} · ${permit.color}',
                  style: GoogleFonts.dmSans(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: color.withValues(alpha: 0.2)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 14, color: color),
                const SizedBox(width: 6),
                Text(
                  permit.status.label,
                  style: GoogleFonts.dmSans(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
