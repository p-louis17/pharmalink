import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/app_theme.dart';
import 'core/services/location_service.dart';
import 'core/services/overpass_service.dart';
import 'features/blessing_auth/cubit/auth_cubit.dart';
import 'features/blessing_auth/repository/auth_repository.dart';
import 'navigation/auth_gate.dart';

class PharmaLinkApp extends StatelessWidget {
  const PharmaLinkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => LocationService()),
        RepositoryProvider(create: (_) => OverpassService()),
        RepositoryProvider<AuthRepository>(create: (_) => AuthRepositoryImpl()),
      ],
      // AuthCubit's provider lives HERE, above MaterialApp — not inside
      // `home:`. `home:` only covers the first route; Register and
      // Forgot Password are pushed as separate routes via Navigator.push,
      // so a provider scoped to `home:` alone is invisible to them.
      child: BlocProvider(
        create: (context) =>
            AuthCubit(context.read<AuthRepository>())..checkAuthStatus(),
        child: MaterialApp(
          title: 'PharmaLink',
          theme: AppTheme.light,
          debugShowCheckedModeBanner: false,
          home: const AuthGate(),
        ),
      ),
    );
  }
}