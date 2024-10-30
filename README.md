# Flutter Finance

Flutter Finance is a mobile application built with Flutter that helps users track expenses and manage credit cards efficiently.

## Features

- User authentication (registration and login)
- Manage credit cards (add, edit, view)
- Track expenses and spending patterns
- Firebase integration for backend services

## Getting Started

### Prerequisites

- Flutter SDK installed
- Dart SDK installed
- Firebase account
- IDE like Android Studio or Visual Studio Code

### Installation

1. **Clone the repository:**

   ```bash
   git clone https://github.com/yourusername/flutter-finance.
   ```

2. Navigate to the project directory:

   cd flutter-finance

3. Install dependencies:

   flutter pub get

4. Set up Firebase:

- Create a new project in Firebase Console.
- Enable Authentication and Firestore Database.
- Add google-services.json and GoogleService-Info.plist to the respective platform directories.
- Configure firebase_options.dart with your Firebase project settings.

#### Running the App

    flutter run

### Project Structure

- **lib/** - Main application code.
  - **model/** - Data models.
  - **view/** - UI components.
  - **services/** - Firebase and other services.
  - **modelview/** - View models for state management.
- **android/, ios/, macos/, windows/** - Platform-specific code.

### Contributing

Contributions are welcome. Please fork the repository and create a pull request.

### License

This project is licensed under the MIT License. ```
