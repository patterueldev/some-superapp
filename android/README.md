# SomeSuperApp - Android

Android application for SomeSuperApp using Kotlin and Jetpack Compose.

## Quick Start

### Prerequisites
- Android Studio Jellyfish or later
- JDK 17+
- Android SDK 34+

### Setup

1. Open Android Studio
2. Select "Open an existing Android Studio project"
3. Navigate to this `android` directory
4. Gradle sync will run automatically

### Running

```bash
# Build debug APK
./gradlew assembleDebug

# Install on connected device/emulator
./gradlew installDebug

# Run tests
./gradlew test

# Run UI tests
./gradlew connectedAndroidTest
```

### Project Structure

```
android/
├── app/                          # Main application module
│   ├── build.gradle.kts         # App-level build configuration
│   ├── src/
│   │   ├── main/
│   │   │   ├── AndroidManifest.xml
│   │   │   ├── kotlin/
│   │   │   │   └── com/patterueldev/somesuperapp/
│   │   │   │       ├── MainActivity.kt
│   │   │   │       ├── models/
│   │   │   │       ├── viewmodels/
│   │   │   │       ├── ui/
│   │   │   │       └── data/
│   │   │   └── res/
│   │   ├── test/
│   │   └── androidTest/
├── build.gradle.kts             # Project-level build configuration
├── gradle.properties            # Gradle properties
└── settings.gradle.kts          # Gradle settings
```

## Architecture

Follows MVVM pattern with:
- **Models**: Data classes representing domain entities
- **ViewModels**: State management and business logic
- **UI**: Jetpack Compose composables
- **Data**: Repository pattern for data access

See [../docs/ARCHITECTURE.md](../docs/ARCHITECTURE.md) for full details.

## Build Variants

- **Debug**: Development build with debug symbols
- **Release**: Optimized production build

## Dependencies

See `app/build.gradle.kts` for full dependency list. Key libraries:
- Jetpack Compose for UI
- Room for local database
- Retrofit for API calls
- Dagger/Hilt for dependency injection
