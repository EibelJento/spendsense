import 'package:flutter/material.dart';

import 'app.dart';
import 'core/app_initializer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AppInitializer.initialize();

  runApp(const SpendSenseApp());
}