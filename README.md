# Shiksha

An AI-powered marketing campaign generator for the education sector. Create high-converting, emotionally resonant marketing campaigns in seconds.

## Features

- **Campaign Generator** — AI-powered form to generate marketing campaigns with customizable topic, target country, language/style, and phone number
- **Marketing Studio** — Dashboard for managing and editing marketing content
- **My Campaigns** — View and manage all your created campaigns
- **Profile** — Account info, phone/WhatsApp verification, and settings

## Screenshots

The app includes:
- Animated splash screen with Shiksha branding
- Bottom navigation bar with 4 tabs
- Campaign generation form with dropdowns and text inputs
- Profile page with account info and phone verification

## Tech Stack

- **Framework:** Flutter
- **Language:** Dart
- **Design:** Material 3 with custom Shiksha brand theme

## Brand Colors

| Color             | Hex       |
|-------------------|-----------|
| Deep Royal Purple | `#4B2D8E` |
| Navy Purple       | `#2D2154` |
| Amber Orange      | `#F0A030` |
| Gold              | `#D4A017` |

## Getting Started

### Prerequisites

- Flutter SDK (^3.11.4)
- Android Studio / VS Code
- Android emulator or physical device

### Run the app

```bash
flutter pub get
flutter run
```

## Project Structure

```
lib/
  main.dart                          # App entry point
  theme/
    app_colors.dart                  # Brand color constants
    app_theme.dart                   # Material theme configuration
  screens/
    splash_screen.dart               # Animated splash screen
    home_screen.dart                 # Main screen with bottom nav bar
    generator_screen.dart            # Campaign generator form
    marketing_studio_screen.dart     # Marketing studio tab
    my_campaigns_screen.dart         # Campaigns list tab
    profile_screen.dart              # Profile & account settings
```
