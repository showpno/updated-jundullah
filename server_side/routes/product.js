const express = require("express");
const router = express.Router();
const asyncHandler = require("express-async-handler");
const Product = require("../model/product");

// Get all products
router.get(
  "/",
  asyncHandler(async (req, res) => {
    const { category, brand, search } = req.query;
    
    try {
      // First, try direct MongoDB query to see what's in the collection
      const db = require("mongoose").connection.db;
      const productsCollection = db.collection("products");
      const rawCount = await productsCollection.countDocuments({});
      console.log(`Total products in database: ${rawCount}`);
      
      let query = {}; // Get all products from database - no filter by default
      
      // Support both old field names (proCategoryId) and new field names (category)
      if (category) {
        query.$or = [
          { proCategoryId: category },
          { category: category }
        ];
      }
      
      if (brand) {
        if (query.$or) {
          // Combine with existing $or using $and
          query = { 
            $and: [
              query,
              { $or: [{ proBrandId: brand }, { brand: brand }] }
            ]
          };
        } else {
          query.$or = [
            { proBrandId: brand },
            { brand: brand }
          ];
        }
      }
      
      if (search) {
        query.name = { $regex: search, $options: "i" };
      }
      
      // Try to get products with all possible field combinations
      const products = await Product.find(query)
        .populate("proCategoryId", "name image")
        .populate("proSubCategoryId", "name")
        .populate("proBrandId", "name")
        .populate("proVariantTypeId", "name")
        .populate("proVariantId", "name value")
        .populate("category", "name image")
        .populate("subCategory", "name")
        .populate("brand", "name")
        .populate("variants.variant")
        .sort({ createdAt: -1 });
      
      console.log(`Found ${products.length} products with Mongoose query`);
      
      // If Mongoose returns empty but database has data, use raw MongoDB query
      if (products.length === 0 && rawCount > 0) {
        console.log("Mongoose query returned empty, trying raw MongoDB query...");
        const rawProducts = await productsCollection.find({}).limit(100).toArray();
        console.log(`Raw MongoDB query found ${rawProducts.length} products`);
        
        // Map raw products to expected format
        const mappedProducts = await Promise.all(rawProducts.map(async (product) => {
          // Try to populate references manually if needed
          const populated = { ...product };
          
          if (product.proCategoryId) {
            try {
              const Category = require("../model/category");
              populated.proCategoryId = await Category.findById(product.proCategoryId);
            } catch (e) {
              console.error("Error populating category:", e);
            }
          }
          
          if (product.proSubCategoryId) {
            try {
              const SubCategory = require("../model/subCategory");
              populated.proSubCategoryId = await SubCategory.findById(product.proSubCategoryId);
            } catch (e) {
              console.error("Error populating subCategory:", e);
            }
          }
          
          if (product.proBrandId) {
            try {
              const Brand = require("../model/brand");
              populated.proBrandId = await Brand.findById(product.proBrandId);
            } catch (e) {
              console.error("Error populating brand:", e);
            }
          }
          
          return populated;
        }));
        
        return res.json({ success: true, message: "Products fetched", data: mappedProducts });
      }
      
      res.json({ success: true, message: "Products fetched", data: products });
    } catch (error) {
      console.error("Error fetching products:", error);
      res.status(500).json({ success: false, message: error.message, data: null });
    }
  })
);

// Get single product
router.get(
  "/:id",
  asyncHandler(async (req, res) => {
    const product = await Product.findById(req.params.id)
      .populate("proCategoryId", "name image")
      .populate("proSubCategoryId", "name")
      .populate("proBrandId", "name")
      .populate("proVariantTypeId", "name")
      .populate("proVariantId", "name value")
      .populate("category", "name image")
      .populate("subCategory", "name")
      .populate("brand", "name")
      .populate("variants.variant");
    if (!product) {
      return res.status(404).json({ success: false, message: "Product not found", data: null });
    }
    res.json({ success: true, message: "Product fetched", data: product });
  })
);

// Create product
router.post(
  "/",
  asyncHandler(async (req, res) => {
    const product = new Product(req.body);
    await product.save();
    res.json({ success: true, message: "Product created", data: product });
  })
);

// Update product
router.put(
  "/:id",
  asyncHandler(async (req, res) => {
    const product = await Product.findByIdAndUpdate(req.params.id, req.body, { new: true })
      .populate("proCategoryId", "name image")
      .populate("proSubCategoryId", "name")
      .populate("proBrandId", "name")
      .populate("category", "name image")
      .populate("subCategory", "name")
      .populate("brand", "name");
    if (!product) {
      return res.status(404).json({ success: false, message: "Product not found", data: null });
    }
    res.json({ success: true, message: "Product updated", data: product });
  })
);

// Delete product
router.delete(
  "/:id",
  asyncHandler(async (req, res) => {
    const product = await Product.findByIdAndDelete(req.params.id);
    if (!product) {
      return res.status(404).json({ success: false, message: "Product not found", data: null });
    }
    res.json({ success: true, message: "Product deleted", data: null });
  })
);

module.exports = router;


