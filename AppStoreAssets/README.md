# App Store Assets - SwiftQuantum

## Required Assets for App Store Connect

### 1. App Icon (Required)
| Asset | Size | Status |
|-------|------|--------|
| App Icon | 1024x1024 px | ✅ Ready |

Location: `AppIcon/AppIcon.png`

---

### 2. Screenshots (Required)

#### iPhone Screenshots (Required: at least 6.5" OR 6.7")

| Device | Resolution | Folder |
|--------|------------|--------|
| iPhone 6.7" (iPhone 15 Pro Max, 14 Pro Max) | **1290 x 2796** px | `Screenshots/iPhone_6.7/` |
| iPhone 6.5" (iPhone 11 Pro Max, XS Max) | **1284 x 2778** px | `Screenshots/iPhone_6.5/` |
| iPhone 5.5" (iPhone 8 Plus, 7 Plus) | **1242 x 2208** px | `Screenshots/iPhone_5.5/` |

#### iPad Screenshots (Required if supporting iPad)

| Device | Resolution | Folder |
|--------|------------|--------|
| iPad Pro 12.9" (6th gen) | **2048 x 2732** px | `Screenshots/iPad_12.9/` |
| iPad Pro 11" | **1668 x 2388** px | `Screenshots/iPad_11/` |

**Note:** You need 1-10 screenshots per device size. Recommended: 3-5 screenshots.

---

### 3. Screenshot Naming Convention

```
01_LabHub.png
02_Presets.png
03_Bridge.png
04_Premium.png
05_Settings.png
```

---

### 4. App Preview Videos (Optional)

| Device | Resolution | Duration |
|--------|------------|----------|
| iPhone 6.7" | 1290 x 2796 | 15-30 sec |
| iPad 12.9" | 2048 x 2732 | 15-30 sec |

Format: H.264, MP4, 30fps

---

### 5. How to Take Screenshots

#### Using Simulator:
1. Open Xcode → Window → Devices and Simulators
2. Select iPhone 15 Pro Max (for 6.7")
3. Run the app
4. Press `Cmd + S` to take screenshot
5. Screenshot saves to Desktop

#### Using Physical Device:
1. Press `Side Button + Volume Up` simultaneously
2. Transfer to Mac via AirDrop

---

### 6. Checklist

- [ ] iPhone 6.7" screenshots (1290x2796) - Required
- [ ] iPhone 6.5" screenshots (1284x2778) - Optional fallback
- [ ] iPhone 5.5" screenshots (1242x2208) - Optional for older devices
- [ ] iPad 12.9" screenshots (2048x2732) - Required if iPad support
- [ ] iPad 11" screenshots (1668x2388) - Optional
- [ ] App Preview video - Optional but recommended

---

### 7. Screenshot Content Suggestions

1. **Lab Hub** - Main quantum circuit builder
2. **Presets** - Pre-built quantum circuits
3. **Bridge** - Backend connection features
4. **Premium Features** - Subscription benefits
5. **Settings/More** - App customization

---

## App Store Connect Additional Requirements

### App Information
- **App Name:** SwiftQuantum
- **Subtitle:** Quantum Computing on iOS
- **Category:** Education / Developer Tools
- **Age Rating:** 4+

### Keywords (100 chars max)
```
quantum,computing,qubit,superposition,simulator,physics,education,circuit,apple,swift
```

### Description (4000 chars max)
See `AppStoreDescription.txt` for full description.

### Support URL
Required for submission.

### Privacy Policy URL
Required for apps with subscriptions.
