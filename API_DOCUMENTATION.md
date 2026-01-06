# API Documentation

## Firebase Firestore Collections

### 1. Users Collection (`users`)

Stores user information and roles.

**Document ID**: User's Firebase Auth UID

**Fields:**
- `email` (string): User's email address
- `name` (string): User's full name
- `role` (string): User role - either "user" or "admin"
- `createdAt` (timestamp): Account creation timestamp

**Example:**
```json
{
  "email": "user@example.com",
  "name": "John Doe",
  "role": "user",
  "createdAt": "2024-01-01T00:00:00Z"
}
```

**Operations:**
- `getUser(userId)`: Fetch user data
- `createUser(userModel)`: Create new user document
- `updateUser(userId, data)`: Update user information

---

### 2. Providers Collection (`providers`)

Stores service provider information.

**Document ID**: Auto-generated

**Fields:**
- `name` (string): Provider's full name
- `serviceType` (string): Type of service - "cleaner", "cook", "plumber", or "electrician"
- `hourlyRate` (number): Cost per hour in dollars
- `rating` (number): Average rating (0.0 to 5.0)
- `totalReviews` (number): Total number of reviews received
- `imageUrl` (string): URL to provider's profile image
- `description` (string): Brief description of the provider's services

**Example:**
```json
{
  "name": "Sarah Johnson",
  "serviceType": "cleaner",
  "hourlyRate": 25.00,
  "rating": 4.7,
  "totalReviews": 120,
  "imageUrl": "https://via.placeholder.com/150",
  "description": "Professional home cleaning with eco-friendly products"
}
```

**Operations:**
- `getProvidersByServiceType(serviceType)`: Get all providers of a specific type
- `getProvider(providerId)`: Get single provider details
- `updateProviderRating(providerId, newRating)`: Update provider's average rating

---

### 3. Bookings Collection (`bookings`)

Stores all service bookings.

**Document ID**: Auto-generated

**Fields:**
- `userId` (string): Reference to user who made the booking
- `userName` (string): Name of the user
- `serviceType` (string): Type of service booked
- `providerId` (string): Reference to the service provider
- `providerName` (string): Name of the provider
- `date` (timestamp): Scheduled service date
- `hours` (number): Number of hours booked (1-8)
- `hourlyRate` (number): Rate per hour at time of booking
- `totalCost` (number): Total cost (hours × hourlyRate)
- `status` (string): Booking status - "upcoming", "ongoing", "completed", or "cancelled"
- `createdAt` (timestamp): Booking creation timestamp
- `rating` (number, nullable): User's rating after completion (1-5)

**Example:**
```json
{
  "userId": "user_123",
  "userName": "John Doe",
  "serviceType": "cleaner",
  "providerId": "provider_456",
  "providerName": "Sarah Johnson",
  "date": "2024-02-15T14:00:00Z",
  "hours": 3,
  "hourlyRate": 25.00,
  "totalCost": 75.00,
  "status": "upcoming",
  "createdAt": "2024-01-20T10:30:00Z",
  "rating": null
}
```

**Operations:**
- `createBooking(bookingModel)`: Create new booking
- `updateBooking(bookingId, data)`: Update booking details
- `deleteBooking(bookingId)`: Delete a booking
- `getUserBookings(userId, statuses)`: Stream user's bookings by status
- `getAllBookings()`: Stream all bookings (admin)
- `getCompletedBookings(userId)`: Get user's completed bookings

---

## Service Classes

### AuthService

Handles Firebase Authentication operations.

**Methods:**

`signInWithEmailAndPassword(email, password)`
- **Parameters**: email (String), password (String)
- **Returns**: Future<UserModel?>
- **Description**: Sign in existing user

`registerWithEmailAndPassword(email, password, name)`
- **Parameters**: email (String), password (String), name (String)
- **Returns**: Future<UserModel?>
- **Description**: Register new user with default "user" role

`getUserData(userId)`
- **Parameters**: userId (String)
- **Returns**: Future<UserModel?>
- **Description**: Fetch user data from Firestore

`signOut()`
- **Returns**: Future<void>
- **Description**: Sign out current user

`resetPassword(email)`
- **Parameters**: email (String)
- **Returns**: Future<void>
- **Description**: Send password reset email

---

### FirestoreService

Low-level Firestore database operations.

**User Operations:**
- `getUser(userId)`: Get user document
- `createUser(user)`: Create user document
- `updateUser(userId, data)`: Update user document

**Provider Operations:**
- `getProvidersByServiceType(serviceType)`: Query providers by type
- `getProvider(providerId)`: Get single provider
- `updateProviderRating(providerId, newRating)`: Recalculate and update rating

**Booking Operations:**
- `createBooking(booking)`: Create booking document
- `updateBooking(bookingId, data)`: Update booking
- `deleteBooking(bookingId)`: Delete booking
- `getUserBookings(userId, statuses)`: Stream user bookings
- `getAllBookings()`: Stream all bookings
- `getCompletedBookings(userId)`: Get completed bookings list

---

### BookingService

Business logic for booking operations.

**Methods:**

`createBooking(user, provider, date, hours)`
- **Parameters**: 
  - user (UserModel)
  - provider (ServiceProviderModel)
  - date (DateTime)
  - hours (int)
- **Returns**: Future<String> (booking ID)
- **Description**: Create new booking with automatic cost calculation

