import 'package:flutter/material.dart';

class SnackBarHelper {
  static void showErrorSnackBar(String message, {String title = "Error"}) {
    final context = _getContext();
    if (context == null) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      message,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          duration: const Duration(seconds: 3),
        ),
      );
  }

  static void showSuccessSnackBar(String message, {String title = "Success"}) {
    final context = _getContext();
    if (context == null) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      message,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          duration: const Duration(seconds: 3),
        ),
      );
  }

  /// Get the best available BuildContext
  static BuildContext? _getContext() {
    // 1. Try direct context
    if (navigatorKey.currentContext != null &&
        navigatorKey.currentContext!.mounted) {
      return navigatorKey.currentContext;
    }

    // 2. Try overlay context (more reliable)
    if (navigatorKey.currentState?.overlay?.context != null &&
        navigatorKey.currentState!.overlay!.context.mounted) {
      return navigatorKey.currentState!.overlay!.context;
    }

    return null;
  }
}

/// Global navigator key (put inside MaterialApp)
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
