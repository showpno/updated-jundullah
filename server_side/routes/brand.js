const express = require("express");
const router = express.Router();
const asyncHandler = require("express-async-handler");
const Brand = require("../model/brand");

// Get all brands
router.get(
  "/",
  asyncHandler(async (req, res) => {
    const brands = await Brand.find().sort({ createdAt: -1 });
    res.json({ success: true, message: "Brands fetched", data: brands });
  })
);

// Get single brand
router.get(
  "/:id",
  asyncHandler(async (req, res) => {
    const brand = await Brand.findById(req.params.id);
    if (!brand) {
      return res.status(404).json({ success: false, message: "Brand not found", data: null });
    }
    res.json({ success: true, message: "Brand fetched", data: brand });
  })
);

// Create brand
router.post(
  "/",
  asyncHandler(async (req, res) => {
    const brand = new Brand(req.body);
    await brand.save();
    res.json({ success: true, message: "Brand created", data: brand });
  })
);

// Update brand
router.put(
  "/:id",
  asyncHandler(async (req, res) => {
    const brand = await Brand.findByIdAndUpdate(req.params.id, req.body, { new: true });
    if (!brand) {
      return res.status(404).json({ success: false, message: "Brand not found", data: null });
    }
    res.json({ success: true, message: "Brand updated", data: brand });
  })
);

// Delete brand
router.delete(
  "/:id",
  asyncHandler(async (req, res) => {
    const brand = await Brand.findByIdAndDelete(req.params.id);
    if (!brand) {
      return res.status(404).json({ success: false, message: "Brand not found", data: null });
    }
    res.json({ success: true, message: "Brand deleted", data: null });
  })
);

module.exports = router;


