const express = require("express");
const router = express.Router();
const asyncHandler = require("express-async-handler");
const Category = require("../model/category");

// Get all categories
router.get(
  "/",
  asyncHandler(async (req, res) => {
    const categories = await Category.find().sort({ createdAt: -1 });
    res.json({ success: true, message: "Categories fetched", data: categories });
  })
);

// Get single category
router.get(
  "/:id",
  asyncHandler(async (req, res) => {
    const category = await Category.findById(req.params.id);
    if (!category) {
      return res.status(404).json({ success: false, message: "Category not found", data: null });
    }
    res.json({ success: true, message: "Category fetched", data: category });
  })
);

// Create category
router.post(
  "/",
  asyncHandler(async (req, res) => {
    const category = new Category(req.body);
    await category.save();
    res.json({ success: true, message: "Category created", data: category });
  })
);

// Update category
router.put(
  "/:id",
  asyncHandler(async (req, res) => {
    const category = await Category.findByIdAndUpdate(req.params.id, req.body, { new: true });
    if (!category) {
      return res.status(404).json({ success: false, message: "Category not found", data: null });
    }
    res.json({ success: true, message: "Category updated", data: category });
  })
);

// Delete category
router.delete(
  "/:id",
  asyncHandler(async (req, res) => {
    const category = await Category.findByIdAndDelete(req.params.id);
    if (!category) {
      return res.status(404).json({ success: false, message: "Category not found", data: null });
    }
    res.json({ success: true, message: "Category deleted", data: null });
  })
);

module.exports = router;


