import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:chatbot_app/core/injection/injection.dart';
import 'package:chatbot_app/core/theme/app_theme.dart';
import 'package:chatbot_app/features/chatbot/cubit/chat_cubit.dart';
import 'package:chatbot_app/features/chatbot/presentation/screens/chatbot_screen.dart';
import 'package:chatbot_app/features/dashboard/cubit/dashboard_cubit.dart';
import 'package:chatbot_app/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:chatbot_app/features/dashboard/repositories/dashboard_repository.dart';
import 'package:chatbot_app/features/vehicle/cubit/vehicle_cubit.dart';
import 'package:chatbot_app/features/vehicle/presentation/screens/vehicle_screen.dart';
import 'package:chatbot_app/features/vehicle/repositories/vehicle_repository.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});
  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _currentIndex = 0;

  void _onTabTap(int index) {
    if (index == _currentIndex) return;
    HapticFeedback.selectionClick();
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => DashboardCubit(getIt<DashboardRepository>()),
        ),
        BlocProvider(
          create: (_) => ChatCubit(),
        ),
        BlocProvider(
          create: (_) => VehicleCubit(getIt<VehicleRepository>()),
        ),
      ],
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark, // Dark icons for light theme
        child: Scaffold(
          backgroundColor: AppColors.canvas,
          body: IndexedStack(
            index: _currentIndex,
            children: const [
              DashboardScreen(),
              ChatbotScreen(),
              VehicleScreen(),
            ],
          ),
          bottomNavigationBar: _buildNavBar(),
        ),
      ),
    );
  }

  Widget _buildNavBar() {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(
            color: AppColors.borderSubtle,
            width: 1.0,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              _NavItem(
                icon: Icons.grid_view_rounded,
                activeIcon: Icons.grid_view_rounded,
                label: 'Dashboard',
                isActive: _currentIndex == 0,
                onTap: () => _onTabTap(0),
              ),
              _NavItem(
                icon: Icons.auto_awesome_outlined,
                activeIcon: Icons.auto_awesome_rounded,
                label: 'Assistant',
                isActive: _currentIndex == 1,
                onTap: () => _onTabTap(1),
              ),
              _NavItem(
                icon: Icons.directions_car_outlined,
                activeIcon: Icons.directions_car_rounded,
                label: 'Vehicle',
                isActive: _currentIndex == 2,
                onTap: () => _onTabTap(2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Custom nav item ──────────────────────────────────────────────────────────
class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.guGreen.withValues(alpha: 0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  isActive ? activeIcon : icon,
                  key: ValueKey(isActive),
                  size: 24,
                  color: isActive ? AppColors.guGreen : AppColors.textMuted,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: GoogleFonts.dmSans(
                  fontSize: 11,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                  color: isActive ? AppColors.guGreen : AppColors.textMuted,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
