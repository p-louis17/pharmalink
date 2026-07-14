import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'navigation/root_shell.dart';

class PharmaLinkApp extends StatelessWidget {
  const PharmaLinkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PharmaLink',
      theme: AppTheme.light,
      debugShowCheckedModeBanner: false,
      home: const RootShell(),
    );
  }
}
