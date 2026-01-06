# ServoSmart - Home Services Booking App

## Project Overview
Flutter app for booking home services (cleaner, cook, plumber, electrician) with Firebase backend, role-based access (users/admins), and complete booking lifecycle management.

## Architecture & State Management

**Pattern**: MVVM with Provider for reactive state management
- **Models** (`lib/models/`): Immutable data classes with `fromFirestore()` and `toFirestore()` serialization
- **Services** (`lib/services/`): Business logic and Firebase operations (FirestoreService, BookingService, AuthService)
- **Providers** (`lib/providers/`): ChangeNotifier classes managing app state (AuthProvider, BookingProvider, ServiceProviderProvider)
- **Screens** (`lib/screens/`): UI organized by feature (login, home, booking, admin, etc.)
- **Widgets** (`lib/widgets/`): Reusable components (CustomButton, BookingCard, etc.)

**Key Pattern**: All screens consume state via `Provider.of<T>(context)` and trigger actions through provider methods. State updates happen via `notifyListeners()`.

## Data Flow & Firebase Integration

### Authentication Flow
```dart
AuthWrapper → checks authProvider.isAuthenticated
  → if admin role: AdminDashboard
  → if user role: HomeScreen
  → else: LoginScreen
```

**Critical**: User role is stored in Firestore `users` collection and loaded during auth state changes. See [lib/auth/auth_wrapper.dart](lib/auth/auth_wrapper.dart#L31-L34).

### Firestore Collections
- `users`: UserModel with role field ('user' or 'admin')
- `providers`: ServiceProviderModel filtered by serviceType
- `bookings`: BookingModel with status lifecycle (upcoming → ongoing → completed/cancelled)

**Important**: All models use Timestamp conversion for dates. Always use `Timestamp.fromDate()` when writing and `.toDate()` when reading. See [lib/models/booking_model.dart](lib/models/booking_model.dart#L44-L45).

## Constants & Theming

Central configuration in [lib/utils/constants.dart](lib/utils/constants.dart):
- **AppColors**: Material Design 3 color scheme (primaryColor: #1565C0)
- **ServiceTypes**: Maps service keys to icons/names (cleaner, cook, plumber, electrician)
- **BookingStatus**: Status constants with color mapping functions
- **FirestoreCollections**: Collection name constants

**Convention**: Always reference colors/strings from constants, never hardcode values.

## Widget Patterns

### Custom Widgets
All custom widgets accept parameters for styling flexibility but have sensible defaults:
```dart
CustomButton(
  text: 'Submit',
  onPressed: _submit,
  isLoading: _isLoading,  // Shows CircularProgressIndicator
  isOutlined: false,       // Toggle filled/outlined variant
)
```

**Loading States**: Use `isLoading` bool in State classes to disable buttons and show spinners during async operations.

### Form Validation
All forms use GlobalKey<FormState> with validator functions. Email validation uses `Helpers.isValidEmail()` from [lib/utils/helpers.dart](lib/utils/helpers.dart).

## Common Development Tasks

### Adding a New Screen
1. Create screen in `lib/screens/<feature>/`
2. Import required providers using `Provider.of<T>(context)`
3. Add loading states for async operations
4. Use constants for colors/strings
5. Handle mounted checks before setState after async calls:
```dart
if (!mounted) return;
setState(() { /* update state */ });
```

### Creating a Booking
See [lib/services/booking_service.dart](lib/services/booking_service.dart) for complete flow:
1. Calculate totalCost from hours × hourlyRate
2. Create BookingModel with status='upcoming'
3. Call FirestoreService.createBooking()
4. Update provider state via BookingProvider

### Status Transitions
Bookings follow strict status flow enforced in admin UI:
- upcoming → ongoing (mark started)
- ongoing → completed (mark finished)
- Any status → cancelled

**Never** allow direct upcoming → completed transitions.

## Firebase Setup

Run `flutterfire configure` to regenerate [lib/firebase_options.dart](lib/firebase_options.dart) for new environments. See [FIREBASE_SETUP.md](FIREBASE_SETUP.md) for manual setup.

**Android**: Ensure `android/app/google-services.json` exists and `android/app/build.gradle.kts` includes the google-services plugin.

## Testing & Running

```bash
# Install dependencies
flutter pub get

# Run on device/emulator
flutter run

# Build APK
flutter build apk --release

# Analyze code
flutter analyze
```

**Note**: App gracefully handles Firebase initialization failures (see [lib/main.dart](lib/main.dart#L14-L19)) for demo purposes.

### Common Issues

**Firebase Auth type cast errors** (e.g., `'List<Object?>' is not a subtype of 'PigeonUserDetails?'`):
```bash
flutter clean
flutter pub get
```
This clears cached platform channel code. If persists, update Firebase dependencies to latest compatible versions.

**Login succeeds but doesn't navigate**: User authenticated in Firebase Auth but no document exists in Firestore `users` collection. Check logs for "⚠️ User document does NOT exist in Firestore". Solutions:
1. Register a new user (creates both Auth + Firestore doc)
2. Manually create Firestore document with fields: `email`, `name`, `role`, `createdAt`
3. See [CREATE_TEST_USER.md](CREATE_TEST_USER.md) for detailed instructions

## Code Style

- Follow `package:flutter_lints/flutter.yaml` rules (see [analysis_options.yaml](analysis_options.yaml))
- Use `const` constructors where possible for performance
- Prefer named parameters for widget constructors
- All models must implement `copyWith()` for immutability
- Use `??` null coalescing in fromFirestore for default values

## Logging

**Logger Setup**: App uses `logger` package for comprehensive logging (see [lib/utils/utils.dart](lib/utils/utils.dart))

**Usage Pattern**:
```dart
import '../utils/utils.dart';

logger.i('✅ Success message');
logger.w('⚠️ Warning message');
logger.e('❌ Error message');
logger.d('🔍 Debug message');
```

**Key Logged Events**: Auth state changes, Firestore operations, user navigation, form submissions. Check terminal output when debugging auth or data flow issues.

## Admin vs User Features

**User Role**: Can book services, view own bookings, rate completed services, cancel upcoming bookings
**Admin Role**: See all bookings, update any booking status, access AdminDashboard instead of HomeScreen

Check role: `authProvider.user?.role == UserRoles.admin` (constants in [lib/utils/constants.dart](lib/utils/constants.dart#L95))
