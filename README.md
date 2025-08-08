# Insights App

A Flutter web application that simulates Instagram Insights with editable metrics and interactive dashboards.

## Features

- **Profile Page**: Main entry point with editable profile information
- **Reel Insights**: View and edit detailed analytics for Instagram reels
- **Professional Dashboard**: Overview of account performance metrics
- **Interactive Editing**: Toggle edit mode to modify all metrics
- **Real-time Updates**: Changes are saved automatically
- **Responsive Design**: Works on desktop and mobile browsers

## Getting Started

### Prerequisites

- Flutter SDK (3.8.1 or higher)
- Chrome or Edge browser
- Git (optional)

### Installation

1. **Clone or download the project**
   ```bash
   git clone <repository-url>
   cd Insights-App
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   
   **Option A: Using the batch file (Windows)**
   ```bash
   run_app.bat
   ```
   Then select option 1 for Chrome or option 2 for Edge.

   **Option B: Using command line**
   ```bash
   # For Chrome
   flutter run -d chrome --web-port=8080
   
   # For Edge
   flutter run -d edge --web-port=8080
   
   # Build for production
   flutter build web
   ```

### How to Use

1. **Profile Page**: The main entry point showing your Instagram profile
   - **Edit Mode**: Tap the invisible edit button (top-right area) to enable editing
   - **Profile Picture**: Click on profile picture when in edit mode to upload custom image
   - **Editable Fields**: Username, bio, follower counts, and view statistics
   - **Professional Dashboard**: Click the dashboard section to view detailed analytics
   - **Reel Navigation**: Click on reel icons in the grid to view reel insights

2. **Reel Insights**: 
   - View detailed analytics for a specific reel
   - Toggle edit mode (top-right switch) to modify metrics
   - Click on the reel thumbnail to upload a custom image
   - All changes are automatically saved

3. **Professional Dashboard**: 
   - View account-wide performance metrics
   - Edit metrics in real-time
   - Navigate to detailed views pages

### Key Features

- **Edit Mode**: Tap the invisible edit button to enable editing on profile page
- **Image Upload**: Click on profile picture or reel thumbnails to upload custom images
- **Auto-save**: All changes are automatically saved to local storage
- **Responsive**: Works on all screen sizes
- **Dark Theme**: Instagram-inspired dark interface
- **Navigation Flow**: Profile → Professional Dashboard → Views Page

### Navigation Structure

```
Profile Page (Main Entry)
├── Professional Dashboard (Click dashboard section)
│   └── Views Page (Detailed analytics)
└── Reel Insights (Click reel icons in grid)
    └── Views Page (Reel-specific analytics)
```

### Troubleshooting

**If you encounter errors:**

1. **Flutter not found**: Install Flutter SDK from https://flutter.dev
2. **Dependencies missing**: Run `flutter pub get`
3. **Build errors**: Run `flutter clean` then `flutter pub get`
4. **Browser issues**: Try a different browser or use `flutter build web`

**Common Commands:**
```bash
flutter doctor          # Check Flutter installation
flutter pub get         # Install dependencies
flutter clean           # Clean build cache
flutter test            # Run tests
flutter build web       # Build for production
```

### Project Structure

```
lib/
├── main.dart                    # Main app entry point
├── profile_page.dart            # Profile page (main entry)
├── professional_dashboard.dart   # Professional dashboard page
├── views_page.dart             # Detailed views page
└── cache_service.dart          # Local storage service

assets/
├── icons/                      # App icons
└── images/                     # App images

test/
└── widget_test.dart            # App tests
```

### Dependencies

- `flutter_svg`: For SVG icon support
- `shared_preferences`: For local data storage
- `http`: For network requests (if needed)
- `image_picker`: For image upload functionality

## Support

If you encounter any issues:
1. Check that Flutter is properly installed
2. Ensure all dependencies are installed (`flutter pub get`)
3. Try running `flutter doctor` to diagnose issues
4. Clear cache with `flutter clean` if needed

The app should now work perfectly! 🎉
