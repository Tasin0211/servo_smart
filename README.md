# Home Services Booking App

A complete Flutter mobile application for booking home services (cleaner, cook, plumber, electrician) with user and admin roles, Firebase backend, and complete booking lifecycle management.

## Features

### User Features
- 🔐 Email/Password Authentication
- 🏠 Service Selection (Cleaner, Cook, Plumber, Electrician)
- 👨‍🔧 Browse Service Providers by Category
- 📅 Book Services with Date and Duration Selection
- 📋 View Upcoming and Ongoing Bookings
- ⭐ Rate Completed Services
- ❌ Cancel Upcoming Bookings
- 👤 User Profile Management

### Admin Features
- 📊 Admin Dashboard with All Bookings
- 🔄 Update Booking Status (Upcoming → Ongoing → Completed)
- ❌ Cancel Bookings
- 📈 View Booking Statistics
- 👥 Monitor All User Bookings

## Tech Stack

- **Frontend**: Flutter (Material UI, Material Design 3)
- **State Management**: Provider
- **Backend**: Firebase
  - Firebase Authentication (Email + Password)
  - Cloud Firestore (Database)
- **Platforms**: Android-first (iOS compatible)

## Project Structure

```
lib/
 ├── main.dart                          # App entry point
 ├── firebase_options.dart              # Firebase configuration
 ├── auth/
 │    ├── auth_service.dart            # Authentication logic
 │    └── auth_wrapper.dart            # Auth state handler
 ├── models/
 │    ├── user_model.dart              # User data model
 │    ├── provider_model.dart          # Service provider model
 │    └── booking_model.dart           # Booking data model
 ├── services/
 │    ├── firestore_service.dart       # Firestore database operations
 │    ├── booking_service.dart         # Booking business logic
 │    └── provider_service.dart        # Provider business logic
 ├── providers/
 │    ├── auth_provider.dart           # Authentication state
 │    ├── booking_provider.dart        # Booking state
 │    └── service_provider_provider.dart # Provider state
 ├── screens/
 │    ├── login/
 │    │    └── login_screen.dart       # Login/Register screen
 │    ├── home/
 │    │    └── home_screen.dart        # Main home with navigation
 │    ├── service_list/
 │    │    └── service_list_screen.dart # Provider list
 │    ├── booking/
 │    │    └── booking_screen.dart     # Booking creation
 │    ├── upcoming/
 │    │    └── upcoming_screen.dart    # Upcoming bookings
 │    ├── completed/
 │    │    └── completed_screen.dart   # Completed bookings with ratings
 │    └── admin/
 │         ├── admin_dashboard.dart     # Admin main screen
 │         └── admin_booking_detail.dart # Booking management
 ├── widgets/
 │    ├── service_card.dart            # Service category card
 │    ├── provider_card.dart           # Provider display card
 │    ├── booking_card.dart            # Booking display card
 │    ├── loading_indicator.dart       # Loading widget
 │    └── custom_button.dart           # Reusable button
 └── utils/
      ├── constants.dart                # App constants and theme
      └── helpers.dart                  # Helper functions
```

## Setup Instructions

### Prerequisites
- Flutter SDK (latest stable version)
- Dart SDK (comes with Flutter)
- Android Studio / Xcode (for mobile development)
- Firebase account

### 1. Clone Repository
```bash
git clone https://github.com/ahmad-hasan-160/tasin_3200_project.git
cd tasin_3200_project
```

### 2. Flutter Setup
```bash
# Check Flutter installation
flutter doctor

# Install dependencies
flutter pub get
```

### 3. Firebase Project Setup

#### Create Firebase Project
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Add project"
3. Enter project name: `home-services-booking`
4. Follow the setup wizard

#### Enable Authentication
1. In Firebase Console, go to **Authentication**
2. Click "Get Started"
3. Enable **Email/Password** sign-in method
4. Click "Save"

#### Setup Cloud Firestore
1. In Firebase Console, go to **Firestore Database**
2. Click "Create database"
3. Select "Start in test mode" (or production mode with rules)
4. Choose a location (e.g., us-central)
5. Click "Enable"

#### Configure Firebase for Flutter

**For Android:**
1. In Firebase Console, click "Add app" → Android
2. Register app with package name: `com.example.home_services_booking`
3. Download `google-services.json`
4. Create `android/app/` directory if it doesn't exist
5. Place `google-services.json` in `android/app/`

**For iOS:**
1. In Firebase Console, click "Add app" → iOS
2. Register app with bundle ID: `com.example.homeServicesBooking`
3. Download `GoogleService-Info.plist`
4. Create `ios/Runner/` directory if it doesn't exist
5. Place `GoogleService-Info.plist` in `ios/Runner/`

**Update Firebase Options:**
1. Open `lib/firebase_options.dart`
2. Replace placeholder values with your actual Firebase configuration
3. Get these values from Firebase Console → Project Settings → Your Apps

### 4. Create Firestore Collections and Sample Data

#### Collections Structure

