# Creating Test Users in Firestore

## The Problem
If you're trying to log in with an existing Firebase Auth user but they don't have a document in the Firestore `users` collection, the app won't be able to load user data and navigation will fail.

## Solution 1: Register a New User (Recommended)
1. Use the "Register" option in the app
2. This will create both the Firebase Auth account AND the Firestore document

## Solution 2: Manually Add User Document in Firebase Console
If you already have a Firebase Auth user but no Firestore document:

1. Go to Firebase Console → Firestore Database
2. Click "Start collection"
3. Collection ID: `users`
4. Click "Next"
5. Document ID: Use your Firebase Auth UID (e.g., `e44pMljUHAW9Bq2I8JUdQsBVex73`)
6. Add fields:
   - `email` (string): Your email
   - `name` (string): Your name
   - `role` (string): `user` or `admin`
   - `createdAt` (timestamp): Current timestamp
7. Click "Save"

## Solution 3: Create Admin User
To create an admin user:
1. Follow Solution 1 or 2 above
2. In Firestore, set the `role` field to `admin`

## Example Firestore Document Structure
```
Collection: users
Document ID: e44pMljUHAW9Bq2I8JUdQsBVex73
Fields:
  - email: "tasin@gmail.com"
  - name: "Tasin"
  - role: "user"
  - createdAt: January 6, 2026 at 12:00:00 AM UTC
```

## Checking if User Document Exists
With the new logging, you'll see:
- ✅ "User document found in Firestore" - Document exists
- ⚠️ "User document does NOT exist in Firestore" - Need to create it

## After Creating the Document
1. Restart the app
2. Try logging in again
3. Check logs for successful navigation to HomeScreen or AdminDashboard
