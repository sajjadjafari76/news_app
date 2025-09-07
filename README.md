# News App

A clean-architecture Flutter app built with **GetX** that fetches and displays top headlines from the News API. The app demonstrates modern Flutter development practices with a focus on maintainability, testability, and scalability.

## 🏗️ Architecture Overview

This project follows **Clean Architecture** principles with a clear separation of concerns across multiple layers:

### Architecture Layers

```
┌─────────────────────────────────────────────────────────────┐
│                    Presentation Layer                       │
│  ┌─────────────────┐  ┌─────────────────┐  ┌──────────────┐ │
│  │   Controllers   │  │     Pages       │  │   Widgets    │ │
│  │   (GetX)        │  │   (UI)          │  │  (Reusable)  │ │
│  └─────────────────┘  └─────────────────┘  └──────────────┘ │
└─────────────────────────────────────────────────────────────┘
┌─────────────────────────────────────────────────────────────┐
│                    Application Layer                        │
│  ┌─────────────────┐  ┌─────────────────┐  ┌──────────────┐ │
│  │   Use Cases     │  │    Services     │  │  Algorithms  │ │
│  │  (Business      │  │  (Orchestration)│  │  (Sorting)   │ │
│  │   Logic)        │  │                 │  │              │ │
│  └─────────────────┘  └─────────────────┘  └──────────────┘ │
└─────────────────────────────────────────────────────────────┘
┌─────────────────────────────────────────────────────────────┐
│                      Domain Layer                           │
│  ┌─────────────────┐  ┌─────────────────┐  ┌──────────────┐ │
│  │    Entities     │  │   Repositories  │  │   Failures   │ │
│  │  (Business      │  │   (Interfaces)  │  │  (Error      │ │
│  │   Objects)      │  │                 │  │   Handling)  │ │
│  └─────────────────┘  └─────────────────┘  └──────────────┘ │
└─────────────────────────────────────────────────────────────┘
┌─────────────────────────────────────────────────────────────┐
│                       Data Layer                            │
│  ┌─────────────────┐  ┌─────────────────┐  ┌──────────────┐ │
│  │   Data Sources  │  │    Models       │  │ Repositories │ │
│  │  (API/Local)    │  │  (JSON/DB)      │  │ (Implementation)│ │
│  └─────────────────┘  └─────────────────┘  └──────────────┘ │
└─────────────────────────────────────────────────────────────┘
```

## 🎯 Design Patterns & Principles

### 1. Clean Architecture
- **Dependency Inversion**: High-level modules don't depend on low-level modules
- **Separation of Concerns**: Each layer has a single responsibility
- **Testability**: Business logic is isolated and easily testable

### 2. SOLID Principles
- **Single Responsibility Principle (SRP)**: Each class has one reason to change
- **Open/Closed Principle (OCP)**: Open for extension, closed for modification
- **Liskov Substitution Principle (LSP)**: Derived classes are substitutable for base classes
- **Interface Segregation Principle (ISP)**: Clients shouldn't depend on unused interfaces
- **Dependency Inversion Principle (DIP)**: Depend on abstractions, not concretions

### 3. State Management: GetX
- **Reactive Programming**: Observable variables with automatic UI updates
- **Dependency Injection**: Built-in DI container for managing dependencies
- **Route Management**: Declarative routing with bindings
- **Performance**: Minimal boilerplate with excellent performance

### 4. Repository Pattern
- **Data Abstraction**: Abstracts data access logic
- **Caching Strategy**: Implements offline-first approach with fallback
- **Error Handling**: Centralized error management with Either pattern

## 🛠️ Technology Stack

### Core Dependencies
- **Flutter**: Cross-platform UI framework
- **GetX**: State management, routing, and dependency injection
- **Dio**: HTTP client with interceptors and error handling
- **Hive**: Local database for caching
- **Get Storage**: Lightweight key-value storage

### Development Tools
- **Build Runner**: Code generation for Hive adapters
- **Mocktail**: Testing with mock objects
- **Flutter Lints**: Code quality and style enforcement

### External Services
- **News API**: Real-time news data from multiple sources
- **Environment Variables**: Secure API key management

## 📁 Project Structure

