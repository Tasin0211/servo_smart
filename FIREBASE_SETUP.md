# Firebase Setup Instructions

## Complete Step-by-Step Guide

### 1. Create Firebase Project

1. Visit [Firebase Console](https://console.firebase.google.com/)
2. Click "Add project" or "Create a project"
3. Enter project name: `home-services-booking`
4. (Optional) Enable Google Analytics
5. Click "Create project"
6. Wait for project creation to complete

### 2. Enable Firebase Authentication

1. In the Firebase Console, select your project
2. Click on "Authentication" in the left sidebar
3. Click "Get started"
4. Go to "Sign-in method" tab
5. Click on "Email/Password"
6. Toggle "Enable" to ON
7. Click "Save"

### 3. Setup Cloud Firestore

1. In Firebase Console, click on "Firestore Database" in the left sidebar
2. Click "Create database"
3. Select starting mode:
   - **Test mode** (for development): Anyone can read/write for 30 days
   - **Production mode** (recommended): Use security rules below
4. Choose Firestore location (e.g., `us-central`)
5. Click "Enable"

### 4. Add Android App

1. In Firebase Console, click on the gear icon next to "Project Overview"
2. Select "Project settings"
3. Scroll down to "Your apps"
4. Click on the Android icon
5. Enter Android package name: `com.example.home_services_booking`
6. (Optional) Add app nickname: "Home Services App"
7. Click "Register app"
8. Download `google-services.json`
9. Create directory structure: `android/app/` (if not exists)
10. Move `google-services.json` to `android/app/`
11. Click "Next" through the remaining steps
12. Click "Continue to console"

### 5. Add iOS App (Optional)

1. In Firebase Console Project Settings
2. Click on the iOS icon under "Your apps"
3. Enter iOS bundle ID: `com.example.homeServicesBooking`
4. (Optional) Add app nickname
5. Click "Register app"
6. Download `GoogleService-Info.plist`
7. Create directory structure: `ios/Runner/` (if not exists)
8. Move `GoogleService-Info.plist` to `ios/Runner/`
9. Complete the setup wizard

### 6. Configure Firebase in Flutter

#### Option 1: Using FlutterFire CLI (Recommended)

```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Run configuration
flutterfire configure
```

This will automatically:
- Create/update `lib/firebase_options.dart`
- Configure all platforms
- Link your Firebase project

#### Option 2: Manual Configuration

1. Open `lib/firebase_options.dart`
2. Go to Firebase Console → Project Settings
3. Scroll to "Your apps"
4. Click on your Android/iOS app
5. Find the configuration values
6. Replace placeholders in `firebase_options.dart`:

For Android:
```dart
static const FirebaseOptions android = FirebaseOptions(
  apiKey: 'YOUR_ANDROID_API_KEY',           // From Firebase Console
  appId: 'YOUR_ANDROID_APP_ID',             // From Firebase Console
  messagingSenderId: 'YOUR_SENDER_ID',      // From Firebase Console
  projectId: 'YOUR_PROJECT_ID',             // Your project ID
  storageBucket: 'YOUR_PROJECT_ID.appspot.com',
);
```

### 7. Create Firestore Collections

#### Method 1: Firebase Console (Manual)

1. Go to Firestore Database
2. Click "Start collection"
3. Collection ID: `providers`
4. Add first document with auto-generated ID
5. Add fields as shown in sample data section

#### Method 2: Using Firebase Admin SDK or App

The app will create `users` and `bookings` collections automatically.
You only need to manually create `providers` collection with sample data.

### 8. Add Sample Providers Data

In Firestore Console, add these documents to `providers` collection:

**Provider 1 (Cleaner):**
```
Document ID: (auto-generated)
Fields:
  name: "Sarah Johnson" (string)
  serviceType: "cleaner" (string)
  hourlyRate: 25.00 (number)
  rating: 4.7 (number)
  totalReviews: 120 (number)
  imageUrl: "https://via.placeholder.com/150" (string)
  description: "Professional home cleaning with eco-friendly products" (string)
```

**Provider 2 (Cook):**
```
Document ID: (auto-generated)
Fields:
  name: "Michael Chen" (string)
  serviceType: "cook" (string)
  hourlyRate: 30.00 (number)
  rating: 4.8 (number)
  totalReviews: 95 (number)
  imageUrl: "https://via.placeholder.com/150" (string)
  description: "Expert chef specializing in international cuisine" (string)
```

**Provider 3 (Plumber):**
```
Document ID: (auto-generated)
Fields:
  name: "David Wilson" (string)
  serviceType: "plumber" (string)
  hourlyRate: 45.00 (number)
  rating: 4.6 (number)
  totalReviews: 78 (number)
  imageUrl: "https://via.placeholder.com/150" (string)
  description: "Licensed plumber for all home plumbing needs" (string)
```

**Provider 4 (Electrician):**
```
Document ID: (auto-generated)
Fields:
  name: "Emma Brown" (string)
  serviceType: "electrician" (string)
  hourlyRate: 50.00 (number)
  rating: 4.9 (number)
  totalReviews: 156 (number)
  imageUrl: "https://via.placeholder.com/150" (string)
  description: "Certified electrician with 10+ years experience" (string)
```

### 9. Configure Firestore Security Rules

1. Go to Firestore Database → Rules tab
2. Replace default rules with:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Helper function to check if user is authenticated
    function isAuthenticated() {
      return request.auth != null;
    }
    
    // Helper function to check if user is admin
    function isAdmin() {
      return isAuthenticated() && 
             get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin';
    }
    
    // Users collection
    match /users/{userId} {
      // Users can read their own data
      allow read, write: if isAuthenticated() && request.auth.uid == userId;
      // All authenticated users can read any user (for admin purposes)
      allow read: if isAuthenticated();
    }
    
    // Providers collection
    match /providers/{providerId} {
      // Anyone authenticated can read providers
      allow read: if isAuthenticated();
      // Only admins can write providers
      allow write: if isAdmin();
    }
    
    // Bookings collection
    match /bookings/{bookingId} {
      // Users can read their own bookings, admins can read all
      allow read: if isAuthenticated() && 
                     (resource.data.userId == request.auth.uid || isAdmin());
      // Users can create their own bookings
      allow create: if isAuthenticated();
      // Users can update/delete their own bookings, admins can update/delete any
      allow update, delete: if isAuthenticated() && 
                               (resource.data.userId == request.auth.uid || isAdmin());
    }
  }
}
```

3. Click "Publish"

### 10. Test Firebase Connection

Run the app:
```bash
flutter run
```

You should see no Firebase errors in the console.

### 11. Create Admin User

1. Register a new user through the app
2. Go to Firebase Console → Firestore Database
3. Navigate to `users` collection
4. Find the newly created user document
5. Click on the document
6. Find the `role` field
7. Change value from `user` to `admin`
8. Logout from the app and login again
9. You should now see the Admin Dashboard

## Troubleshooting

### "Firebase not initialized" Error
- Check that `google-services.json` is in `android/app/`
- Check that `firebase_options.dart` has correct configuration
- Run `flutter clean` and `flutter pub get`

### "Permission Denied" Error
- Update Firestore security rules as shown above
- Make sure user is authenticated
- Check that user role is correct in Firestore

### Authentication Issues
- Verify Email/Password is enabled in Firebase Console
- Check network connection
- Clear app data and try again

### Build Errors
```bash
flutter clean
flutter pub get
cd android && ./gradlew clean
cd .. && flutter run
```

## Additional Resources

- [Firebase Documentation](https://firebase.google.com/docs)
- [FlutterFire Documentation](https://firebase.flutter.dev/)
- [Cloud Firestore Documentation](https://firebase.google.com/docs/firestore)
