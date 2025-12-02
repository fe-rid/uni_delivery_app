# Firebase Setup Guide

## Step 1: Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Add project"
3. Enter project name: "University Delivery App"
4. Follow the setup wizard

## Step 2: Add Android App

1. In Firebase Console, click "Add app" → Android
2. Register app:
   - Package name: `com.example.university_delivery_app` (or your package name)
   - App nickname: "University Delivery Android"
   - Download `google-services.json`
3. Place `google-services.json` in `android/app/`
4. Update `android/build.gradle`:
   ```gradle
   dependencies {
       classpath 'com.google.gms:google-services:4.4.0'
   }
   ```
5. Update `android/app/build.gradle`:
   ```gradle
   apply plugin: 'com.google.gms.google-services'
   ```

## Step 3: Add iOS App

1. In Firebase Console, click "Add app" → iOS
2. Register app:
   - Bundle ID: `com.example.universityDeliveryApp` (or your bundle ID)
   - App nickname: "University Delivery iOS"
   - Download `GoogleService-Info.plist`
3. Place `GoogleService-Info.plist` in `ios/Runner/`
4. Open `ios/Runner.xcworkspace` in Xcode
5. Drag `GoogleService-Info.plist` into Runner folder in Xcode

## Step 4: Enable Firebase Services

### Authentication
1. Go to Authentication → Sign-in method
2. Enable "Email/Password"
3. Click "Save"

### Cloud Firestore
1. Go to Firestore Database
2. Click "Create database"
3. Start in test mode (you'll update rules later)
4. Choose a location

### Firebase Storage
1. Go to Storage
2. Click "Get started"
3. Start in test mode
4. Choose a location

### Cloud Messaging
1. Go to Cloud Messaging
2. For Android: Upload server key (if needed)
3. For iOS: Upload APNs certificate (if needed)

## Step 5: Firestore Security Rules

Go to Firestore → Rules and paste:

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
      allow update: if request.auth != null && 
        (request.auth.uid == resource.data.userId || 
         request.auth.uid == resource.data.runnerId);
    }
  }
}
```

## Step 6: Storage Rules

Go to Storage → Rules and paste:

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /{allPaths=**} {
      allow read: if true;
      allow write: if request.auth != null;
    }
  }
}
```

## Step 7: Create Firestore Indexes

If you get index errors, create these indexes in Firestore:

1. Collection: `orders`
   - Fields: `status` (Ascending), `createdAt` (Descending)

2. Collection: `menu_items`
   - Fields: `restaurantId` (Ascending)

## Step 8: Test Data

Add sample data to Firestore:

### Restaurants Collection
```json
{
  "name": "Pizza Palace",
  "description": "Best pizza in town",
  "rating": 4.5,
  "address": "123 University Ave",
  "phone": "+1234567890",
  "isOpen": true
}
```

### Menu Items Collection
```json
{
  "restaurantId": "<restaurant_id>",
  "name": "Margherita Pizza",
  "description": "Classic margherita with fresh mozzarella",
  "price": 12.99,
  "category": "Pizza",
  "isAvailable": true
}
```

## Step 9: Run the App

```bash
flutter pub get
flutter run
```

## Troubleshooting

- **Build errors**: Make sure `google-services.json` and `GoogleService-Info.plist` are in correct locations
- **Authentication errors**: Check if Email/Password is enabled in Firebase Console
- **Firestore errors**: Verify security rules and indexes
- **Push notifications not working**: Check FCM setup and permissions

