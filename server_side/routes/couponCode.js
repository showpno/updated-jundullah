const express = require("express");
const router = express.Router();
const asyncHandler = require("express-async-handler");
const CouponCode = require("../model/couponCode");

// Get all coupon codes
router.get(
  "/",
  asyncHandler(async (req, res) => {
    const couponCodes = await CouponCode.find().sort({ createdAt: -1 });
    res.json({ success: true, message: "CouponCodes fetched", data: couponCodes });
  })
);

// Get single coupon code
router.get(
  "/:id",
  asyncHandler(async (req, res) => {
    const couponCode = await CouponCode.findById(req.params.id);
    if (!couponCode) {
      return res.status(404).json({ success: false, message: "CouponCode not found", data: null });
    }
    res.json({ success: true, message: "CouponCode fetched", data: couponCode });
  })
);

// Validate coupon code
router.post(
  "/validate",
  asyncHandler(async (req, res) => {
    const { code, amount } = req.body;
    const couponCode = await CouponCode.findOne({ code: code.toUpperCase(), isActive: true });
    
    if (!couponCode) {
      return res.json({ success: false, message: "Invalid coupon code", data: null });
    }
    
    const now = new Date();
    if (now < couponCode.validFrom || now > couponCode.validUntil) {
      return res.json({ success: false, message: "Coupon code expired", data: null });
    }
    
    if (amount < couponCode.minPurchaseAmount) {
      return res.json({ success: false, message: `Minimum purchase amount is ${couponCode.minPurchaseAmount}`, data: null });
    }
    
    if (couponCode.usageLimit && couponCode.usedCount >= couponCode.usageLimit) {
      return res.json({ success: false, message: "Coupon code usage limit reached", data: null });
    }
    
    let discount = 0;
    if (couponCode.discountType === "percentage") {
      discount = (amount * couponCode.discountValue) / 100;
      if (couponCode.maxDiscountAmount) {
        discount = Math.min(discount, couponCode.maxDiscountAmount);
      }
    } else {
      discount = couponCode.discountValue;
    }
    
    res.json({ success: true, message: "Coupon code valid", data: { couponCode, discount } });
  })
);

// Create coupon code
router.post(
  "/",
  asyncHandler(async (req, res) => {
    const couponCode = new CouponCode(req.body);
    couponCode.code = couponCode.code.toUpperCase();
    await couponCode.save();
    res.json({ success: true, message: "CouponCode created", data: couponCode });
  })
);

// Update coupon code
router.put(
  "/:id",
  asyncHandler(async (req, res) => {
    if (req.body.code) req.body.code = req.body.code.toUpperCase();
    const couponCode = await CouponCode.findByIdAndUpdate(req.params.id, req.body, { new: true });
    if (!couponCode) {
      return res.status(404).json({ success: false, message: "CouponCode not found", data: null });
    }
    res.json({ success: true, message: "CouponCode updated", data: couponCode });
  })
);

// Delete coupon code
router.delete(
  "/:id",
  asyncHandler(async (req, res) => {
    const couponCode = await CouponCode.findByIdAndDelete(req.params.id);
    if (!couponCode) {
      return res.status(404).json({ success: false, message: "CouponCode not found", data: null });
    }
    res.json({ success: true, message: "CouponCode deleted", data: null });
  })
);

module.exports = router;


