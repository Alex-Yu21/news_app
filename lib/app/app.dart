import 'package:flutter/material.dart';

import 'router.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'News',
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
    );
  }
}
