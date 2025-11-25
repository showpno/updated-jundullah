const mongoose = require("mongoose");

const productSchema = new mongoose.Schema(
  {
    name: {
      type: String,
      required: false, // Make optional to match existing database
    },
    description: {
      type: String,
      default: "",
    },
    price: {
      type: Number,
      required: false, // Make optional to match existing database
    },
    offerPrice: {
      type: Number,
    },
    discountPrice: {
      type: Number,
      default: 0,
    },
    quantity: {
      type: Number,
      default: 0,
    },
    images: [
      {
        type: String,
      },
    ],
    // Support both old field names (from database) and new field names
    proCategoryId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Category",
    },
    proSubCategoryId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "SubCategory",
    },
    proBrandId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Brand",
    },
    proVariantTypeId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "VariantType",
    },
    proVariantId: [
      {
        type: mongoose.Schema.Types.ObjectId,
        ref: "Variant",
      },
    ],
    // Also support new field names (for backward compatibility)
    category: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Category",
    },
    subCategory: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "SubCategory",
    },
    brand: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Brand",
    },
    variants: [
      {
        variant: {
          type: mongoose.Schema.Types.ObjectId,
          ref: "Variant",
        },
        stock: {
          type: Number,
          default: 0,
        },
      },
    ],
    stock: {
      type: Number,
      default: 0,
    },
    isActive: {
      type: Boolean,
      default: true,
    },
  },
  {
    timestamps: true,
    collection: "products", // Explicitly set collection name
    strict: false, // Allow fields not defined in schema (to accept all database fields)
  }
);

module.exports = mongoose.model("Product", productSchema);


