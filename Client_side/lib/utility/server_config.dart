import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';

/// Server configuration that automatically detects the environment
/// and uses the appropriate server URL
class ServerConfig {
  // Default server port
  static const int serverPort = 5000;

  // Manual override for physical device IP (REQUIRED for physical devices)
  // Set this to your computer's local IP address (e.g., '192.168.1.100')
  // You can find it by running 'ipconfig' on Windows or 'ifconfig' on Mac/Linux
  // Look for "IPv4 Address" under your active network adapter (usually Wi-Fi or Ethernet)
  // IMPORTANT: Both your computer and phone must be on the same Wi-Fi network!
  static const String? manualPhysicalDeviceIP = '192.168.0.247'; // Set to your Wi-Fi IP address

  // Cache for server URL
  static String? _cachedServerUrl;

  /// Gets the appropriate server URL based on the device type
  static Future<String> getServerUrl() async {
    if (_cachedServerUrl != null) {
      return _cachedServerUrl!;
    }

    // For web, iOS simulator, or other platforms, try localhost first
    if (kIsWeb || Platform.isIOS || Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      _cachedServerUrl = 'http://localhost:$serverPort';
      return _cachedServerUrl!;
    }

    // For Android
    if (Platform.isAndroid) {
      final bool isEmulator = await _isAndroidEmulator();
      
      if (isEmulator) {
        // Use 10.0.2.2 for Android emulator (maps to host machine's localhost)
        _cachedServerUrl = 'http://10.0.2.2:$serverPort';
      } else {
        // For physical Android device
        if (manualPhysicalDeviceIP != null && manualPhysicalDeviceIP!.isNotEmpty) {
          // Use manually configured IP
          _cachedServerUrl = 'http://$manualPhysicalDeviceIP:$serverPort';
        } else {
          // Physical device detected but IP not configured
          // Show warning and use placeholder (will likely fail, but better than silent failure)
          // TODO: User needs to set manualPhysicalDeviceIP in this file
          print('⚠️ WARNING: Physical device detected but manualPhysicalDeviceIP is not set!');
          print('⚠️ Please set manualPhysicalDeviceIP in lib/utility/server_config.dart');
          print('⚠️ Run get_local_ip.ps1 to find your local IP address');
          // Use placeholder - connection will fail with clear error message
          _cachedServerUrl = 'http://YOUR_LOCAL_IP:$serverPort';
        }
      }
      return _cachedServerUrl!;
    }

    // Fallback
    _cachedServerUrl = 'http://localhost:$serverPort';
    return _cachedServerUrl!;
  }

  /// Checks if the Android device is an emulator
  static Future<bool> _isAndroidEmulator() async {
    try {
      final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      
      // Emulators typically have these characteristics:
      // - manufacturer contains 'unknown' or is 'Google'
      // - model contains 'sdk' or 'Emulator' or 'Android SDK'
      // - hardware contains 'goldfish' or 'ranchu' or 'vbox86'
      final String manufacturer = androidInfo.manufacturer.toLowerCase();
      final String model = androidInfo.model.toLowerCase();
      final String hardware = androidInfo.hardware.toLowerCase();
      
      return manufacturer.contains('unknown') ||
          manufacturer.contains('google') ||
          model.contains('sdk') ||
          model.contains('emulator') ||
          model.contains('android sdk') ||
          hardware.contains('goldfish') ||
          hardware.contains('ranchu') ||
          hardware.contains('vbox86');
    } catch (e) {
      // If we can't determine, assume it's a physical device
      return false;
    }
  }

  /// Clears the cached server URL (useful for testing)
  static void clearCache() {
    _cachedServerUrl = null;
  }
}
