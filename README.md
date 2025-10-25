# 🍽️ Recipee - Recipe Discovery App

A modern iOS app built with SwiftUI that helps users discover and explore recipes from around the world. Browse recipes by categories, origins, and ingredients with a beautiful, intuitive interface.

## ✨ Features

### 🎯 Core Functionality
- **Recipe Discovery**: Browse thousands of recipes from TheMealDB API
- **Category Browsing**: Explore recipes by food categories (Dessert, Beef, Chicken, etc.)
- **Origin-based Search**: Find recipes by their country of origin
- **Detailed Recipe Views**: Complete ingredient lists, instructions, and meal information
- **Search Functionality**: Find specific recipes quickly
- **Modern UI**: Beautiful, responsive design with smooth animations

### 🎨 User Interface
- **Tab-based Navigation**: Easy switching between different sections
- **Grid & List Views**: Multiple viewing options for recipes
- **Smooth Animations**: Spring-based transitions and matched geometry effects
- **Dark Mode Support**: Automatic theme switching
- **Accessibility**: VoiceOver support and accessibility labels

### 🔧 Technical Features
- **MVVM Architecture**: Clean separation of concerns
- **Async/Await**: Modern Swift concurrency
- **Combine Framework**: Reactive programming patterns
- **Custom Components**: Reusable UI components
- **Error Handling**: Comprehensive error states and user feedback

## 🏗️ Architecture

### Project Structure
```
Recipee/
├── Models/                    # Data models
│   ├── Category.swift
│   ├── Meal.swift
│   ├── DetailedMeal.swift
│   └── Origin.swift
├── ViewModels/               # Business logic
│   ├── Categories/
│   │   ├── MealCategoriesViewModel.swift
│   │   └── OriginsViewModel.swift
│   └── Meals/
│       ├── MealViewModel.swift
│       └── DetailedMealViewModel.swift
├── Views/                    # UI Components
│   ├── MainViews/           # Main app screens
│   ├── CustomViews/         # Reusable components
│   ├── DetailViews/         # Recipe detail screens
│   ├── RowViews/           # List item components
│   └── ErrorViews/         # Error state screens
├── Helpers/                 # Utilities
│   ├── NetworkLayer.swift
│   ├── MealDBEndpoint.swift
│   └── ViewModifiers/
└── Extensions/             # Swift extensions
    ├── ColorExtensions.swift
    └── ViewExtensions.swift
```

### Design Patterns
- **MVVM (Model-View-ViewModel)**: Clean architecture with separated concerns
- **Repository Pattern**: Centralized data management
- **Observer Pattern**: Reactive UI updates with Combine
- **Factory Pattern**: Dynamic view creation

## 🚀 Getting Started

### Prerequisites
- Xcode 15.0 or later
- iOS 17.0 or later
- Swift 5.9 or later

### Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/recipee.git
   cd recipee
   ```

2. Open the project in Xcode:
   ```bash
   open Recipee.xcodeproj
   ```

3. Build and run the project (⌘+R)

### API Configuration
The app uses [TheMealDB API](https://www.themealdb.com/api.php) for recipe data. No API key is required for basic functionality.

## 📱 Screenshots

### Main Features
- **Categories View**: Browse recipes by food categories
- **Origins View**: Explore recipes by country
- **Search**: Find specific recipes
- **Recipe Details**: Complete recipe information

## 🛠️ Technical Implementation

### Key Components

#### Enhanced Tab Navigation
```swift
// Modern tab design with sliding animations
struct CategoriesTabItem: View {
    // Matched geometry effects for smooth transitions
    // Spring animations for natural feel
    // Accessibility support
}
```

#### Network Layer
```swift
// Async/await network requests
class NetworkService: NetworkServiceProtocol {
    func fetch<T: Codable>(_ type: T.Type, from endpoint: MealDBEndpoint) async throws -> T
}
```

#### ViewModels
```swift
// Reactive state management
@Published var categories: [Category] = []
@Published var state: LoadingState = .idle
```

### Animation System
- **Spring Animations**: Natural, physics-based transitions
- **Matched Geometry Effects**: Smooth morphing between states
- **Custom Transitions**: Tailored animations for each interaction

## 🎨 Design System

### Colors
- **System Colors**: Automatic light/dark mode support
- **Accent Colors**: Consistent theming throughout
- **Semantic Colors**: Meaningful color usage

### Typography
- **System Fonts**: SF Pro with rounded design
- **Hierarchy**: Clear text hierarchy with proper weights
- **Accessibility**: Dynamic type support

### Spacing
- **Consistent Padding**: 8pt grid system
- **Responsive Layout**: Adapts to different screen sizes
- **Touch Targets**: Minimum 44pt touch areas

## 🔧 Development

### Code Style
- **SwiftUI Best Practices**: Modern declarative syntax
- **Documentation**: Comprehensive code comments
- **Error Handling**: Graceful error states
- **Performance**: Optimized for smooth scrolling

### Testing
- **Unit Tests**: ViewModel logic testing
- **UI Tests**: User interaction testing
- **Accessibility**: VoiceOver compatibility

## 📦 Dependencies

- **No External Dependencies**: Pure SwiftUI implementation
- **System Frameworks**: Foundation, SwiftUI, Combine
- **iOS APIs**: Network, Accessibility, Haptics

## 🚀 Future Enhancements

### Planned Features
- [ ] **Favorites System**: Save favorite recipes
- [ ] **Offline Support**: Cache recipes for offline viewing
- [ ] **Recipe Sharing**: Share recipes with friends
- [ ] **Nutritional Information**: Detailed nutrition facts
- [ ] **Cooking Timer**: Built-in cooking timers
- [ ] **Shopping Lists**: Generate shopping lists from recipes

### Technical Improvements
- [ ] **Core Data Integration**: Local data persistence
- [ ] **Widget Support**: iOS home screen widgets
- [ ] **Apple Watch App**: Recipe viewing on watch
- [ ] **Siri Integration**: Voice-activated recipe search

## 🤝 Contributing

We welcome contributions! Please follow these guidelines:

1. **Fork the repository**
2. **Create a feature branch**: `git checkout -b feature/amazing-feature`
3. **Commit your changes**: `git commit -m 'Add amazing feature'`
4. **Push to the branch**: `git push origin feature/amazing-feature`
5. **Open a Pull Request**

### Code Guidelines
- Follow Swift style guidelines
- Add documentation for new features
- Include tests for new functionality
- Ensure accessibility compliance

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👨‍💻 Author

**Ömer Köse**
- GitHub: [@omerkose](https://github.com/omerkose)
- LinkedIn: [Ömer Köse](https://linkedin.com/in/omerkose)

## 🙏 Acknowledgments

- [TheMealDB](https://www.themealdb.com/) for providing the recipe API
- Apple for SwiftUI framework
- The Swift community for best practices and inspiration

---

## 📱 App Store

*Coming soon to the App Store!*

---

**Made with ❤️ using SwiftUI**