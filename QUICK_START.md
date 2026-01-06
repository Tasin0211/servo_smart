# Quick Start Guide

Get the Home Services Booking App running in 5 minutes!

## Prerequisites
- ✅ Flutter installed ([Get Flutter](https://flutter.dev/docs/get-started/install))
- ✅ Firebase account ([Sign up](https://console.firebase.google.com/))
- ✅ Android Studio or VS Code with Flutter plugin

## Step 1: Clone & Install (1 min)

```bash
# Clone the repository
git clone https://github.com/ahmad-hasan-160/tasin_3200_project.git
cd tasin_3200_project

# Check Flutter
flutter doctor

# Install dependencies
flutter pub get
```

## Step 2: Firebase Setup (2 min)

### Quick Setup (Recommended)
```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Configure Firebase (this will guide you through the process)
flutterfire configure
```

This will automatically:
- Create a Firebase project (or use existing)
- Register your app
- Download configuration files
- Update `lib/firebase_options.dart`

### Manual Setup
If you prefer manual setup, see [FIREBASE_SETUP.md](FIREBASE_SETUP.md)

## Step 3: Enable Firebase Services (1 min)

In [Firebase Console](https://console.firebase.google.com/):

1. **Enable Authentication**
   - Go to Authentication → Sign-in method
   - Enable "Email/Password"
   - Click Save

2. **Enable Firestore**
   - Go to Firestore Database
   - Create database (Start in test mode)
   - Click Enable

## Step 4: Add Sample Data (1 min)

In Firebase Console → Firestore Database:

1. Create collection: `providers`
2. Add document (auto ID):
   ```
   name: "Sarah Johnson"
   serviceType: "cleaner"
   hourlyRate: 25.00
   rating: 4.7
   totalReviews: 120
   imageUrl: "https://via.placeholder.com/150"
   description: "Professional cleaning services"
   ```
3. Repeat for other service types (cook, plumber, electrician)

**Or copy-paste this quick script:**
See [Sample Data](#sample-data-script) below.

## Step 5: Run the App! (< 1 min)

```bash
# Connect your device/emulator
flutter devices

# Run the app
flutter run
```

That's it! 🎉

## First Login

### Create User Account
1. Open the app
2. Click "Register"
3. Enter:
   - Email: `user@test.com`
   - Password: `test123`
   - Name: `Test User`
4. Login and explore!

### Create Admin Account
1. Register as above
2. Go to Firebase Console → Firestore → `users` collection
3. Find your user document
4. Change `role` from `user` to `admin`
5. Logout and login again
6. You'll see Admin Dashboard!

## Sample Data Script

For Firestore Console → Firestore Database → Start collection:

**Collection ID**: `providers`

**Add 4 documents** with these values:

### Document 1 (Cleaner)
```
name: Sarah Johnson
serviceType: cleaner
hourlyRate: 25.00
rating: 4.7
totalReviews: 120
imageUrl: https://via.placeholder.com/150
description: Professional home cleaning specialist
```

### Document 2 (Cook)
```
name: Michael Chen
serviceType: cook
hourlyRate: 30.00
rating: 4.8
totalReviews: 95
imageUrl: https://via.placeholder.com/150
description: Expert chef specializing in international cuisine
```

### Document 3 (Plumber)
```
name: David Wilson
serviceType: plumber
hourlyRate: 45.00
rating: 4.6
totalReviews: 78
imageUrl: https://via.placeholder.com/150
description: Licensed plumber for all home needs
```

### Document 4 (Electrician)
```
name: Emma Brown
serviceType: electrician
hourlyRate: 50.00
rating: 4.9
totalReviews: 156
imageUrl: https://via.placeholder.com/150
description: Certified electrician with 10+ years experience
```

## Common Commands

```bash
# Clean build
flutter clean
flutter pub get

# Run on specific device
flutter run -d <device-id>

# Build APK for Android
flutter build apk

# Build for iOS
flutter build ios

# Check for issues
flutter doctor -v
flutter analyze
```

## Troubleshooting

### "Firebase not initialized"
```bash
# Re-run FlutterFire config
flutterfire configure
```

### "Permission denied" in Firestore
Update Firestore Rules (see [FIREBASE_SETUP.md](FIREBASE_SETUP.md))

### Build errors
```bash
flutter clean
flutter pub get
cd android && ./gradlew clean
cd .. && flutter run
```

### "Google services plugin not found"
Ensure `google-services.json` is in `android/app/`

## What to Try

### As User:
1. ✅ Browse services (4 categories)
2. ✅ Select a provider
3. ✅ Book a service (choose date & hours)
4. ✅ View upcoming bookings
5. ✅ Cancel a booking
6. ✅ Rate completed services

### As Admin:
1. ✅ View all bookings dashboard
2. ✅ See booking statistics
3. ✅ Click on any booking
4. ✅ Change booking status
5. ✅ Cancel bookings

## Next Steps

- 📖 Read [README.md](README.md) for full documentation
- 🔧 Check [FIREBASE_SETUP.md](FIREBASE_SETUP.md) for detailed Firebase config
- 📚 See [API_DOCUMENTATION.md](API_DOCUMENTATION.md) for code reference
- ✅ Review [FEATURES.md](FEATURES.md) for complete feature list

## Need Help?

- Check [Troubleshooting](README.md#troubleshooting) in README
- Review [Firebase Setup Guide](FIREBASE_SETUP.md)
- Create an issue on GitHub

## Production Deployment

Before deploying to production:

1. ✅ Update Firestore security rules to production mode
2. ✅ Replace placeholder images with real provider photos
3. ✅ Set up proper email verification
4. ✅ Add payment integration (if needed)
5. ✅ Enable Firebase Analytics
6. ✅ Set up Crashlytics
7. ✅ Add push notifications (optional)
8. ✅ Implement proper backup strategy

---

**Enjoy building with Flutter! 🚀**
