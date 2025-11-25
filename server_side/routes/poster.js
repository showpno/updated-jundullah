const express = require("express");
const router = express.Router();
const asyncHandler = require("express-async-handler");
const Poster = require("../model/poster");

// Get all active posters
router.get(
  "/",
  asyncHandler(async (req, res) => {
    const posters = await Poster.find({ isActive: true }).sort({ order: 1, createdAt: -1 });
    res.json({ success: true, message: "Posters fetched", data: posters });
  })
);

// Get all posters (admin)
router.get(
  "/all",
  asyncHandler(async (req, res) => {
    const posters = await Poster.find().sort({ order: 1, createdAt: -1 });
    res.json({ success: true, message: "Posters fetched", data: posters });
  })
);

// Get single poster
router.get(
  "/:id",
  asyncHandler(async (req, res) => {
    const poster = await Poster.findById(req.params.id);
    if (!poster) {
      return res.status(404).json({ success: false, message: "Poster not found", data: null });
    }
    res.json({ success: true, message: "Poster fetched", data: poster });
  })
);

// Create poster
router.post(
  "/",
  asyncHandler(async (req, res) => {
    const poster = new Poster(req.body);
    await poster.save();
    res.json({ success: true, message: "Poster created", data: poster });
  })
);

// Update poster
router.put(
  "/:id",
  asyncHandler(async (req, res) => {
    const poster = await Poster.findByIdAndUpdate(req.params.id, req.body, { new: true });
    if (!poster) {
      return res.status(404).json({ success: false, message: "Poster not found", data: null });
    }
    res.json({ success: true, message: "Poster updated", data: poster });
  })
);

// Delete poster
router.delete(
  "/:id",
  asyncHandler(async (req, res) => {
    const poster = await Poster.findByIdAndDelete(req.params.id);
    if (!poster) {
      return res.status(404).json({ success: false, message: "Poster not found", data: null });
    }
    res.json({ success: true, message: "Poster deleted", data: null });
  })
);

module.exports = router;


