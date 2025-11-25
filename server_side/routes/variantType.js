const express = require("express");
const router = express.Router();
const asyncHandler = require("express-async-handler");
const VariantType = require("../model/variantType");

// Get all variant types
router.get(
  "/",
  asyncHandler(async (req, res) => {
    const variantTypes = await VariantType.find().sort({ createdAt: -1 });
    res.json({ success: true, message: "VariantTypes fetched", data: variantTypes });
  })
);

// Get single variant type
router.get(
  "/:id",
  asyncHandler(async (req, res) => {
    const variantType = await VariantType.findById(req.params.id);
    if (!variantType) {
      return res.status(404).json({ success: false, message: "VariantType not found", data: null });
    }
    res.json({ success: true, message: "VariantType fetched", data: variantType });
  })
);

// Create variant type
router.post(
  "/",
  asyncHandler(async (req, res) => {
    const variantType = new VariantType(req.body);
    await variantType.save();
    res.json({ success: true, message: "VariantType created", data: variantType });
  })
);

// Update variant type
router.put(
  "/:id",
  asyncHandler(async (req, res) => {
    const variantType = await VariantType.findByIdAndUpdate(req.params.id, req.body, { new: true });
    if (!variantType) {
      return res.status(404).json({ success: false, message: "VariantType not found", data: null });
    }
    res.json({ success: true, message: "VariantType updated", data: variantType });
  })
);

// Delete variant type
router.delete(
  "/:id",
  asyncHandler(async (req, res) => {
    const variantType = await VariantType.findByIdAndDelete(req.params.id);
    if (!variantType) {
      return res.status(404).json({ success: false, message: "VariantType not found", data: null });
    }
    res.json({ success: true, message: "VariantType deleted", data: null });
  })
);

module.exports = router;


