const mongoose = require("mongoose");

const brandSchema = new mongoose.Schema(
  {
    name: {
      type: String,
      required: true,
      unique: true,
    },
    description: {
      type: String,
    },
  },
  {
    timestamps: true,
    collection: "brands", // Explicitly set collection name
  }
);

module.exports = mongoose.model("Brand", brandSchema);


