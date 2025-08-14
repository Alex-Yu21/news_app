import 'package:flutter/material.dart';

import 'app/app.dart';
import 'app/config/app_env.dart';
import 'app/di/locator.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  ensureApiKey();
  setupLocator();
  runApp(const App());
}
