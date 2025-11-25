const express = require("express");
const router = express.Router();
const asyncHandler = require("express-async-handler");
const Variant = require("../model/variant");

// Get all variants
router.get(
  "/",
  asyncHandler(async (req, res) => {
    const variants = await Variant.find().populate("variantType").sort({ createdAt: -1 });
    res.json({ success: true, message: "Variants fetched", data: variants });
  })
);

// Get single variant
router.get(
  "/:id",
  asyncHandler(async (req, res) => {
    const variant = await Variant.findById(req.params.id).populate("variantType");
    if (!variant) {
      return res.status(404).json({ success: false, message: "Variant not found", data: null });
    }
    res.json({ success: true, message: "Variant fetched", data: variant });
  })
);

// Create variant
router.post(
  "/",
  asyncHandler(async (req, res) => {
    const variant = new Variant(req.body);
    await variant.save();
    res.json({ success: true, message: "Variant created", data: variant });
  })
);

// Update variant
router.put(
  "/:id",
  asyncHandler(async (req, res) => {
    const variant = await Variant.findByIdAndUpdate(req.params.id, req.body, { new: true }).populate("variantType");
    if (!variant) {
      return res.status(404).json({ success: false, message: "Variant not found", data: null });
    }
    res.json({ success: true, message: "Variant updated", data: variant });
  })
);

// Delete variant
router.delete(
  "/:id",
  asyncHandler(async (req, res) => {
    const variant = await Variant.findByIdAndDelete(req.params.id);
    if (!variant) {
      return res.status(404).json({ success: false, message: "Variant not found", data: null });
    }
    res.json({ success: true, message: "Variant deleted", data: null });
  })
);

module.exports = router;


