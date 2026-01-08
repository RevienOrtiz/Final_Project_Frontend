# Frontend (Flutter)

## Overview
- Flutter app consuming the Express API
- Two tabs: Rooms and Bookings
- Modern UI with pink theme and rounded surfaces

## Prerequisites
- Flutter SDK installed
- Android/iOS/Web tooling as needed

## API Base
- Defined in `lib/main.dart`
- Web/Desktop: `http://localhost:4000/api`
- Android emulator: `http://10.0.2.2:4000/api`

## Run
- From `frontend/`: `flutter run`
- Use a connected device/emulator or run on web

## Features
- Rooms
  - Grouped by type with expandable details
  - Status chips (available, cleaning, taken)
  - Search by name/type
  - Update room status via dialog
- Bookings
  - List bookings with room info and total price
  - Created At timestamp display
  - Search by customer or room
  - Sort by newest/oldest
  - Create form with numeric-only phone input
  - Edit and safe Delete (no swipe-to-delete)

## UX Notes
- Pink AppBar with white title
- Pink divider in booking cards
- Bottom navigation with grey outline

## Error/Loading Handling
- `FutureBuilder` shows progress and errors
- SnackBars display server-side error messages