**1. users collection:**
```json
{
  "email": "admin@example.com",
  "name": "Admin User",
  "role": "admin",
  "createdAt": "2024-01-01T00:00:00Z"
}
```

**2. providers collection:**
```json
{
  "name": "John Cleaner",
  "serviceType": "cleaner",
  "hourlyRate": 25.00,
  "rating": 4.5,
  "totalReviews": 48,
  "imageUrl": "https://via.placeholder.com/150",
  "description": "Professional home cleaning specialist with 5 years experience"
}
```

**3. bookings collection:**
(Created automatically by the app when users make bookings)

#### Add Sample Data

You can add sample data manually through Firebase Console or use this script:

1. In Firebase Console, go to **Firestore Database**
2. Click "Start collection"
3. Add collection named `providers`
4. Add documents with the following sample data:

**Cleaner Provider:**
- providerId: Auto-generated
- name: "Sarah Johnson"
- serviceType: "cleaner"
- hourlyRate: 25.00
- rating: 4.7
- totalReviews: 120
- imageUrl: "https://via.placeholder.com/150"
- description: "Professional home cleaning with eco-friendly products"

**Cook Provider:**
- name: "Michael Chen"
- serviceType: "cook"
- hourlyRate: 30.00
- rating: 4.8
- totalReviews: 95
- imageUrl: "https://via.placeholder.com/150"
- description: "Expert chef specializing in international cuisine"

**Plumber Provider:**
- name: "David Wilson"
- serviceType: "plumber"
- hourlyRate: 45.00
- rating: 4.6
- totalReviews: 78
- imageUrl: "https://via.placeholder.com/150"
- description: "Licensed plumber for all home plumbing needs"

**Electrician Provider:**
- name: "Emma Brown"
- serviceType: "electrician"
- hourlyRate: 50.00
- rating: 4.9
- totalReviews: 156
- imageUrl: "https://via.placeholder.com/150"
- description: "Certified electrician with 10+ years experience"

### 5. Firestore Security Rules

Update Firestore security rules in Firebase Console → Firestore Database → Rules:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users collection
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
      allow read: if request.auth != null;
    }
    
    // Providers collection
    match /providers/{providerId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && 
                      get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin';
    }
    
    // Bookings collection
    match /bookings/{bookingId} {
      allow read: if request.auth != null && 
                     (resource.data.userId == request.auth.uid || 
                      get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin');
      allow create: if request.auth != null;
      allow update, delete: if request.auth != null && 
                               (resource.data.userId == request.auth.uid || 
                                get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin');
    }
  }
}
```

### 6. Run the Application

```bash
# Run on connected device or emulator
flutter run

# Build for Android
flutter build apk

# Build for iOS
flutter build ios
```

### 7. Create Test Accounts

**Create Admin Account:**
1. Run the app
2. Click "Register"
3. Enter email: `admin@example.com`
4. Enter password: `admin123`
5. Enter name: `Admin User`
6. After registration, go to Firebase Console → Firestore → users collection
7. Find the newly created user document
8. Change the `role` field from `user` to `admin`
9. Logout and login again

**Create Regular User Account:**
1. Click "Register"
2. Enter email: `user@example.com`
3. Enter password: `user123`
4. Enter name: `Regular User`

## Usage

### For Regular Users:
1. **Login** with user credentials
2. **Select a Service** from the home screen (Cleaner, Cook, Plumber, Electrician)
3. **Browse Providers** and view their ratings and rates
4. **Book a Service** by selecting date, hours, and confirming
5. **View Upcoming Bookings** in the Upcoming tab
6. **Cancel Bookings** if needed (only upcoming bookings)
7. **Rate Completed Services** in the Completed tab

### For Admin Users:
1. **Login** with admin credentials
2. **View All Bookings** on the dashboard
3. **Click on Any Booking** to view details
4. **Update Booking Status**:
   - Mark Upcoming → Ongoing
   - Mark Ongoing → Completed
   - Cancel any booking
5. **Monitor Statistics** from the summary cards

## Color Scheme
- **Primary**: Deep Blue (#1565C0)
- **Secondary**: Amber (#FFC107)
- **Background**: Light Gray (#F5F5F5)
- **Success**: Green (#4CAF50)
- **Error**: Red (#D32F2F)

## Key Dependencies
```yaml
dependencies:
  firebase_core: ^2.24.2
  firebase_auth: ^4.16.0
  cloud_firestore: ^4.14.0
  provider: ^6.1.1
  intl: ^0.18.1
  flutter_rating_bar: ^4.0.1
```

## Troubleshooting

### Firebase Not Initialized
- Ensure `google-services.json` (Android) or `GoogleService-Info.plist` (iOS) is in the correct location
- Update `firebase_options.dart` with your project configuration

### Build Errors
```bash
flutter clean
flutter pub get
flutter run
```

### Authentication Issues
- Check Firebase Authentication is enabled
- Verify Email/Password provider is active

### Firestore Permission Denied
- Update Firestore security rules as specified above
- Ensure user is authenticated

## License
MIT License

## Support
For issues or questions, please create an issue on GitHub.