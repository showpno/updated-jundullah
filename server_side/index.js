const express = require("express");
const bodyParser = require("body-parser");
const cors = require("cors");
const mongoose = require("mongoose");
const asyncHandler = require("express-async-handler");
const dotenv = require("dotenv");
dotenv.config();

const app = express();

// Middle wair
app.use(cors({ origin: "*" }));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

// Setting static folder paths
app.use("/image/products", express.static("public/products"));
app.use("/image/category", express.static("public/category"));
app.use("/image/poster", express.static("public/posters"));

// Connect to MongoDB
const URL = process.env.MONGO_URL || "mongodb://127.0.0.1:27017/jundullah_db";

console.log(`\n📦 Connecting to MongoDB...`);
console.log(`   Database: ${URL.split('/').pop()}`);
console.log(`   Host: ${URL.split('//')[1]?.split('/')[0] || '127.0.0.1:27017'}\n`);

mongoose.connect(URL);

const db = mongoose.connection;

db.on("error", (error) => {
  console.error("\n❌ MongoDB Connection Error:");
  console.error(error);
  console.error("\n💡 Troubleshooting:");
  console.error("   1. Make sure MongoDB is running (check MongoDB Compass or service)");
  console.error("   2. Verify the connection URL in .env file");
  console.error("   3. Check if port 27017 is accessible\n");
});

db.on("connecting", () => {
  console.log("⏳ Connecting to MongoDB...");
});

db.on("connected", () => {
  console.log(`✅ Successfully connected to MongoDB!`);
  console.log(`   Database: ${db.name}`);
  console.log(`   Collections: ${Object.keys(db.collections).length} available\n`);
});

db.once("open", () => {
  console.log("🚀 Database connection is ready!");
  console.log(`   Ready to accept requests\n`);
});

db.on("disconnected", () => {
  console.log("\n⚠️  MongoDB disconnected");
  console.log("   Attempting to reconnect...\n");
});

// Handle application termination
process.on("SIGINT", async () => {
  await mongoose.connection.close();
  console.log("\n👋 MongoDB connection closed due to application termination");
  process.exit(0);
});

// Routes
app.use("/categories", require("./routes/category"));
app.use("/subCategories", require("./routes/subCategory"));
app.use("/brands", require("./routes/brand"));
app.use("/variantTypes", require("./routes/variantType"));
app.use("/variants", require("./routes/variant"));
app.use("/products", require("./routes/product"));
app.use("/couponCodes", require("./routes/couponCode"));
app.use("/posters", require("./routes/poster"));
app.use("/users", require("./routes/user"));
app.use("/orders", require("./routes/order"));
app.use("/payment", require("./routes/payment"));
app.use("/notification", require("./routes/notification"));

// Example route using asyncHandler directly in app.js
app.get(
  "/",
  asyncHandler(async (req, res) => {
    res.json({
      success: true,
      message: "API working successfully",
      data: null,
    });
  })
);

// Global error handler
app.use((error, req, res, next) => {
  res.status(500).json({ success: false, message: error.message, data: null });
});

const PORT = process.env.PORT || 5000;

app.listen(PORT, () => {
  console.log(`\n🌐 Server running on port ${PORT}`);
  console.log(`   Local:   http://localhost:${PORT}`);
  
  // Get local IP for network access
  const os = require('os');
  const networkInterfaces = os.networkInterfaces();
  const localIP = Object.values(networkInterfaces)
    .flat()
    .find(iface => iface.family === 'IPv4' && !iface.internal)?.address;
  
  if (localIP) {
    console.log(`   Network: http://${localIP}:${PORT}`);
  }
  console.log(`   API:     http://localhost:${PORT}/\n`);
}).on('error', (err) => {
  if (err.code === 'EADDRINUSE') {
    console.error(`\n❌ Error: Port ${PORT} is already in use.`);
    console.error(`Please either:`);
    console.error(`  1. Stop the other process using port ${PORT}`);
    console.error(`  2. Change the PORT in your .env file`);
    console.error(`\nTo find the process using port ${PORT}, run:`);
    console.error(`  netstat -ano | findstr :${PORT}`);
    console.error(`Then kill it with: taskkill /PID <PID> /F\n`);
  } else {
    console.error('Server error:', err);
  }
  process.exit(1);
});

