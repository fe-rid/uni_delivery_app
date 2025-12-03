# Setup Required Before Running

## ⚠️ Important: The app requires Firebase configuration to run properly

### Quick Fix (To Run Without Firebase)

The app will attempt to initialize Firebase but will continue running even if Firebase config files are missing. However, authentication and data features will not work.

### Full Setup (Recommended)

1. **Create a Firebase Project:**
   - Go to [Firebase Console](https://console.firebase.google.com/)
   - Create a new project
   - Enable Authentication (Email/Password)
   - Enable Cloud Firestore
   - Enable Firebase Storage
   - Enable Cloud Messaging

2. **Add Android Configuration:**
   - In Firebase Console, add an Android app
   - Package name: `com.example.university_delivery_app`
   - Download `google-services.json`
   - Place it in: `android/app/google-services.json`

3. **Add Google Services Plugin:**
   - The app build is configured, but you may need to add the plugin if not already added
   - Check `android/build.gradle.kts` and ensure Google services is available

4. **Run the App:**
   ```bash
   flutter pub get
   flutter run
   ```

### Current Status

✅ **Fixed Issues:**
- Core library desugaring enabled (required for flutter_local_notifications)
- Build configuration updated
- Firebase initialization error handling improved

⚠️ **Still Needed:**
- `google-services.json` file in `android/app/` directory
- Firebase project setup (see FIREBASE_SETUP.md for details)

### Testing Without Firebase

The app will start but authentication features will not work. You can:
- View the UI structure
- Test navigation
- See the app layout

But you cannot:
- Register/Login users
- Access Firestore data
- Use push notifications