```
lib/
├── core/                           # Shared utilities and base classes
│   ├── constants/                  # App-wide constants
│   ├── errors/                     # Error handling utilities
│   ├── extension/                  # Dart extensions
│   ├── model/                      # Base response models
│   ├── network/                    # HTTP client configuration
│   ├── repository/                 # Base repository classes
│   ├── routes/                     # App routing configuration
│   ├── storage/                    # Storage abstractions
│   ├── usecase/                    # Base use case classes
│   └── widget/                     # Reusable widgets
└── feature/
    └── news/                       # News feature module
        ├── application/            # Business logic layer
        │   ├── params/             # Request parameters
        │   ├── services/           # Business services
        │   └── usecases/           # Use case implementations
        ├── data/                   # Data layer
        │   ├── datasource/         # Data sources (API/Local)
        │   ├── models/             # Data models
        │   └── repository/         # Repository implementations
        ├── domain/                 # Domain layer
        │   ├── entities/           # Business entities
        │   ├── failure/            # Error definitions
        │   └── repository/         # Repository interfaces
        └── presentation/           # Presentation layer
            ├── bindings/           # GetX dependency bindings
            ├── controller/         # GetX controllers
            ├── page/               # UI pages
            └── widgets/            # Feature-specific widgets
```

## 🔄 Data Flow

1. **User Interaction** → Controller receives user action
2. **Controller** → Calls appropriate Use Case
3. **Use Case** → Orchestrates business logic via Services
4. **Service** → Coordinates Repository calls
5. **Repository** → Manages data sources (API/Local)
6. **Data Source** → Fetches data from external API or local storage
7. **Response** → Flows back through layers with proper error handling
8. **UI Update** → GetX reactive variables trigger UI rebuilds

## 🚀 Key Features

### 1. Multi-Company News Aggregation
- Fetches news from Microsoft, Apple, Google, and Tesla
- Implements intelligent sorting algorithms
- Provides unified news feed experience

### 2. Offline-First Architecture
- **Primary**: Fetch from News API
- **Fallback**: Serve cached data when offline
- **Caching**: Automatic caching with Hive database
- **Resilience**: Graceful degradation on network failures

### 3. Advanced Error Handling
- **Either Pattern**: Functional error handling with `either_dart`
- **Custom Exceptions**: Typed exceptions for different error scenarios
- **User-Friendly Messages**: Transformed technical errors to user messages
- **Retry Logic**: Automatic retry mechanisms for transient failures

### 4. Performance Optimizations
- **Lazy Loading**: Controllers initialize only when needed
- **Memory Management**: Proper disposal of resources
- **Efficient Caching**: Smart cache invalidation strategies
- **Minimal Rebuilds**: GetX reactive programming reduces unnecessary UI updates

## 🔧 Configuration & Setup

### Environment Setup
1. Create `.env` file in project root:
```env
NEWS_API_KEY=your_news_api_key_here
```

2. Install dependencies:
```bash
flutter pub get
```

3. Generate code (for Hive adapters):
```bash
flutter packages pub run build_runner build
```

### API Configuration
- **Base URL**: `https://newsapi.org/v2`
- **Timeout**: 1 minute for all requests
- **Authentication**: API key via query parameters
- **Rate Limiting**: Handled by News API service

## 🧪 Testing Strategy

### Unit Testing
- **Use Cases**: Business logic testing
- **Repositories**: Data access layer testing
- **Services**: Business service testing
- **Algorithms**: Sorting algorithm testing

### Integration Testing
- **API Integration**: End-to-end API testing
- **Database**: Hive storage testing
- **Error Scenarios**: Failure case testing

### Test Structure
```
test/
├── unit/
│   ├── algorithms/         # Algorithm testing
│   ├── datasources/        # Data source testing
│   ├── repositories/       # Repository testing
│   └── usecases/          # Use case testing
```

## 🔒 Security Considerations

### API Security
- **Environment Variables**: API keys stored securely
- **HTTPS Only**: All network requests use secure connections
- **Input Validation**: Proper parameter validation
- **Error Sanitization**: No sensitive data in error messages

### Data Protection
- **Local Storage**: Encrypted local database
- **Memory Management**: Sensitive data cleared from memory
- **Network Security**: Certificate pinning considerations

## 🚀 Future Enhancements

### Planned Features
1. **Search Functionality**: Full-text search across cached news
2. **Categories**: News categorization and filtering
3. **Bookmarks**: Save favorite articles
4. **Push Notifications**: Breaking news alerts
5. **Dark Mode**: Theme switching capability
6. **Internationalization**: Multi-language support

### Technical Improvements
1. **Image Caching**: Implement image caching for better performance
2. **Pagination**: Infinite scroll for large news lists
3. **Analytics**: User behavior tracking
4. **Crash Reporting**: Error monitoring and reporting
5. **Performance Monitoring**: App performance metrics

## 📱 Platform Support

- **Android**: Full support with Material Design
- **iOS**: Full support with Cupertino design elements
- **Web**: Progressive Web App capabilities
- **Desktop**: Windows, macOS, and Linux support

## 🤝 Contributing

1. Follow Clean Architecture principles
2. Maintain test coverage above 80%
3. Use conventional commit messages
4. Update documentation for new features
5. Follow Flutter/Dart style guidelines

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

---

**Built with ❤️ using Flutter and Clean Architecture principles**