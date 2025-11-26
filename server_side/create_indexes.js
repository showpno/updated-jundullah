// =============================================================================
// Jundullah E-Commerce - Database Index Creation Script
// =============================================================================
// Purpose: Create all recommended indexes for optimal database performance
// Database: jundullah_db
// Run with: mongosh jundullah_db create_indexes.js
// =============================================================================

print("\n🔧 Starting Index Creation for Jundullah E-Commerce Database");
print("=" .repeat(70));

// Switch to database
use jundullah_db;

// =============================================================================
// USER COLLECTION INDEXES
// =============================================================================
print("\n📁 Creating User Collection Indexes...");

db.users.createIndex({ email: 1 }, { 
  unique: true, 
  name: "idx_users_email_unique" 
});
print("  ✅ Created unique index on email");

db.users.createIndex({ role: 1 }, { 
  name: "idx_users_role" 
});
print("  ✅ Created index on role");

db.users.createIndex({ isActive: 1 }, { 
  name: "idx_users_isActive" 
});
print("  ✅ Created index on isActive");

db.users.createIndex({ createdAt: -1 }, { 
  name: "idx_users_createdAt" 
});
print("  ✅ Created index on createdAt");

// =============================================================================
// PRODUCT COLLECTION INDEXES
// =============================================================================
print("\n📦 Creating Product Collection Indexes...");

db.products.createIndex(
  { proCategoryId: 1, isActive: 1, price: 1 }, 
  { name: "idx_products_category_active_price" }
);
print("  ✅ Created compound index on proCategoryId, isActive, price");

db.products.createIndex(
  { proBrandId: 1, isActive: 1 }, 
  { name: "idx_products_brand_active" }
);
print("  ✅ Created compound index on proBrandId, isActive");

db.products.createIndex(
  { name: "text", description: "text" }, 
  { name: "idx_products_text_search" }
);
print("  ✅ Created text index on name and description");

db.products.createIndex({ isActive: 1 }, { 
  name: "idx_products_isActive" 
});
print("  ✅ Created index on isActive");

db.products.createIndex({ price: 1 }, { 
  name: "idx_products_price" 
});
print("  ✅ Created index on price");

db.products.createIndex({ createdAt: -1 }, { 
  name: "idx_products_createdAt" 
});
print("  ✅ Created index on createdAt");

// Support for new field names
db.products.createIndex({ category: 1 }, { 
  name: "idx_products_category" 
});
print("  ✅ Created index on category (new naming)");

db.products.createIndex({ brand: 1 }, { 
  name: "idx_products_brand" 
});
print("  ✅ Created index on brand (new naming)");

// =============================================================================
// CATEGORY COLLECTION INDEXES
// =============================================================================
print("\n🏷️  Creating Category Collection Indexes...");

db.categories.createIndex({ name: 1 }, { 
  unique: true, 
  name: "idx_categories_name_unique" 
});
print("  ✅ Created unique index on name");

// =============================================================================
// SUBCATEGORY COLLECTION INDEXES
// =============================================================================
print("\n🏷️  Creating SubCategory Collection Indexes...");

db.subcategories.createIndex(
  { category: 1, name: 1 }, 
  { unique: true, name: "idx_subcategories_category_name_unique" }
);
print("  ✅ Created compound unique index on category, name");

db.subcategories.createIndex({ category: 1 }, { 
  name: "idx_subcategories_category" 
});
print("  ✅ Created index on category");

// =============================================================================
// BRAND COLLECTION INDEXES
// =============================================================================
print("\n🔖 Creating Brand Collection Indexes...");

db.brands.createIndex({ name: 1 }, { 
  unique: true, 
  name: "idx_brands_name_unique" 
});
print("  ✅ Created unique index on name");

// =============================================================================
// ORDER COLLECTION INDEXES
// =============================================================================
print("\n🛒 Creating Order Collection Indexes...");

db.orders.createIndex(
  { user: 1, createdAt: -1 }, 
  { name: "idx_orders_user_createdAt" }
);
print("  ✅ Created compound index on user, createdAt");

db.orders.createIndex(
  { orderStatus: 1, createdAt: -1 }, 
  { name: "idx_orders_status_createdAt" }
);
print("  ✅ Created compound index on orderStatus, createdAt");

db.orders.createIndex({ paymentStatus: 1 }, { 
  name: "idx_orders_paymentStatus" 
});
print("  ✅ Created index on paymentStatus");

