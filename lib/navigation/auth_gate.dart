import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/services/location_service.dart';
import '../core/services/overpass_service.dart';
import '../features/blessing_auth/cubit/auth_cubit.dart';
import '../features/blessing_auth/cubit/auth_state.dart';
import '../features/blessing_auth/screens/login_screen.dart';
import '../features/louis_map/cubit/pharmacy_map_cubit.dart';
import 'root_shell.dart';

/// Sits above [RootShell] and swaps between the login flow and the main
/// app shell based on [AuthCubit]'s state. `checkAuthStatus()` is fired
/// once here (via BlocProvider's create) so the app doesn't flash the
/// login screen before a persisted session has had a chance to resolve.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        switch (state.status) {
          case AuthStatus.initial:
          case AuthStatus.loading:
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );

          case AuthStatus.authenticated:
            // Only pull in map/location work once the user is actually
            // signed in — no point prompting for location permission
            // before they've logged in.
            return BlocProvider(
              create: (context) => PharmacyMapCubit(
                context.read<LocationService>(),
                context.read<OverpassService>(),
              )..loadNearbyPharmacies(),
              child: const RootShell(),
            );

          case AuthStatus.unauthenticated:
          case AuthStatus.error:
          case AuthStatus.passwordResetSent:
            return const LoginScreen();
        }
      },
    );
  }
}
