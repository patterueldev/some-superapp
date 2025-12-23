-keep class com.patterueldev.somesuperapp.** { *; }
-keep interface com.patterueldev.somesuperapp.** { *; }
-keepclassmembers class com.patterueldev.somesuperapp.** { *; }

# Jetpack Compose
-keep class androidx.compose.** { *; }

# Room
-keep class androidx.room.** { *; }
-keepclassmembers class * {
    @androidx.room.* <fields>;
}

# Lifecycle
-keep class androidx.lifecycle.** { *; }
-keepclassmembers class * {
    @androidx.lifecycle.* <methods>;
}
