import 'package:flutter/material.dart';

// Shared loading state — use this instead of a bare CircularProgressIndicator
// so every feature's loading screen looks the same.
class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}
