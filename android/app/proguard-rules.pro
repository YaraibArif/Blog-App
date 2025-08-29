# Flutter ke liye recommended
-keep class io.flutter.app.** { *; }
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.plugins.** { *; }

# Custom models (User etc.)
-keep class com.yourpackage.models.** { *; }

# Gson / JSON serialization
-keep class com.google.gson.** { *; }
-keep class com.google.gson.annotations.** { *; }
