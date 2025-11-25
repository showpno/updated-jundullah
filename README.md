# 🛍️ Jundullah Lifestyle - E-Commerce Platform

A complete e-commerce solution featuring a Flutter mobile application, web-based admin dashboard, and Node.js REST API backend.

---

## 📋 Overview

This project consists of three main components:

- **Client Side** - Flutter mobile app for Android/iOS
- **Admin Panel** - Flutter web dashboard for managing products, orders, and users
- **Server Side** - Node.js backend with MongoDB database

---

## 🚀 Quick Start

### Main Menu (Recommended)

```powershell
cd D:\Jundullah
.\RUN_PROJECT.ps1
```

**Menu Options:**
1. Run Client Side (Mobile App)
2. Run Admin Panel (Chrome)
3. Run Server (Backend)
4. Check Devices (Emulator/Phone)
5. Get Local IP Address

---

## 📱 Client Side Setup

### Automatic Device Detection

The application automatically detects and runs on:
- **Priority 1:** Connected Samsung phone (USB)
- **Priority 2:** Running Android emulator
- **Priority 3:** Auto-launches emulator if no device available

**No manual device selection required.**

### Running the Application

```powershell
# Option 1: Main menu
.\RUN_PROJECT.ps1  # Select option 1

# Option 2: Direct script
.\scripts\run_client.ps1

# Option 3: Client directory
cd D:\Jundullah\client_side && .\run.ps1
```

### Physical Device Configuration

1. **Get local IP address:**
   ```powershell
   .\scripts\get_local_ip.ps1
   ```

2. **Update server configuration:**
   - File: `client_side\lib\utility\server_config.dart`
   - Set: `static const String? manualPhysicalDeviceIP = '192.168.0.247';`

3. **Requirements:**
   - Phone and computer on same Wi-Fi network
   - USB Debugging enabled on phone
   - Computer authorized for USB debugging

**Note:** Emulator uses `10.0.2.2:5000` automatically. Initial screen is Login.

---

## 🖥️ Admin Panel

```powershell
# Option 1: Main menu
.\RUN_PROJECT.ps1  # Select option 2

# Option 2: Direct script
.\scripts\run_admin.ps1
```

Opens the admin dashboard in Chrome browser for managing products, orders, and user accounts.

---

## 🖥️ Server Setup

### Running the Server

```powershell
# Option 1: Main menu
.\RUN_PROJECT.ps1  # Select option 3

# Option 2: Direct script
.\scripts\run_server.ps1
```

### Initial Configuration

```powershell
cd D:\Jundullah\server_side
npm install
```

**Environment Variables (`.env`):**
```env
MONGO_URL=mongodb://127.0.0.1:27017/jundullah_db
PORT=5000
```

**Stop Server:**
```powershell
.\scripts\stop_server.ps1
```

**Server Access:** `http://localhost:5000`

---

## 🛠️ Helper Scripts

All scripts are located in the `scripts\` directory:

| Script | Description |
|--------|-------------|
| `run_client.ps1` | Launch mobile app with automatic device detection |
| `run_admin.ps1` | Open admin panel in Chrome browser |
| `run_server.ps1` | Start backend server (auto-installs dependencies) |
| `stop_server.ps1` | Terminate server process on port 5000 |
| `check_devices.ps1` | Display available Android devices |
| `get_local_ip.ps1` | Retrieve local Wi-Fi IP address |

---

## 📋 Prerequisites

- **Flutter SDK** (>=3.4.3) with Dart
- **Node.js** (v14 or higher) with npm
- **MongoDB** (running on port 27017)
- **Android Studio** (optional, for Android development)
- **Chrome Browser** (for admin panel)
- **PowerShell** (for running scripts)

---

## 🔧 Configuration

- **Server URL:** `http://localhost:5000`
- **Database:** MongoDB `jundullah_db`
- **Emulator:** Automatically uses `10.0.2.2:5000`
- **Physical Device:** Requires manual IP configuration

---

## 🔍 Troubleshooting

### Device Not Found
```powershell
.\scripts\check_devices.ps1
flutter emulators --launch Medium_Phone_API_36.1  # Manual emulator launch
```

### Server Connection Issues
- Verify server is running: `.\scripts\run_server.ps1`
- Check IP configuration in `server_config.dart`
- Ensure devices are on the same Wi-Fi network

### Port Already in Use
```powershell
.\scripts\stop_server.ps1
```

### Dependency Installation
```powershell
cd D:\Jundullah\client_side && flutter pub get
cd D:\Jundullah\admin_panel && flutter pub get
cd D:\Jundullah\server_side && npm install
```

---

## 📞 Support

For issues, verify:
1. Troubleshooting section above
2. MongoDB service is running
3. Network configuration
4. Server logs for errors

---

**Thanks from Jundullah family!**
