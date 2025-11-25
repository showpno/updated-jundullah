const express = require("express");
const router = express.Router();
const asyncHandler = require("express-async-handler");
const Notification = require("../model/notification");
const User = require("../model/user");

// Get all notifications
router.get(
  "/",
  asyncHandler(async (req, res) => {
    const { userId } = req.query;
    let query = {};
    if (userId) query.user = userId;
    
    const notifications = await Notification.find(query)
      .populate("user", "name email")
      .sort({ createdAt: -1 });
    res.json({ success: true, message: "Notifications fetched", data: notifications });
  })
);

// Get single notification
router.get(
  "/:id",
  asyncHandler(async (req, res) => {
    const notification = await Notification.findById(req.params.id).populate("user", "name email");
    if (!notification) {
      return res.status(404).json({ success: false, message: "Notification not found", data: null });
    }
    res.json({ success: true, message: "Notification fetched", data: notification });
  })
);

// Create notification
router.post(
  "/",
  asyncHandler(async (req, res) => {
    const notification = new Notification(req.body);
    await notification.save();
    
    // Send notification via OneSignal if user has oneSignalId
    if (notification.user) {
      const user = await User.findById(notification.user);
      if (user && user.oneSignalId) {
        // OneSignal push notification logic would go here
        notification.isSent = true;
        notification.sentAt = new Date();
        await notification.save();
      }
    }
    
    res.json({ success: true, message: "Notification created", data: notification });
  })
);

// Update notification
router.put(
  "/:id",
  asyncHandler(async (req, res) => {
    const notification = await Notification.findByIdAndUpdate(req.params.id, req.body, { new: true })
      .populate("user", "name email");
    if (!notification) {
      return res.status(404).json({ success: false, message: "Notification not found", data: null });
    }
    res.json({ success: true, message: "Notification updated", data: notification });
  })
);

// Delete notification
router.delete(
  "/:id",
  asyncHandler(async (req, res) => {
    const notification = await Notification.findByIdAndDelete(req.params.id);
    if (!notification) {
      return res.status(404).json({ success: false, message: "Notification not found", data: null });
    }
    res.json({ success: true, message: "Notification deleted", data: null });
  })
);

module.exports = router;


