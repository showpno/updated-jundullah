import 'package:flutter/material.dart';
import 'package:nexara_cart/utility/extensions.dart';

import '../utility/app_color.dart';

class CustomSearchBar extends StatefulWidget {
  final TextEditingController controller;
  final void Function(String)? onChanged;

  const CustomSearchBar({
    super.key,
    required this.controller,
    this.onChanged,
  });

  @override
  CustomSearchBarState createState() => CustomSearchBarState();
}

class CustomSearchBarState extends State<CustomSearchBar> {
  bool isExpanded = false;
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isExpanded = !isExpanded;
          if (!isExpanded) {
            _focusNode.unfocus();
          }
        });
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: Colors.white,
          border: Border.all(
            color: AppColor.primary.withOpacity(0.3),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColor.primary.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: FocusScope(
          node: FocusScopeNode(),
          child: Row(
            children: [
              Icon(
                Icons.search,
                color: AppColor.primary,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  focusNode: _focusNode,
                  controller: widget.controller,
                  decoration: const InputDecoration(
                    hintText: 'Search...',
                    border: InputBorder.none,
                  ),
                  autofocus: false,
                  onChanged: widget.onChanged,
                ),
              ),
              GestureDetector(
                onTap: () {
                  widget.controller.clear();
                  _focusNode.unfocus();
                  context.dataProvider.filterProducts('');
                },
                child: Icon(
                  Icons.close,
                  color: AppColor.lightAccent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
