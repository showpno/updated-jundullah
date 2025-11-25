const express = require("express");
const router = express.Router();
const asyncHandler = require("express-async-handler");
const User = require("../model/user");

// Register user
router.post(
  "/register",
  asyncHandler(async (req, res) => {
    const { email } = req.body;
    const existingUser = await User.findOne({ email });
    if (existingUser) {
      return res.status(400).json({ success: false, message: "User already exists", data: null });
    }
    const user = new User(req.body);
    await user.save();
    user.password = undefined;
    res.json({ success: true, message: "User registered", data: user });
  })
);

// Login user
router.post(
  "/login",
  asyncHandler(async (req, res) => {
    const { email, password } = req.body;
    const user = await User.findOne({ email });
    if (!user || !(await user.comparePassword(password))) {
      return res.status(401).json({ success: false, message: "Invalid credentials", data: null });
    }
    if (!user.isActive) {
      return res.status(403).json({ success: false, message: "Account is deactivated", data: null });
    }
    user.password = undefined;
    res.json({ success: true, message: "Login successful", data: user });
  })
);

// Get all users (admin)
router.get(
  "/",
  asyncHandler(async (req, res) => {
    const users = await User.find().select("-password").sort({ createdAt: -1 });
    res.json({ success: true, message: "Users fetched", data: users });
  })
);

// Get single user
router.get(
  "/:id",
  asyncHandler(async (req, res) => {
    const user = await User.findById(req.params.id).select("-password");
    if (!user) {
      return res.status(404).json({ success: false, message: "User not found", data: null });
    }
    res.json({ success: true, message: "User fetched", data: user });
  })
);

// Update user
router.put(
  "/:id",
  asyncHandler(async (req, res) => {
    if (req.body.password) {
      delete req.body.password; // Password should be updated separately
    }
    const user = await User.findByIdAndUpdate(req.params.id, req.body, { new: true }).select("-password");
    if (!user) {
      return res.status(404).json({ success: false, message: "User not found", data: null });
    }
    res.json({ success: true, message: "User updated", data: user });
  })
);

// Delete user
router.delete(
  "/:id",
  asyncHandler(async (req, res) => {
    const user = await User.findByIdAndDelete(req.params.id);
    if (!user) {
      return res.status(404).json({ success: false, message: "User not found", data: null });
    }
    res.json({ success: true, message: "User deleted", data: null });
  })
);

module.exports = router;


