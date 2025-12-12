# 🤝 Contributing to Tulpars App

Thank you for your interest in contributing to the Tulpars Association Mobile Application! This document provides guidelines and information for contributors.

## 🚀 Getting Started

### Prerequisites
- Flutter 3.24.0+
- Dart 3.0+
- Android Studio or VS Code
- Git

### Setup
1. Fork the repository
2. Clone your fork: `git clone https://github.com/YOUR_USERNAME/Tulpars-App.git`
3. Install dependencies: `flutter pub get`
4. Run the app: `flutter run`

## 📋 Development Guidelines

### Code Style
- Follow [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- Use meaningful variable and function names
- Add comments for complex logic
- Keep functions small and focused

### Commit Messages
Use conventional commits format:
- `feat:` new features
- `fix:` bug fixes
- `docs:` documentation changes
- `style:` formatting changes
- `refactor:` code refactoring
- `test:` adding tests
- `chore:` maintenance tasks

Example: `feat: add biometric authentication support`

### Branch Naming
- `feature/feature-name` for new features
- `fix/bug-description` for bug fixes
- `docs/documentation-update` for documentation

## 🧪 Testing

### Running Tests
```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test
flutter test test/specific_test.dart
```

### Test Requirements
- Write unit tests for business logic
- Write widget tests for UI components
- Maintain test coverage above 80%

## 🔄 Pull Request Process

1. **Create a branch** from `develop`
2. **Make your changes** following the guidelines
3. **Add tests** for new functionality
4. **Run tests** and ensure they pass
5. **Update documentation** if needed
6. **Create a pull request** to `develop` branch

### PR Checklist
- [ ] Code follows style guidelines
- [ ] Self-review completed
- [ ] Tests added and passing
- [ ] Documentation updated
- [ ] No new warnings or errors

## 🐛 Reporting Issues

### Bug Reports
Use the bug report template and include:
- Clear description of the issue
- Steps to reproduce
- Expected vs actual behavior
- Screenshots if applicable
- Environment details

### Feature Requests
Use the feature request template and include:
- Clear description of the feature
- Use case and motivation
- Proposed implementation (if any)

## 📱 App Architecture

### Structure
```
lib/
├── core/           # Core functionality
├── presentation/   # UI and state management
└── main.dart      # App entry point
```

### State Management
- Uses BLoC pattern
- Follow clean architecture principles
- Separate business logic from UI

### Key Technologies
- **Flutter**: UI framework
- **BLoC**: State management
- **Firebase**: Backend services
- **Hive**: Local storage
- **Dio**: HTTP client

## 🔒 Security Guidelines

- Never commit sensitive data (API keys, passwords)
- Use secure storage for sensitive information
- Validate all user inputs
- Follow OWASP mobile security guidelines

## 📚 Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Documentation](https://dart.dev/guides)
- [BLoC Documentation](https://bloclibrary.dev)
- [Firebase Documentation](https://firebase.google.com/docs)

## 💬 Community

- Create issues for bugs and feature requests
- Join discussions in pull requests
- Be respectful and constructive

## 📄 License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

Thank you for contributing to Tulpars App! 🚀