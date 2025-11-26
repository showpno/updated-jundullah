import 'dart:ui' show PointerDeviceKind;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cart/cart.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:nexara_cart/screen/auth_screen/login_screen.dart';
import 'package:nexara_cart/utility/constants.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';

import 'core/data/data_provider.dart';
import 'screen/auth_screen/provider/user_provider.dart';
import 'screen/product_by_category_screen/provider/product_by_category_provider.dart';
import 'screen/product_cart_screen/provider/cart_provider.dart';
import 'screen/product_details_screen/provider/product_detail_provider.dart';
import 'screen/product_favorite_screen/provider/favorite_provider.dart';
import 'screen/profile_screen/provider/profile_provider.dart';
import 'utility/app_theme.dart';
import 'utility/extensions.dart';
import 'utility/snack_bar_helper.dart';  // <-- Ensure navigatorKey is imported from here
import 'utility/server_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize server URL based on device type
  SERVER_URL = await ServerConfig.getServerUrl();
  debugPrint('Server URL initialized: $SERVER_URL');

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
    ),
  );
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await GetStorage.init();
  var cart = FlutterCart();
  
  // Initialize OneSignal only if app ID is configured
  if (ONESIGNAL_APP_ID != 'YOUR_ONE_SIGNAL_APP_ID' && ONESIGNAL_APP_ID.isNotEmpty) {
    try {
      OneSignal.initialize(ONESIGNAL_APP_ID);
      OneSignal.Notifications.requestPermission(true);
    } catch (e) {
      debugPrint('OneSignal initialization error: $e');
    }
  }
  
  await cart.initializeCart(isPersistenceSupportEnabled: true);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => DataProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => UserProvider(context.dataProvider),
        ),
        ChangeNotifierProvider(
          create: (context) => ProfileProvider(context.dataProvider),
        ),
        ChangeNotifierProvider(
          create: (context) => ProductByCategoryProvider(context.dataProvider),
        ),
        ChangeNotifierProvider(
          create: (context) => ProductDetailProvider(context.dataProvider),
        ),
        ChangeNotifierProvider(
          create: (context) => CartProvider(
            context.userProvider,
            context.dataProvider,
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => FavoriteProvider(context.dataProvider),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorKey: navigatorKey,   // ✅ FIXED — REQUIRED FOR SNACKBAR
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
        },
      ),
      debugShowCheckedModeBanner: false,
      home: const LoginScreen(), // Open login page first
      theme: AppTheme.lightAppTheme,
    );
  }
}
