const express = require("express");
const router = express.Router();
const asyncHandler = require("express-async-handler");
const SubCategory = require("../model/subCategory");

// Get all subcategories
router.get(
  "/",
  asyncHandler(async (req, res) => {
    const subCategories = await SubCategory.find().populate("category").sort({ createdAt: -1 });
    res.json({ success: true, message: "SubCategories fetched", data: subCategories });
  })
);

// Get subcategories by category
router.get(
  "/category/:categoryId",
  asyncHandler(async (req, res) => {
    const subCategories = await SubCategory.find({ category: req.params.categoryId }).populate("category");
    res.json({ success: true, message: "SubCategories fetched", data: subCategories });
  })
);

// Get single subcategory
router.get(
  "/:id",
  asyncHandler(async (req, res) => {
    const subCategory = await SubCategory.findById(req.params.id).populate("category");
    if (!subCategory) {
      return res.status(404).json({ success: false, message: "SubCategory not found", data: null });
    }
    res.json({ success: true, message: "SubCategory fetched", data: subCategory });
  })
);

// Create subcategory
router.post(
  "/",
  asyncHandler(async (req, res) => {
    const subCategory = new SubCategory(req.body);
    await subCategory.save();
    res.json({ success: true, message: "SubCategory created", data: subCategory });
  })
);

// Update subcategory
router.put(
  "/:id",
  asyncHandler(async (req, res) => {
    const subCategory = await SubCategory.findByIdAndUpdate(req.params.id, req.body, { new: true }).populate("category");
    if (!subCategory) {
      return res.status(404).json({ success: false, message: "SubCategory not found", data: null });
    }
    res.json({ success: true, message: "SubCategory updated", data: subCategory });
  })
);

// Delete subcategory
router.delete(
  "/:id",
  asyncHandler(async (req, res) => {
    const subCategory = await SubCategory.findByIdAndDelete(req.params.id);
    if (!subCategory) {
      return res.status(404).json({ success: false, message: "SubCategory not found", data: null });
    }
    res.json({ success: true, message: "SubCategory deleted", data: null });
  })
);

module.exports = router;


