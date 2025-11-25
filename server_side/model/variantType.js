const mongoose = require("mongoose");

const variantTypeSchema = new mongoose.Schema(
  {
    name: {
      type: String,
      required: true,
      unique: true,
    },
    values: [
      {
        type: String,
      },
    ],
  },
  {
    timestamps: true,
    collection: "varianttypes", // Explicitly set collection name
  }
);

module.exports = mongoose.model("VariantType", variantTypeSchema);


