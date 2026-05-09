import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:chatbot_app/app.dart';
import 'package:chatbot_app/core/injection/injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Set up dependency injection
  await setupInjection();

  runApp(const App());
}
