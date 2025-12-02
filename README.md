# University Delivery App

A complete Flutter application for university food delivery with support for Student (Customer) and Runner (Delivery Person) roles.

## Features

- **Firebase Authentication** - Secure user authentication
- **Cloud Firestore** - Real-time database for restaurants, menu items, and orders
- **Firebase Storage** - Image storage for profiles, restaurants, and menu items
- **Firebase Messaging** - Push notifications for order updates
- **BLoC State Management** - Clean and maintainable state management
- **Clean Architecture** - Separation of concerns with data, domain, and presentation layers

## Project Structure

```
lib/
  ├── main.dart                 # App entry point
  ├── app.dart                  # Root widget
  ├── core/                     # Core utilities
  │   ├── theme/               # App theme
  │   ├── constants/           # App constants
  │   ├── widgets/             # Reusable widgets
  │   └── utils/               # Utility functions
  ├── data/                    # Data layer
  │   ├── models/              # Data models
  │   ├── datasources/         # Data sources (Firebase)
  │   └── repositories/        # Repository implementations
  ├── domain/                  # Domain layer
  │   ├── entities/            # Business entities
  │   └── repositories/        # Repository interfaces
  ├── presentation/           # Presentation layer
  │   ├── bloc/                # BLoC state management
  │   ├── pages/               # UI pages
  │   └── widgets/             # UI widgets
  └── services/                # Services (Firebase, Notifications)
```

## Setup Instructions

### 1. Prerequisites

- Flutter SDK 3.x or higher
- Firebase project created
- Android Studio / VS Code with Flutter extensions

### 2. Firebase Setup

1. Create a Firebase project at [Firebase Console](https://console.firebase.google.com/)
2. Add Android and iOS apps to your Firebase project
3. Download configuration files:
   - Android: `google-services.json` → `android/app/`
   - iOS: `GoogleService-Info.plist` → `ios/Runner/`
4. Enable the following Firebase services:
   - Authentication (Email/Password)
   - Cloud Firestore
   - Firebase Storage
   - Cloud Messaging

### 3. Firestore Rules

Set up Firestore security rules:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users collection
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Restaurants collection
    match /restaurants/{restaurantId} {
      allow read: if true;
      allow write: if request.auth != null;
    }
    
    // Menu items collection
    match /menu_items/{menuItemId} {
      allow read: if true;
      allow write: if request.auth != null;
    }
    
    // Orders collection
    match /orders/{orderId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null;
      allow update: if request.auth != null;
    }
  }
}
```

### 4. Install Dependencies

```bash
flutter pub get
```

### 5. Run the App

```bash
flutter run
```

## User Roles

### Student (Customer)
- Browse restaurants
- View menu items
- Add items to cart
- Place orders
- Track order status in real-time
- View order history

### Runner (Delivery Person)
- View pending orders
- Accept orders
- Update order status (On The Way, Delivered)
- View assigned orders
- Track delivery progress

## Order Status Flow

1. **Pending** - Order placed, waiting for runner
2. **Accepted** - Runner accepted the order
3. **On The Way** - Runner is delivering
4. **Delivered** - Order delivered successfully

## Push Notifications

The app sends push notifications for:
- Order accepted by runner
- Order on the way
- Order delivered

## Dependencies

- `firebase_core` - Firebase initialization
- `firebase_auth` - Authentication
- `cloud_firestore` - Database
- `firebase_storage` - File storage
- `firebase_messaging` - Push notifications
- `flutter_bloc` - State management
- `equatable` - Value equality
- `cached_network_image` - Image caching
- `google_fonts` - Custom fonts
- `intl` - Internationalization
- `uuid` - Unique IDs

## Notes

- Make sure to add your Firebase configuration files before running
- Set up Firestore indexes if needed for complex queries
- Configure push notifications for iOS (APNs) and Android (FCM)
- Add test data to Firestore for restaurants and menu items

## License

This project is created for educational purposes.

