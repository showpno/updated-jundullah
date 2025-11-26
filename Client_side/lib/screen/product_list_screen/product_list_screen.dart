import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../widget/product_grid_view.dart';
import '../../core/data/data_provider.dart';
import '../../utility/app_color.dart';
import 'components/category_selector.dart';
import 'components/custom_app_bar.dart';
import 'components/poster_section.dart';

class ProductListScreen extends StatelessWidget {
  final VoidCallback? onMenuPressed;
  
  const ProductListScreen({super.key, this.onMenuPressed});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(onMenuPressed: onMenuPressed),
      body: SafeArea(
        child: SingleChildScrollView(
          clipBehavior: Clip.none,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColor.primary, AppColor.brandGold],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.primary.withOpacity(0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Text(
                  "Hello There 👋",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [AppColor.primary, AppColor.brandGold],
                ).createShader(bounds),
                child: Text(
                  "Let's get something? 🛍️",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const PosterSection(),
              const SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Container(
                    width: 4,
                    height: 24,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColor.primary, AppColor.brandGold],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    "Top categories",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColor.darkAccent,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Consumer<DataProvider>(
                builder: (context, dataProvider, child) {
                  return CategorySelector(
                    categories: dataProvider.categories,
                  );
                },
              ),
              const SizedBox(height: 15),
              Consumer<DataProvider>(
                builder: (context, dataProvider, child) {
                  return ProductGridView(
                    items: dataProvider.products,
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
