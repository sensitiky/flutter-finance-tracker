# Flutter Finance

Flutter Finance is a cross-platform mobile application built with Flutter that helps users track expenses and manage credit cards efficiently. The app leverages Firebase for backend services and supports Android, iOS, macOS, Windows, Linux, and web platforms.

## Features

- **User Authentication**: Secure registration and login functionalities using Firebase Authentication.
- **Credit Card Management**: Add, edit, view, and delete credit cards.
- **Expense Tracking**: Monitor expenses and spending patterns with data visualization.
- **Spending Tips**: Get suggestions to improve spending habits.
- **Multi-Platform Support**: Runs on Android, iOS, macOS, Windows, Linux, and web browsers.

## Getting Started

### Prerequisites

- Flutter SDK installed
- Firebase account
- IDE like Android Studio or Visual Studio Code

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/sensitiky/flutter-finance-tracker
   ```
2. Navigate to the project directory:
   ```bash
   cd Flutter-finance
   ```
3. Install dependencies:
   ```bash
   flutter pub get
   ```
4. Set up Firebase:

   - Create a new project in the Firebase Console.
   - Enable Authentication and Firestore Database.

   For Android:

   - Add `google-services.json` to the `app` directory.

   For iOS:

   - Add `GoogleService-Info.plist` to the `Runner` directory.

   For Web:

   - Update `index.html` with your Firebase configuration.

5. Configure `firebase_options.dart` using the FlutterFire CLI:
   ```bash
   flutterfire configure
   ```

### Running the App

To run the app on a specific platform:

- **Android/iOS**:
  ```bash
  flutter run
  ```
- **Web**:
  ```bash
  flutter run -d chrome
  ```
- **Windows/macOS/Linux**:
  ```bash
  flutter run -d windows  # Replace windows with macos or linux depending on your platform.
  ```

## Project Structure

- `lib/` - Main application code.
- `components/` - Reusable widgets and UI components.
- `models/` - Data models used across the app.
- `services/` - Firebase and other backend services.
- `viewmodels/` - State management using Providers.
- `views/` - UI screens and pages.
- `test/` - Unit and widget tests.
- `Platform-specific directories` - Code specific to Android, iOS, web, etc.

## Contributing

Contributions are welcome! Please fork the repository, create a new branch, and submit a pull request.

## License

This project is licensed under the MIT License.
