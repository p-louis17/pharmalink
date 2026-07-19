import 'package:flutter/material.dart';

import 'auth_text_field.dart';

class AuthHeader extends StatelessWidget {
  final bool showAppName;

  const AuthHeader({super.key, this.showAppName = true});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: kAuthBrandBlue,
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(Icons.local_pharmacy_rounded,
              color: Colors.white, size: 30),
        ),
        if (showAppName) ...[
          const SizedBox(height: 12),
          const Text(
            'PharmaLink',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ],
    );
  }
}
