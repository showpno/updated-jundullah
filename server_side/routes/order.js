const express = require("express");
const router = express.Router();
const asyncHandler = require("express-async-handler");
const Order = require("../model/order");

// Get all orders
router.get(
  "/",
  asyncHandler(async (req, res) => {
    const { userId } = req.query;
    let query = {};
    if (userId) query.user = userId;
    
    const orders = await Order.find(query)
      .populate("user", "name email")
      .populate("items.product")
      .populate("items.variant")
      .populate("couponCode")
      .sort({ createdAt: -1 });
    res.json({ success: true, message: "Orders fetched", data: orders });
  })
);

// Get single order
router.get(
  "/:id",
  asyncHandler(async (req, res) => {
    const order = await Order.findById(req.params.id)
      .populate("user", "name email")
      .populate("items.product")
      .populate("items.variant")
      .populate("couponCode");
    if (!order) {
      return res.status(404).json({ success: false, message: "Order not found", data: null });
    }
    res.json({ success: true, message: "Order fetched", data: order });
  })
);

// Create order
router.post(
  "/",
  asyncHandler(async (req, res) => {
    const order = new Order(req.body);
    await order.save();
    const populatedOrder = await Order.findById(order._id)
      .populate("user", "name email")
      .populate("items.product")
      .populate("items.variant");
    res.json({ success: true, message: "Order created", data: populatedOrder });
  })
);

// Update order
router.put(
  "/:id",
  asyncHandler(async (req, res) => {
    const order = await Order.findByIdAndUpdate(req.params.id, req.body, { new: true })
      .populate("user", "name email")
      .populate("items.product")
      .populate("items.variant");
    if (!order) {
      return res.status(404).json({ success: false, message: "Order not found", data: null });
    }
    res.json({ success: true, message: "Order updated", data: order });
  })
);

// Delete order
router.delete(
  "/:id",
  asyncHandler(async (req, res) => {
    const order = await Order.findByIdAndDelete(req.params.id);
    if (!order) {
      return res.status(404).json({ success: false, message: "Order not found", data: null });
    }
    res.json({ success: true, message: "Order deleted", data: null });
  })
);

module.exports = router;


