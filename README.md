# 🍽️ Recipee - Recipe Discovery App

A modern iOS app built with SwiftUI that helps users discover and explore recipes from around the world. Browse recipes by categories, origins, and ingredients with a beautiful, intuitive interface.

## ✨ Features

### Core Functionality
- **Recipe Discovery**: Browse thousands of recipes from TheMealDB API
- **Category Browsing**: Explore recipes by food categories (Dessert, Beef, Chicken, etc.)
- **Origin-based Search**: Find recipes by their country of origin
- **Ingredient Exploration**: Browse and search through available ingredients
- **Detailed Recipe Views**: Complete ingredient lists, instructions, and meal information
- **Alphabetical Navigation**: Quick navigation with letter-based filters and scroll bar

### Search & Discovery
- **Comprehensive Search**: Search across meals, categories, origins, ingredients, and favorites
- **Search Filters**: Customize search to include/exclude specific content types
- **Search History**: Track recent searches with up to 20 items
- **Auto-Suggestions**: Smart suggestions from history and favorites while typing
- **Collapsible Sections**: Organize long search results with expandable sections
- **Smart Results**: The top result section expands automatically for better UX

### Personalization
- **Favorites System**: Save favorite meals and categories
- **Persistent Favorites**: Your favorites are saved locally using UserDefaults
- **Settings Customization**: Configure search behavior, appearance preferences

### User Experience
- **Modern UI**: Beautiful, responsive design with smooth animations
- **Dark Mode Support**: Automatic theme switching
- **Native iOS Design**: Uses system components and design language
- **Accessibility**: VoiceOver support and accessibility labels
- **Smooth Animations**: Spring-based transitions and matched geometry effects
- **Task Deduplication**: Prevents multiple simultaneous network requests

## 🏗️ Architecture

### Project Structure
```
Recipee/
├── Models/                    # Data models (Category, Origin, Meal, Ingredient, etc.)
├── ViewModels/               # Business logic (MVVM architecture)
│   ├── Categories/          # MealCategoriesViewModel, OriginsViewModel
│   ├── Meals/               # MealViewModel, DetailedMealViewModel
│   ├── Ingredients/         # IngredientsViewModel
│   ├── Favorites/           # FavoritesViewModel
│   └── Search/              # SearchViewModel
├── Views/                    # UI Components
│   ├── MainViews/           # Main app screens (Tabs, ContentView)
│   │   ├── Categories/      # CategoriesView, MealCategoriesGridView, OriginsListView
│   │   ├── Search/          # SearchView, SearchResultsView, SearchFiltersView
│   │   ├── Settings/        # SettingsView, AboutView, etc.
│   │   ├── Favorites/       # FavoritesView
│   │   └── Ingredients/     # AllIngredientsListView
│   ├── DetailViews/         # MealDetailView, IngredientDetailView
│   ├── CustomViews/         # Reusable components (LoadingView, FavoriteButton, etc.)
│   ├── RowViews/           # List item components
│   └── ErrorViews/         # Error state displays
├── Network/                 # Network layer
│   ├── NetworkLayer.swift   # Network service and error handling
│   └── MealDBEndpoint.swift # API endpoints
├── Helpers/                 # Utilities
│   └── Constants.swift      # App constants
├── Tests/                   # Unit Tests
│   ├── ViewModels/          # ViewModel tests
│   └── Mocks/               # Mock services
├── Extensions/             # Swift extensions (Colors, Views)
└── Assets.xcassets/        # App icons and images
```

### Technical Stack
- **SwiftUI**: Modern declarative UI framework
- **MVVM Architecture**: Clean separation of concerns with well-documented ViewModels
- **Async/Await**: Modern Swift concurrency for network operations
- **Combine Framework**: Reactive programming patterns for debounced search
- **TheMealDB API**: Comprehensive recipe data source
- **UserDefaults**: Local persistence for favorites and preferences
- **Task Management**: Proper cancellation and deduplication of network tasks
- **NavigationStack**: Modern navigation with deep linking support

## 🚀 Getting Started

### Prerequisites
- Xcode 16.0 or later
- iOS 17.0 or later
- macOS 14.0 (Sonoma) or later (for development)

### Installation
1. Clone the repository
2. Open `Recipee.xcodeproj` in Xcode
3. Build and run the project (⌘+R)

## 🎨 Key Features in Detail

### Main Tab Navigation
- **Browse Tab**: Explore by categories, origins, and ingredients
- **Search Tab**: Comprehensive search with filters and suggestions
- **Favorites Tab**: Quick access to saved meals and categories
- **Settings Tab**: Customize app behavior and appearance

### Search System
- **Debounced Live Search**: Automatic search as you type (300ms delay)
- **Multi-source Search**: Searches meals, categories, origins, ingredients, and favorites
- **Filter Management**: Sheet-based filter selection for content types
- **History & Suggestions**: Up to 20 recent searches with smart suggestions
- **Collapsible Results**: Expandable sections to manage long result lists

### Favorites Management
- **Persistent Storage**: UserDefaults-based persistence
- **Dual Categories**: Save both meals and categories as favorites
- **Toggle Actions**: One-tap favorite/unfavorite functionality
- **Clear All**: Bulk deletion of all favorites from settings

### Networking & Performance
- **Task Deduplication**: Prevents multiple simultaneous requests
- **Cancellation Handling**: Proper cleanup of cancelled tasks
- **Error Recovery**: User-friendly error messages with retry options
- **Loading States**: Clear visual feedback during data fetching

### UI/UX Enhancements
- **Native Segmented Control**: System picker for tab switching
- **Alphabet Navigation**: Letter-based filtering with quick jump navigation
- **Letter Selector**: Visual letter selection for meal browsing
- **Collapsible Sections**: Better organization of long lists
- **Consistent Theming**: System colors for light/dark mode support

## 🔧 Development

### Code Style
- SwiftUI best practices with modern declarative syntax
- Comprehensive documentation with Swift DocC comments
- Proper MARK organization for code navigation
- Performance optimized for smooth scrolling with LazyVStack/LazyVGrid
- Accessibility compliance with VoiceOver support
- Consistent naming conventions and code structure

### Dependencies
- **No External Dependencies**: Zero third-party frameworks
- **Pure SwiftUI**: Native iOS implementation
- **System Frameworks Only**: Foundation, SwiftUI, Combine
- **Network Layer**: Custom URLSession-based implementation

## 📄 License

This project is licensed under the MIT License.

## 🙏 Acknowledgments

- [TheMealDB](https://www.themealdb.com/) for providing the recipe API
- Apple for SwiftUI framework
- The Swift community for best practices and inspiration

---

**Made with ❤️ using SwiftUI**
