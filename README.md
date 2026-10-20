# Pharmase Employee (`pharmace_emp`)

A modern, role-based Flutter desktop and mobile application designed for pharmacy employee management, point-of-sale activities, inventory tracking, and operational tasks.

---

## 🚀 Key Features

### 🔐 Authentication & Onboarding
* **Role-Based Login**: Secure employee authentication with JWT token handling (`flutter_secure_storage` & `jwt_decoder`).
* **Staff Registration**: Easy onboarding using QR Code scanning (`mobile_scanner`) and invite codes.
* **Auto-Session Expiration**: Automatic token verification on application startup.

### 👥 Role-Based Access Control (RBAC)
The app dynamically adjusts its navigation and accessible features based on the logged-in employee's role:
* **Manager**: Overview Dashboard, Team Management, Stock/Inventory Control, Operational Reports, and Account Settings.
* **Pharmacist**: Prescriptions/Scripts Management, Stock Tracking, Task Allocation, and Profile.
* **Cashier**: Sales & Checkout, Billing, Cash Drawer Operations, Stock Inspection, and Profile.
* **Staff**: Task Lists, Inward Stock Processing, Inventory Tracking, and Profile.

### 🎨 Modern UI & Responsive Design
* **Adaptive Theme**: Built-in Light and Dark theme modes with custom design extensions (`AppThemeExtension` & `AppColors`).
* **Custom Bottom Navigation**: Dynamic floating navigation bar built with custom SVG icons (`flutter_svg`) and FontAwesome icons (`font_awesome_flutter`).
* **Multi-Platform & Desktop Window Support**: Optimized desktop experience using `window_manager` (configured minimum window bounds, default sizing, and frame control).

### 💾 Architecture & Local Persistence
* **State Management**: Powered by **Riverpod** (`flutter_riverpod`) utilizing `AsyncNotifierProvider` for async data states and reactivity.
* **Offline Database**: Local persistence built on **Drift** (SQLite ORM) with DAOs for local Employee and Shop data.

---

## 📁 Project Architecture & Folder Structure

```
pharmace_emp/
├── assets/
│   ├── icons/                     # Custom SVG icons (e.g., inventory_outline.svg)
│   ├── images/                    # Image assets
│   └── fonts/                     # Font files
├── lib/
│   ├── backend/
│   │   ├── api_response.dart      # Generic API response wrapper
│   │   ├── api_service.dart       # HTTP client for authentication and employee APIs
│   │   ├── auth/
│   │   │   └── secure_storage_service.dart # Encrypted JWT storage service
│   │   └── model/
│   │       ├── emp_model_invite_id.dart # Invite code validation models
│   │       └── emp_return_model.dart    # Employee and Shop profile data models
│   ├── frontend/
│   │   ├── database/
│   │   │   ├── app_database.dart  # Drift SQLite database definition
│   │   │   ├── dao/               # Data Access Objects (EmployeeDao, ShopDao)
│   │   │   └── table/             # SQLite table definitions (EmployeeTable, ShopTable)
│   │   ├── provider/
│   │   │   ├── app_view_provider.dart # Application view routing state (Splash, Login, Signup, Dashboard)
│   │   │   ├── database_provider.dart # Drift DB provider instance
│   │   │   ├── employee_provider.dart # AsyncNotifier for logged-in employee state
│   │   │   └── shop_provider.dart     # Shop data provider
│   │   ├── screens/
│   │   │   ├── auth/              # Login, Sign Up, QR Scanner, Registration & Splash screens
│   │   │   └── fragment/          # Fragment screens grouped by role (Manager, Pharmacist, Cashier, Staff)
│   │   ├── theme/                 # Light/Dark themes, colors, and theme extensions
│   │   ├── widgets/               # Custom reusable text fields, buttons, and navigation items
│   │   └── responsive_utils.dart  # Responsive layout helpers
│   └── main.dart                  # Application entry point, window configuration & root scaffold
└── pubspec.yaml                   # Dependencies & asset declarations
```

---

## 🛠️ Tech Stack & Dependencies

* **Framework**: [Flutter SDK](https://flutter.dev) (Dart SDK `^3.13.4`)
* **State Management**: [`flutter_riverpod`](https://pub.dev/packages/flutter_riverpod)
* **Local Database**: [`drift`](https://pub.dev/packages/drift) & [`drift_flutter`](https://pub.dev/packages/drift_flutter)
* **Networking & Security**:
  * [`http`](https://pub.dev/packages/http)
  * [`flutter_secure_storage`](https://pub.dev/packages/flutter_secure_storage)
  * [`jwt_decoder`](https://pub.dev/packages/jwt_decoder)
* **UI Utilities & Icons**:
  * [`flutter_svg`](https://pub.dev/packages/flutter_svg)
  * [`font_awesome_flutter`](https://pub.dev/packages/font_awesome_flutter)
  * [`window_manager`](https://pub.dev/packages/window_manager)
  * [`mobile_scanner`](https://pub.dev/packages/mobile_scanner)
  * [`dotted_border`](https://pub.dev/packages/dotted_border)

---

## 💻 Getting Started

### Prerequisites
1. Install [Flutter SDK](https://docs.flutter.dev/get-started/install).
2. Install Android Studio / VS Code with Flutter and Dart extensions.
3. For Windows/Desktop development, ensure Visual Studio with C++ build tools is installed.

### Setup & Run
1. **Clone the repository**:
   ```bash
   git clone <repository-url>
   cd pharmace_emp
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Generate Drift Database code** (if modifying database schemas):
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. **Run the application**:
   ```bash
   flutter run
   ```

---

## 📄 License
This project is private and proprietary.
