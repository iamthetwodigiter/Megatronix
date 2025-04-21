# Megatronix - Official Mobile & Web App

A robust Flutter-based application implementing Clean Architecture principles, design patterns and industry best practices for a scalable, maintainable cross-platform solution.

![Megatronix](https://img.shields.io/badge/Megatronix-Tech%20Club-blue)
![Flutter](https://img.shields.io/badge/Flutter-3.27.3-blue)
![Dart](https://img.shields.io/badge/Dart-3.6.1-blue)
![Platforms](https://img.shields.io/badge/Platforms-Android%20%7C%20iOS%20%7C%20Web-orange)
![License](https://img.shields.io/badge/License-MIT-green)

## 📱 Overview

Megatronix is a comprehensive cross-platform application designed to streamline tech club operations, enhance member engagement, and simplify event management. The app provides a unified platform for event registration, team coordination, profile management, and communication, accessible on both mobile devices and web browsers.

## 🏗️ Architecture

The application implements **Clean Architecture** with clear separation of concerns:

### Three-Layer Architecture

```
┌─────────────────────────┐
│   Presentation Layer    │  ◄── UI, State Management, User Interaction
├─────────────────────────┤
│      Domain Layer       │  ◄── Business Logic, Entities, Use Cases
├─────────────────────────┤
│       Data Layer        │  ◄── API Integration, Local Storage, Data Models
└─────────────────────────┘
```

- **Domain Layer**
  - Pure Dart implementation with no external dependencies
  - Houses business logic, entities, and use cases
  - Defines abstract repository interfaces

- **Data Layer**
  - Repository implementations from domain layer
  - Data source management (API, local storage)
  - Data models with mapping to domain entities
  - Error handling and connectivity management

- **Presentation Layer**
  - Flutter UI implementation with responsive design
  - State management via Riverpod
  - Widget composition and screen navigation
  - User interaction handling
  - Adaptive UI for mobile and web platforms

### Project Structure

```
lib/
├── common/
│   ├── pages/               # Shared pages (splash, error screens)
│   ├── services/            # Cross-feature services
│   └── widgets/             # Reusable UI components
├── config/                  # Environment configuration
├── core/
│   ├── errors/              # Error handling & reporting
│   └── utils/               # Utility functions & extensions
├── features/                # Feature modules
│   ├── auth/                # Authentication & authorization
│   ├── contact/             # Query submission & support
│   ├── event_registration/  # Event signup & management
│   ├── events/              # Event discovery & details
│   ├── gallery/             # Media galleries
│   ├── home/                # Main dashboard & navigation
│   ├── main_registration/   # Member registration
│   ├── profile/             # User profile management
│   └── team/                # Team management & coordination
├── theme/                   # App theming & styling
└── main.dart                # Application entry point
```

Each feature follows the clean architecture pattern:

```
feature/
├── data/
│   ├── models/        # Data transfer objects
│   ├── repository/    # Repository implementations
│   └── services/      # API & local services
├── domain/
│   ├── entities/      # Business entities
│   ├── repository/    # Repository interfaces
│   └── usecases/      # Business logic encapsulation
├── presentation/
│   ├── notifier/      # State management
│   ├── pages/         # UI screens
|   |   └── web/       # UI screen for web
│   └── widgets/       # Feature-specific widgets
└── providers          # Dependency injection
```

## 🔑 Key Features

### Cross-Platform Support
- **Responsive Design**
  - Adaptive layouts for mobile and web platforms
  - Optimized user experience across device sizes
  - Platform-specific interaction patterns
  - Consistent design language across platforms

### User Management
- **Authentication & Authorization**
  - JWT-based secure authentication
  - Role-based access control
  - Persistent login sessions
  - Secure credential storage

- **Profile Management**
  - User profile creation and management

### Event Ecosystem
- **Event Discovery**
  - Domain-based event listings
  - Event details and schedules
  - Location mapping

- **Event Registration**
  - Streamlined registration process
  - Payment gateway integration (planned)

### Team Collaboration
- **Team Management**
  - Hierarchical team structure
  - Role-based permissions
  - Team communication channels

- **Media Gallery**
  - Event photo galleries
  - Optimized image loading and caching

### Communication
- **Contact & Support**
  - Direct messaging to administrators
  - Feedback submission
  - Announcement notifications

## 🛠️ Technical Implementation

### State Management & Dependency Injection
The application leverages **Riverpod** for efficient state management and dependency injection:

```dart
// Service Provider
final authServiceProvider = Provider<AuthService>((ref) => AuthService());

// Repository Provider with Dependencies
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final authServices = ref.watch(authServiceProvider);
  return AuthRepositoryImpl(authServices);
});

// State Notifier for UI State
final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthNotifier(authRepository);
});
```

### Technical Stack

| Category | Technologies |
|----------|--------------|
| **Framework** | Flutter 3.27.3 |
| **Language** | Dart 3.6.1 |
| **Platforms** | Android, iOS, Web |
| **State Management** | Riverpod |
| **Networking** | HTTP package, RESTful API integration |
| **Storage** | Secure Storage, IndexedDB (web) |
| **Media** | Cached Network Image |
| **UI Enhancement** | Lottie Animations |
| **Notifications** | OneSignal, Web Push API |
| **Analytics** | Firebase Analytics (planned) |
| **Testing** | Unit Tests, Widget Tests, Integration Tests |
| **Web Deployment** | Vercel Hosting |

### Web Implementation
- **Responsive layouts** using Flutter's adaptive widgets and custom breakpoints
- **Browser compatibility** across Chrome, Firefox, Safari, and Edge
- **Web-specific optimizations** for rendering performance and bundle size

### Design Patterns

1. **Repository Pattern**
   - Abstracts data sources behind consistent interfaces
   - Simplifies switching between mock data and production APIs
   - Enhances testability through dependency injection

2. **Provider Pattern**
   - Centralized dependency injection
   - Scoped state management
   - Service locator pattern implementation

3. **Entity-Model Pattern**
   - Clear separation between domain entities and data models
   - Bidirectional mapping between layers
   - Data integrity preservation

4. **Adaptive UI Pattern**
   - Platform-aware widget selection
   - Responsive layout construction
   - Device capability detection

### Error Handling Strategy

The application implements a comprehensive error handling system:

```dart
class AppErrorHandler {
  static void showError(
    BuildContext context,
    String title,
    String description, {
    ToastificationType type = ToastificationType.error,
  }) {
    String title = "Error";
    if (description.contains("Unauthorized")) {
      title = "Unauthorized Access";
    } else if (description.contains("Not Found")) {
      title = "Resource Not Found";
    }
    // ... error handling implementation
  }
}
```

The application features robust error handling logic for all standard HTTP status codes returned by the server:

- **2xx Success Codes**: Proper response parsing and data extraction
- **400 Bad Request**: User-friendly validation messages for form inputs
- **401 Unauthorized**: Automatic token refresh attempts with graceful auth flow redirection
- **403 Forbidden**: Clear permission explanation with contextual guidance
- **404 Not Found**: Resource-specific messaging with recovery options
- **429 Too Many Requests**: Rate limiting information with retry-after guidance
- **500 Server Error**: Graceful degradation with offline functionality where possible
- **503 Service Unavailable**: Maintenance mode detection with estimated resolution time
- **504 Gateway Timeout**: Intelligent request retry with exponential backoff and user notification for extended server processing delays.

Each error scenario includes appropriate UI feedback, logging for debugging, and recovery paths where applicable.

### Security Implementation

- **Authentication**: JWT token management
- **Secure Storage**: Encrypted storage for sensitive information (IndexedDB for web)
- **Input Validation**: Client-side validation with server validation backup
- **CORS Handling**: Proper cross-origin resource sharing for web implementation
- **Proactive Error Handling**: Prevention of information leakage through errors
- **Code Obfuscation**: Application hardening for release builds

### Performance Optimizations

- **Lazy Loading**: On-demand resource loading to minimize initial load time
- **Image Optimization**: Progressive loading and caching of images
- **Memory Management**: Proper disposal of resources to prevent memory leaks
- **State Management**: Efficient UI updates with minimal rebuilds
- **Network Optimization**: Request batching and response caching

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.x or higher)
- Android Studio / VS Code with Flutter plugins
- Android SDK / Xcode (for iOS development)
- Chrome / Firefox (for web development)
- Git

### Installation

1. Clone the repository:
```bash
git clone https://github.com/iamthetwodigiter/Megatronix.git
cd Megatronix
```

2. Install dependencies:
```bash
flutter pub get
```

3. Configure environment:
   Create `lib/config/config.dart` from the template and update with your environment variables

4. Run the application:
```bash
# For mobile
flutter run

# For web
flutter run -d chrome
```

### Web Deployment

1. Build the web application:
```bash
flutter build web --release
```

### Development Setup

Create a `config.dart` file in `lib/config/` with your environment variables:

```dart
class Config {
  static const String apiBaseURL = 'YOUR_API_BASE_URL';
  static const String oneSignalAppID = 'YOUR_ONESIGNAL_APP_ID';
}
```

## 📊 Project Roadmap

- **Phase 1**: Core functionality and UI implementation ✅
- **Phase 2**: Enhanced event management and registration system ✅
- **Phase 3**: Team collaboration features and media galleries ✅
- **Phase 4**: Web platform support and responsive design ✅
- **Phase 5**: Analytics integration and performance optimization 🔄
- **Phase 6**: Payment gateway integration and e-commerce features 🔄
- **Phase 7**: Advanced web features (offline support, push notifications) 🔄

## 🧪 Testing Strategy

- **Unit Tests**: Business logic and repository implementations
- **Widget Tests**: Component rendering and interaction testing
- **Integration Tests**: End-to-end flow validation
- **Cross-platform Testing**: Validation across mobile and web platforms
- **Browser Compatibility Testing**: Testing across major web browsers

## 👥 Contributors

- [Prabhat Jana](https://github.com/iamthetwodigiter) - Lead Developer

## 🔄 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📜 License

This project is licensed under the MIT License - see the LICENSE file for details.

---

Developed with ❤️ by [thetwodigiter](https://github.com/iamthetwodigiter)