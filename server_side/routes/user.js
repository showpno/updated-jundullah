const express = require("express");
const router = express.Router();
const asyncHandler = require("express-async-handler");
const User = require("../model/user");

// Register user
router.post(
  "/register",
  asyncHandler(async (req, res) => {
    // Client sends 'name' field with email value (see user_provider.dart line 83)
    // Get email from 'name' field since that's what client sends
    const emailValue = (req.body.name || req.body.email || "").toLowerCase().trim();
    
    if (!emailValue) {
      return res.status(400).json({ 
        success: false, 
        message: "Email is required", 
        data: null 
      });
    }

    // Check if user exists - check both 'name' and 'email' fields separately
    // Old users have email in 'name' field, new users will have 'email' field
    const existingByEmail = await User.findOne({ email: emailValue });
    const existingByName = await User.findOne({ name: emailValue });
    
    if (existingByEmail || existingByName) {
      // Log which field matched for debugging
      const matchedField = existingByEmail ? 'email' : 'name';
      const matchedId = existingByEmail?._id || existingByName?._id;
      console.log(`Registration blocked: User with ${emailValue} exists (matched by ${matchedField}, _id: ${matchedId})`);
      
      return res.status(400).json({ 
        success: false, 
        message: "User already exists", 
        data: null 
      });
    }

    // Create user with both name and email fields set
    const userData = {
      ...req.body,
      name: emailValue, // Set name field
      email: emailValue, // Set email field (model requires this)
    };

    try {
      const user = new User(userData);
      await user.save();
      user.password = undefined;
      console.log(`User registered successfully: ${emailValue}`);
      res.json({ success: true, message: "User registered", data: user });
    } catch (error) {
      // Handle unique constraint errors
      if (error.code === 11000) {
        console.log(`Registration failed: Duplicate key error for ${emailValue}`);
        return res.status(400).json({ 
          success: false, 
          message: "User already exists", 
          data: null 
        });
      }
      // Handle validation errors
      if (error.name === 'ValidationError') {
        console.log(`Registration failed: Validation error for ${emailValue}:`, error.message);
        return res.status(400).json({ 
          success: false, 
          message: error.message, 
          data: null 
        });
      }
      throw error; // Re-throw other errors
    }
  })
);

// Login user
router.post(
  "/login",
  asyncHandler(async (req, res) => {
    // Client sends 'name' field with email value (see user_provider.dart line 39)
    // Get email from 'name' field since that's what client sends
    const emailValue = (req.body.name || req.body.email || "").toLowerCase().trim();
    const { password } = req.body;
    
    if (!emailValue) {
      return res.status(400).json({ 
        success: false, 
        message: "Email is required", 
        data: null 
      });
    }

    // Find user by checking both 'name' and 'email' fields
    // Old users have email in 'name' field, new users will have 'email' field
    const user = await User.findOne({ 
      $or: [
        { email: emailValue },
        { name: emailValue }
      ]
    });
    
    if (!user || !(await user.comparePassword(password))) {
      return res.status(401).json({ 
        success: false, 
        message: "Invalid credentials", 
        data: null 
      });
    }
    if (!user.isActive) {
      return res.status(403).json({ 
        success: false, 
        message: "Account is deactivated", 
        data: null 
      });
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


