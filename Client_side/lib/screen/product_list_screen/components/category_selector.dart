import 'package:flutter/material.dart';
import 'package:nexara_cart/utility/constants.dart';

import '../../../models/category.dart';
import '../../../utility/animation/open_container_wrapper.dart';
import '../../../utility/app_color.dart';
import '../../product_by_category_screen/product_by_category_screen.dart';

class CategorySelector extends StatefulWidget {
  final List<Category> categories;

  const CategorySelector({
    super.key,
    required this.categories,
  });

  @override
  State<CategorySelector> createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  final ScrollController _scrollController = ScrollController();
  bool _showRightArrow = true;
  bool _showLeftArrow = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_checkScrollPosition);
    // Check initial scroll position after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkScrollPosition();
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_checkScrollPosition);
    _scrollController.dispose();
    super.dispose();
  }

  void _checkScrollPosition() {
    if (_scrollController.hasClients) {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.position.pixels;
      final isAtEnd = currentScroll >= maxScroll - 10;
      final isAtStart = currentScroll <= 10;
      
      if (mounted) {
        setState(() {
          _showRightArrow = !isAtEnd;
          _showLeftArrow = !isAtStart;
        });
      }
    }
  }

  void _scrollRight() {
    if (_scrollController.hasClients) {
      final currentPosition = _scrollController.position.pixels;
      final targetPosition = currentPosition + 200; // Scroll 200 pixels to the right
      _scrollController.animateTo(
        targetPosition > _scrollController.position.maxScrollExtent
            ? _scrollController.position.maxScrollExtent
            : targetPosition,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _scrollLeft() {
    if (_scrollController.hasClients) {
      final currentPosition = _scrollController.position.pixels;
      final targetPosition = currentPosition - 200; // Scroll 200 pixels to the left
      _scrollController.animateTo(
        targetPosition < 0 ? 0 : targetPosition,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: 64,
          child: ListView.builder(
            controller: _scrollController,
            clipBehavior: Clip.none,
            scrollDirection: Axis.horizontal,
            itemCount: widget.categories.length,
            itemBuilder: (context, index) {
              final category = widget.categories[index];
              return Container(
                margin: const EdgeInsets.only(right: 12, top: 1, bottom: 1),
                child: OpenContainerWrapper(
                  nextScreen:
                      ProductByCategoryScreen(selectedCategory: widget.categories[index]),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                    decoration: BoxDecoration(
                      gradient: category.isSelected
                          ? const LinearGradient(
                              colors: [AppColor.primary, AppColor.brandGold],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : null,
                      color: category.isSelected ? null : Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: category.isSelected
                            ? AppColor.primary
                            : Colors.grey[300]!,
                        width: category.isSelected ? 2 : 1,
                      ),
                      boxShadow: category.isSelected
                          ? [
                              BoxShadow(
                                color: AppColor.primary.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : null,
                    ),
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Image.network(
                            category.image != null
                                ? '$SERVER_URL${category.image}'
                                : '',
                            width: 90,
                            height: 90,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.error, color: Colors.grey);
                            },
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          category.name ?? '',
                          style: TextStyle(
                            color: category.isSelected
                                ? Colors.white
                                : AppColor.darkAccent,
                            fontSize: 12,
                            fontWeight: category.isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              );
          },
        ),
      ),
      // Left arrow button
      if (_showLeftArrow && widget.categories.isNotEmpty)
        Positioned(
          left: 0,
          top: 0,
          bottom: 0,
          child: Container(
            width: 40,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white,
                  Colors.white.withOpacity(0.9),
                  Colors.white.withOpacity(0.0),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            child: Center(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _scrollLeft,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColor.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.arrow_back_ios,
                      size: 16,
                      color: AppColor.primary,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      // Right arrow button
      if (_showRightArrow && widget.categories.isNotEmpty)
        Positioned(
          right: 0,
          top: 0,
          bottom: 0,
          child: Container(
            width: 40,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.0),
                  Colors.white.withOpacity(0.9),
                  Colors.white,
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            child: Center(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _scrollRight,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColor.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: AppColor.primary,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
    ]);
  }
}
