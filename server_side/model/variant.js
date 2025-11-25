const mongoose = require("mongoose");

const variantSchema = new mongoose.Schema(
  {
    name: {
      type: String,
      required: true,
    },
    variantType: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "VariantType",
      required: true,
    },
    value: {
      type: String,
      required: true,
    },
  },
  {
    timestamps: true,
    collection: "variants", // Explicitly set collection name
  }
);

module.exports = mongoose.model("Variant", variantSchema);


