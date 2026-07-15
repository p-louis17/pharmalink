import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/app_theme.dart';
import 'core/services/location_service.dart';
import 'core/services/overpass_service.dart';
import 'features/louis_map/cubit/pharmacy_map_cubit.dart';
import 'navigation/root_shell.dart';

class PharmaLinkApp extends StatelessWidget {
  const PharmaLinkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => LocationService()),
        RepositoryProvider(create: (_) => OverpassService()),
      ],
      child: MaterialApp(
        title: 'PharmaLink',
        theme: AppTheme.light,
        debugShowCheckedModeBanner: false,
        home: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => PharmacyMapCubit(
                context.read<LocationService>(),
                context.read<OverpassService>(),
              )..loadNearbyPharmacies(),
            ),
          ],
          child: const RootShell(),
        ),
      ),
    );
  }
}
