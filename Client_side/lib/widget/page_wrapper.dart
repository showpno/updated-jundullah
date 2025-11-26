import 'package:flutter/material.dart';

class PageWrapper extends StatelessWidget {
  final Widget child;
  const PageWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 800) {
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: child,
            ),
          );
        }
        return child;
      },
    );
  }
}
