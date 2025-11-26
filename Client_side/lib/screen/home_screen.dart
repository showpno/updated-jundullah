import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utility/app_data.dart';
import '../../../utility/app_color.dart';
import '../../../core/data/data_provider.dart';
import '../utility/functions.dart';
import 'product_cart_screen/cart_screen.dart';
import 'product_favorite_screen/favorite_screen.dart';
import 'product_list_screen/product_list_screen.dart';
import 'profile_screen/profile_screen.dart';
import '../../../widget/navigation_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int newIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    checkServerConnectivity();
    // Load initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final dataProvider = Provider.of<DataProvider>(context, listen: false);
        // Load data in background
        dataProvider.getAllCategories();
        dataProvider.getAllProducts();
        dataProvider.getAllPosters();
      }
    });
  }

  void openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  List<Widget> getScreens() => [
    ProductListScreen(onMenuPressed: openDrawer),
    FavoriteScreen(),
    CartScreen(),
    ProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColor.background,
      drawer: _buildDrawer(context),
      body: Builder(
        builder: (context) {
          try {
            return _buildBody();
          } catch (e) {
            debugPrint('Error building HomeScreen: $e');
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: AppColor.primary),
                  const SizedBox(height: 16),
                  Text(
                    'Something went wrong',
                    style: TextStyle(fontSize: 18, color: AppColor.darkAccent),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    e.toString(),
                    style: TextStyle(fontSize: 14, color: AppColor.lightAccent),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }
        },
      ),
      bottomNavigationBar: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white,
                AppColor.background,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: NavigationBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            indicatorColor: AppColor.primary.withOpacity(0.2),
            onDestinationSelected: (int index) {
              setState(() {
                newIndex = index;
              });
            },
            selectedIndex: newIndex,
            destinations: AppData.bottomNavBarItems
                .asMap()
                .entries
                .map(
                  (entry) {
                    final index = entry.key;
                    final item = entry.value;
                    final isSelected = newIndex == index;
                    return NavigationDestination(
                      icon: Icon(
                        item.icon.icon,
                        color: isSelected ? AppColor.primary : AppColor.lightAccent,
                      ),
                      label: item.title,
                      selectedIcon: Icon(
                        item.icon.icon,
                        color: AppColor.primary,
                      ),
                    );
                  },
                )
                .toList(),
            labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          ),
        ),
    );
  }

  Widget _buildBody() {
    return PageTransitionSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (
        Widget child,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
      ) {
        return FadeThroughTransition(
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          child: child,
        );
      },
      child: getScreens()[newIndex],
      key: ValueKey<int>(newIndex),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            // Drawer Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColor.primary, AppColor.brandGold],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Nexara Cart',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Welcome to our store',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Menu Items
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      setState(() {
                        newIndex = 0;
                      });
                    },
                    child: NavigationTile(
                      icon: Icons.home,
                      title: 'Home',
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      setState(() {
                        newIndex = 1;
                      });
                    },
                    child: NavigationTile(
                      icon: Icons.favorite,
                      title: 'Favorites',
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      setState(() {
                        newIndex = 2;
                      });
                    },
                    child: NavigationTile(
                      icon: Icons.shopping_cart,
                      title: 'Cart',
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      setState(() {
                        newIndex = 3;
                      });
                    },
                    child: NavigationTile(
                      icon: Icons.person,
                      title: 'Profile',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