`cancelBooking(bookingId)`
- **Parameters**: bookingId (String)
- **Returns**: Future<void>
- **Description**: Cancel a booking (sets status to "cancelled")

`markAsOngoing(bookingId)`
- **Parameters**: bookingId (String)
- **Returns**: Future<void>
- **Description**: Change booking status to "ongoing"

`markAsCompleted(bookingId)`
- **Parameters**: bookingId (String)
- **Returns**: Future<void>
- **Description**: Change booking status to "completed"

`rateBooking(bookingId, providerId, rating)`
- **Parameters**: bookingId (String), providerId (String), rating (double)
- **Returns**: Future<void>
- **Description**: Add rating to booking and update provider's average

---

### ProviderService

Service provider operations.

**Methods:**

`getProvidersByServiceType(serviceType)`
- **Parameters**: serviceType (String)
- **Returns**: Future<List<ServiceProviderModel>>
- **Description**: Get all providers of specified type

`getProvider(providerId)`
- **Parameters**: providerId (String)
- **Returns**: Future<ServiceProviderModel?>
- **Description**: Get single provider details

---

## State Management (Provider)

### AuthProvider

Manages authentication state.

**Properties:**
- `user` (UserModel?): Current authenticated user
- `isAuthenticated` (bool): Whether user is logged in
- `isLoading` (bool): Loading state

**Methods:**
- `signIn(email, password)`: Sign in user
- `register(email, password, name)`: Register new user
- `signOut()`: Sign out user
- `resetPassword(email)`: Send password reset email

---

### BookingProvider

Manages booking state and operations.

**Properties:**
- `upcomingBookings` (List<BookingModel>)
- `completedBookings` (List<BookingModel>)
- `allBookings` (List<BookingModel>)
- `isLoading` (bool)

**Methods:**
- `createBooking(user, provider, date, hours)`: Create new booking
- `cancelBooking(bookingId)`: Cancel booking
- `markAsOngoing(bookingId)`: Update to ongoing status
- `markAsCompleted(bookingId)`: Update to completed status
- `rateBooking(bookingId, providerId, rating)`: Rate completed booking
- `getUserBookings(userId, statuses)`: Stream user bookings
- `getAllBookings()`: Stream all bookings (admin)
- `loadCompletedBookings(userId)`: Load completed bookings

---

### ServiceProviderProvider

Manages service provider state.

**Properties:**
- `providers` (List<ServiceProviderModel>)
- `isLoading` (bool)

**Methods:**
- `loadProvidersByServiceType(serviceType)`: Load providers by type
- `getProvider(providerId)`: Get single provider
- `clearProviders()`: Clear provider list

---

## Enums and Constants

### Service Types
- `cleaner`: Cleaning services
- `cook`: Cooking services
- `plumber`: Plumbing services
- `electrician`: Electrical services

### Booking Status
- `upcoming`: Booking is scheduled but not started
- `ongoing`: Service is currently being provided
- `completed`: Service has been completed
- `cancelled`: Booking was cancelled

### User Roles
- `user`: Regular customer
- `admin`: Administrator with full access

---

## Color Constants

**Primary Colors:**
- Primary: #1565C0 (Deep Blue)
- Secondary: #FFC107 (Amber)
- Background: #F5F5F5 (Light Gray)
- Card: #FFFFFF (White)

**Status Colors:**
- Upcoming: #2196F3 (Blue)
- Ongoing: #FF9800 (Orange)
- Completed: #4CAF50 (Green)
- Cancelled: #9E9E9E (Gray)

**Utility Colors:**
- Error: #D32F2F (Red)
- Success: #388E3C (Green)
- Text Primary: #212121
- Text Secondary: #757575

---

## Helper Functions

### Helpers Class

**Currency Formatting:**
- `formatCurrency(amount)`: Returns "$XX.XX" format

**Date Formatting:**
- `formatDate(date)`: Returns "MMM dd, yyyy"
- `formatDateTime(date)`: Returns "MMM dd, yyyy HH:mm"
- `formatTime(date)`: Returns "HH:mm"

**Validation:**
- `isValidEmail(email)`: Email validation
- `calculateTotalCost(hours, hourlyRate)`: Calculate booking cost

**Utilities:**
- `getGreeting()`: Time-based greeting
- `capitalize(text)`: Capitalize first letter

---

## Security Rules

Firestore security rules ensure:
- Users can only read/write their own user document
- All authenticated users can read providers
- Only admins can write to providers
- Users can only read their own bookings (admins can read all)
- Users can create bookings
- Users can update/delete their own bookings (admins can update/delete any)

---

## Error Handling

All service methods include try-catch blocks and print error messages to console. Errors are re-thrown to be handled by the UI layer, where they are displayed using SnackBars.

**Common Errors:**
- Authentication failed
- Permission denied
- Network error
- Document not found
- Invalid data

---

## Best Practices

1. **Always authenticate**: Check `isAuthenticated` before accessing user data
2. **Use streams for real-time data**: Bookings use StreamBuilder for live updates
3. **Validate user input**: Email validation, date validation, etc.
4. **Show loading states**: Display LoadingIndicator during async operations
5. **Confirm destructive actions**: Use dialogs for cancel, logout, etc.
6. **Handle errors gracefully**: Show user-friendly error messages
7. **Keep UI responsive**: Use async/await properly
8. **Clean up resources**: Dispose controllers in StatefulWidgets
