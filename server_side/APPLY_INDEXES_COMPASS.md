# 🧭 Apply Database Indexes Using MongoDB Compass

## Method 1: Using Compass Built-in Shell (Recommended)

### Step 1: Open MongoDB Shell in Compass
1. Open **MongoDB Compass**
2. Connect to your database (already connected to `localhost:27017/jundullah_db`)
3. At the bottom of Compass, click on **`>_MONGOSH`** tab to open the MongoDB Shell

### Step 2: Copy and Run the Script
1. Open the file `create_indexes.js` in a text editor
2. **Copy the entire contents**
3. **Paste into the Mongosh terminal** at the bottom of Compass
4. Press **Enter** to execute

The script will create all indexes automatically and show progress.

---

## Method 2: Manual Index Creation (Alternative)

If you prefer to create indexes manually through the GUI:

### User Collection (`users`)

1. Click on **`users`** collection in Compass
2. Go to **Indexes** tab
3. Click **Create Index**
4. Add these indexes one by one:

#### Index 1: Email (Unique)
```json
{ "email": 1 }
```
**Options:** Check "Create unique index"

#### Index 2: Role
```json
{ "role": 1 }
```

#### Index 3: isActive
```json
{ "isActive": 1 }
```

---

### Product Collection (`products`)

#### Index 1: Category + Active + Price (Compound)
```json
{ "proCategoryId": 1, "isActive": 1, "price": 1 }
```

#### Index 2: Brand + Active (Compound)
```json
{ "proBrandId": 1, "isActive": 1 }
```

#### Index 3: Text Search
```json
{ "name": "text", "description": "text" }
```
**Options:** Select "text" type for both fields

#### Index 4: isActive
```json
{ "isActive": 1 }
```

#### Index 5: Price
```json
{ "price": 1 }
```

---

### Category Collection (`categories`)

#### Index 1: Name (Unique)
```json
{ "name": 1 }
```
**Options:** Check "Create unique index"

---

### SubCategory Collection (`subcategories`)

#### Index 1: Category + Name (Unique Compound)
```json
{ "category": 1, "name": 1 }
```
**Options:** Check "Create unique index"

#### Index 2: Category
```json
{ "category": 1 }
```

---

### Brand Collection (`brands`)

#### Index 1: Name (Unique)
```json
{ "name": 1 }
```
**Options:** Check "Create unique index"

---

### Order Collection (`orders`)

#### Index 1: User + Created Date (Compound)
```json
{ "user": 1, "createdAt": -1 }
```

#### Index 2: Order Status + Created Date (Compound)
```json
{ "orderStatus": 1, "createdAt": -1 }
```

#### Index 3: Payment Status
```json
{ "paymentStatus": 1 }
```

#### Index 4: User
```json
{ "user": 1 }
```

---

### Variant Collection (`variants`)

#### Index 1: Variant Type + Name (Compound)
```json
{ "variantType": 1, "name": 1 }
```

#### Index 2: Variant Type
```json
{ "variantType": 1 }
```

---

### VariantType Collection (`varianttypes`)

#### Index 1: Name (Unique)
```json
{ "name": 1 }
```
**Options:** Check "Create unique index"

---

### CouponCode Collection (`couponcodes`)

#### Index 1: Code (Unique)
```json
{ "code": 1 }
```
**Options:** Check "Create unique index"

#### Index 2: Active + Validity (Compound)
```json
{ "isActive": 1, "validFrom": 1, "validUntil": 1 }
```

#### Index 3: isActive
```json
{ "isActive": 1 }
```

---

### Notification Collection (`notifications`)

#### Index 1: User + Sent (Compound)
```json
{ "user": 1, "isSent": 1 }
```

#### Index 2: User
```json
{ "user": 1 }
```

#### Index 3: isSent
```json
{ "isSent": 1 }
```

---

### Poster Collection (`posters`)

#### Index 1: Active + Order (Compound)
```json
{ "isActive": 1, "order": 1 }
```

#### Index 2: isActive
```json
{ "isActive": 1 }
```

#### Index 3: Order
```json
{ "order": 1 }
```

---

## Verification

After creating indexes, verify they exist:

1. Select any collection
2. Go to **Indexes** tab
3. You should see the newly created indexes

---

## Quick Guide Images

### Opening MongoDB Shell in Compass

Look for the **`>_MONGOSH`** button at the bottom of Compass window:

```
┌─────────────────────────────────────────┐
│  MongoDB Compass - jundullah_db         │
│─────────────────────────────────────────│
│  Collections  |  Indexes  |  Schema     │
│                                          │
│  [Collection content here]               │
│                                          │
│─────────────────────────────────────────│
│  >_MONGOSH  [Click here to open shell]  │
└─────────────────────────────────────────┘
```

---

## Recommendation

**Use Method 1** (Built-in Shell) - It's much faster than creating 40+ indexes manually!

Just:
1. Open Mongosh in Compass
2. Copy/paste the `create_indexes.js` content
3. Press Enter

Done! ✅