db.orders.createIndex({ user: 1 }, { 
  name: "idx_orders_user" 
});
print("  ✅ Created index on user");

db.orders.createIndex({ createdAt: -1 }, { 
  name: "idx_orders_createdAt" 
});
print("  ✅ Created index on createdAt");

// =============================================================================
// VARIANT COLLECTION INDEXES
// =============================================================================
print("\n🎨 Creating Variant Collection Indexes...");

db.variants.createIndex(
  { variantType: 1, name: 1 }, 
  { name: "idx_variants_type_name" }
);
print("  ✅ Created compound index on variantType, name");

db.variants.createIndex({ variantType: 1 }, { 
  name: "idx_variants_type" 
});
print("  ✅ Created index on variantType");

// =============================================================================
// VARIANT TYPE COLLECTION INDEXES
// =============================================================================
print("\n📐 Creating VariantType Collection Indexes...");

db.varianttypes.createIndex({ name: 1 }, { 
  unique: true, 
  name: "idx_varianttypes_name_unique" 
});
print("  ✅ Created unique index on name");

// =============================================================================
// COUPON CODE COLLECTION INDEXES
// =============================================================================
print("\n🎫 Creating CouponCode Collection Indexes...");

db.couponcodes.createIndex({ code: 1 }, { 
  unique: true, 
  name: "idx_couponcodes_code_unique" 
});
print("  ✅ Created unique index on code");

db.couponcodes.createIndex(
  { isActive: 1, validFrom: 1, validUntil: 1 }, 
  { name: "idx_couponcodes_active_validity" }
);
print("  ✅ Created compound index on isActive, validFrom, validUntil");

db.couponcodes.createIndex({ isActive: 1 }, { 
  name: "idx_couponcodes_isActive" 
});
print("  ✅ Created index on isActive");

// =============================================================================
// NOTIFICATION COLLECTION INDEXES
// =============================================================================
print("\n🔔 Creating Notification Collection Indexes...");

db.notifications.createIndex(
  { user: 1, isSent: 1 }, 
  { name: "idx_notifications_user_sent" }
);
print("  ✅ Created compound index on user, isSent");

db.notifications.createIndex({ user: 1 }, { 
  name: "idx_notifications_user" 
});
print("  ✅ Created index on user");

db.notifications.createIndex({ isSent: 1 }, { 
  name: "idx_notifications_isSent" 
});
print("  ✅ Created index on isSent");

db.notifications.createIndex({ createdAt: -1 }, { 
  name: "idx_notifications_createdAt" 
});
print("  ✅ Created index on createdAt");

// =============================================================================
// POSTER COLLECTION INDEXES
// =============================================================================
print("\n🖼️  Creating Poster Collection Indexes...");

db.posters.createIndex(
  { isActive: 1, order: 1 }, 
  { name: "idx_posters_active_order" }
);
print("  ✅ Created compound index on isActive, order");

db.posters.createIndex({ isActive: 1 }, { 
  name: "idx_posters_isActive" 
});
print("  ✅ Created index on isActive");

db.posters.createIndex({ order: 1 }, { 
  name: "idx_posters_order" 
});
print("  ✅ Created index on order");

// =============================================================================
// VERIFICATION
// =============================================================================
print("\n");
print("=" .repeat(70));
print("🎯 Index Creation Summary");
print("=" .repeat(70));

const collections = [
  'users', 'products', 'categories', 'subcategories', 
  'brands', 'orders', 'variants', 'varianttypes', 
  'couponcodes', 'notifications', 'posters'
];

collections.forEach(collectionName => {
  const indexes = db.getCollection(collectionName).getIndexes();
  print(`\n${collectionName}: ${indexes.length} indexes`);
  indexes.forEach(index => {
    const keyStr = JSON.stringify(index.key);
    const uniqueStr = index.unique ? " [UNIQUE]" : "";
    print(`  - ${index.name}: ${keyStr}${uniqueStr}`);
  });
});

print("\n");
print("=" .repeat(70));
print("✅ All indexes created successfully!");
print("=" .repeat(70));
print("\n💡 Tips:");
print("  - Monitor index performance with: db.collection.explain('executionStats')");
print("  - Check index usage with: db.collection.aggregate([{$indexStats:{}}])");
print("  - Rebuild indexes if needed with: db.collection.reIndex()");
print("\n");
