import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:chatbot_app/core/constants/app_constants.dart';
import 'package:chatbot_app/features/auth/data/datasource/auth_local_datasource.dart';
import 'package:chatbot_app/features/auth/data/repo/auth_repo_impl.dart';
import 'package:chatbot_app/features/auth/repositories/auth_repository.dart';
import 'package:chatbot_app/features/dashboard/data/datasource/dashboard_local_datasource.dart';
import 'package:chatbot_app/features/dashboard/data/repo/dashboard_repo_impl.dart';
import 'package:chatbot_app/features/dashboard/repositories/dashboard_repository.dart';
import 'package:chatbot_app/features/vehicle/data/datasource/vehicle_local_datasource.dart';
import 'package:chatbot_app/features/vehicle/data/repo/vehicle_repo_impl.dart';
import 'package:chatbot_app/features/vehicle/repositories/vehicle_repository.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupInjection() async {
  // ── Hive Boxes ────────────────────────────────────────────────────────────
  final authBox = await Hive.openBox<dynamic>(AppConstants.authBox);
  final settingsBox = await Hive.openBox<dynamic>(AppConstants.appSettingsBox);

  getIt.registerSingleton<Box<dynamic>>(authBox,
      instanceName: AppConstants.authBox);
  getIt.registerSingleton<Box<dynamic>>(settingsBox,
      instanceName: AppConstants.appSettingsBox);

  // ── Auth Feature ──────────────────────────────────────────────────────────
  getIt.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSource(
        getIt<Box<dynamic>>(instanceName: AppConstants.authBox)),
  );
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepoImpl(getIt<AuthLocalDataSource>()),
  );

  // ── Dashboard Feature ─────────────────────────────────────────────────────
  getIt.registerLazySingleton<DashboardLocalDataSource>(
    () => DashboardLocalDataSource(
        getIt<Box<dynamic>>(instanceName: AppConstants.authBox)),
  );
  getIt.registerLazySingleton<DashboardRepository>(
    () => DashboardRepoImpl(getIt<DashboardLocalDataSource>()),
  );

  // ── Vehicle Feature ───────────────────────────────────────────────────────
  getIt.registerLazySingleton<VehicleLocalDataSource>(
    () => VehicleLocalDataSource(
        getIt<Box<dynamic>>(instanceName: AppConstants.authBox)),
  );
  getIt.registerLazySingleton<VehicleRepository>(
    () => VehicleRepoImpl(getIt<VehicleLocalDataSource>()),
  );
}
