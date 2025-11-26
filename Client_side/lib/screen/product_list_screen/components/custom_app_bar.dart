import 'package:flutter/material.dart';
import 'package:nexara_cart/utility/extensions.dart';
import 'package:provider/provider.dart';

import '../../../widget/app_bar_action_button.dart';
import '../../../widget/custom_search_bar.dart';
import '../../../core/data/data_provider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onMenuPressed;
  
  @override
  Size get preferredSize => const Size.fromHeight(100);

  const CustomAppBar({super.key, this.onMenuPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Row(
            children: [
              // Menu Button
              AppBarActionButton(
                icon: Icons.menu,
                onPressed: () {
                  if (onMenuPressed != null) {
                    onMenuPressed!();
                  } else {
                    // Fallback to default behavior
                    try {
                      Scaffold.of(context).openDrawer();
                    } catch (e) {
                      debugPrint('Error opening drawer: $e');
                    }
                  }
                },
              ),

              const SizedBox(width: 10),

              // Search Bar
              Expanded(
                child: CustomSearchBar(
                  controller: TextEditingController(),
                  onChanged: (val) {
                    context.dataProvider.filterProducts(val);
                  },
                ),
              ),

              const SizedBox(width: 10),

              // Refresh Button
              AppBarActionButton(
  icon: Icons.refresh,
  onPressed: () async {
    final dataProvider = Provider.of<DataProvider>(context, listen: false);

    // Correct methods
    await dataProvider.getAllCategories(showSnack: true);
    await dataProvider.getAllProducts(showSnack: true);

    // Optional snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Data refreshed')),
    );
  },
),

            ],
          ),
        ),
      ),
    );
  }
}
