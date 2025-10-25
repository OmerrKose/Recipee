# 🍽️ Recipee - Recipe Discovery App

A modern iOS app built with SwiftUI that helps users discover and explore recipes from around the world. Browse recipes by categories, origins, and ingredients with a beautiful, intuitive interface.

## ✨ Features

- **Recipe Discovery**: Browse thousands of recipes from TheMealDB API
- **Category Browsing**: Explore recipes by food categories (Dessert, Beef, Chicken, etc.)
- **Origin-based Search**: Find recipes by their country of origin
- **Detailed Recipe Views**: Complete ingredient lists, instructions, and meal information
- **Search Functionality**: Find specific recipes quickly
- **Modern UI**: Beautiful, responsive design with smooth animations
- **Dark Mode Support**: Automatic theme switching
- **Accessibility**: VoiceOver support and accessibility labels

## 🏗️ Architecture

### Project Structure
```
Recipee/
├── Models/                    # Data models
├── ViewModels/               # Business logic (MVVM)
├── Views/                    # UI Components
│   ├── MainViews/           # Main app screens
│   ├── CustomViews/         # Reusable components
│   ├── DetailViews/         # Recipe detail screens
│   └── RowViews/           # List item components
├── Helpers/                 # Utilities and networking
└── Extensions/             # Swift extensions
```

### Technical Stack
- **SwiftUI**: Modern declarative UI framework
- **MVVM Architecture**: Clean separation of concerns
- **Async/Await**: Modern Swift concurrency
- **Combine Framework**: Reactive programming patterns
- **TheMealDB API**: Recipe data source

## 🚀 Getting Started

### Prerequisites
- Xcode 15.0 or later
- iOS 17.0 or later

### Installation
1. Clone the repository
2. Open `Recipee.xcodeproj` in Xcode
3. Build and run the project (⌘+R)

## 🎨 Key Features

### Enhanced Tab Navigation
- Modern tab design with sliding animations
- Spring-based transitions for natural feel
- Matched geometry effects for smooth state changes

### Network Layer
- Async/await network requests
- Comprehensive error handling
- Reactive state management with Combine

### Animation System
- Spring animations for natural transitions
- Matched geometry effects for smooth morphing
- Custom transitions for each interaction

## 🔧 Development

### Code Style
- SwiftUI best practices
- Comprehensive error handling
- Performance optimized for smooth scrolling
- Accessibility compliance

### Dependencies
- No external dependencies
- Pure SwiftUI implementation
- System frameworks only

## 📱 Screenshots

*Coming soon...*

## 🚀 Future Enhancements

- Favorites system
- Offline support
- Recipe sharing
- Nutritional information
- Cooking timers
- Shopping lists

## 📄 License

This project is licensed under the MIT License.

## 🙏 Acknowledgments

- [TheMealDB](https://www.themealdb.com/) for providing the recipe API
- Apple for SwiftUI framework
- The Swift community for best practices and inspiration

---

**Made with ❤️ using SwiftUI**