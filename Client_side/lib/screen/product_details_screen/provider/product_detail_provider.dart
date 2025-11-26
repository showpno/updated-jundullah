import 'package:flutter/cupertino.dart';
import 'package:flutter_cart/flutter_cart.dart';
import 'package:nexara_cart/utility/snack_bar_helper.dart';
import 'package:nexara_cart/utility/utility_extention.dart';

import '../../../core/data/data_provider.dart';
import '../../../models/product.dart';

class ProductDetailProvider extends ChangeNotifier {
  final DataProvider _dataProvider;
  String? selectedVariant;
  var flutterCart = FlutterCart();

  ProductDetailProvider(this._dataProvider);

  void addToCart(Product product) {
    // Check if variant is required but not selected
    if (product.proVariantId!.isNotEmpty && selectedVariant == null) {
      SnackBarHelper.showErrorSnackBar('Please select a variant.');
      return;
    }

    // Check if product is in stock
    if (product.quantity == null || product.quantity! <= 0) {
      SnackBarHelper.showErrorSnackBar('${product.name} is out of stock.');
      return;
    }

    // Get current cart item if it exists
    String productId = '${product.sId}';
    CartModel? existingCartItem;
    
    try {
      existingCartItem = flutterCart.cartItemsList.firstWhere(
        (item) => item.productId == productId && 
                  item.variants.safeElementAt(0)?.color == selectedVariant
      );
    } catch (e) {
      existingCartItem = null;
    }

    // Calculate new quantity if item exists in cart
    int newQuantity = 1;
    if (existingCartItem != null) {
      newQuantity = existingCartItem.quantity + 1;
    }

    // Check if adding this quantity exceeds available stock
    if (newQuantity > product.quantity!) {
      SnackBarHelper.showErrorSnackBar(
        'Cannot add more. Only ${product.quantity} items available in stock.'
      );
      return;
    }

    double? price = product.offerPrice != product.price
        ? product.offerPrice
        : product.price;

    flutterCart.addToCart(
      cartModel: CartModel(
        productId: productId,
        productName: '${product.name}',
        variants: [
          ProductVariant(
            price: price ?? 0,
            color: selectedVariant,
          )
        ],
        productDetails: '${product.description}',
        productImages: ['${product.images.safeElementAt(0)?.url}'],
      )
    );

    selectedVariant = null;
    SnackBarHelper.showSuccessSnackBar(
      '${product.name} has been added to cart.'
    );

    notifyListeners();
  }

  void updateUI() {
    notifyListeners();
  }
}