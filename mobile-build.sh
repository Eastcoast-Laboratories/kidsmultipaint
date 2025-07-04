#!/bin/bash
# Mobile build script for multipaint app using Capacitor
# This script builds the web app and syncs it with native platforms

# Default configuration
UPDATE_VERSION=false

# Show help information
show_help() {
  echo "\nmultipaint Mobile Build Script\n"
  echo "Usage: bash mobile-build.sh [options] [platform]\n"
  echo "Options:"
  echo "  -h, --help                Show this help message"
  echo "  -u, --update-version      Update version: extract current version from 'package."
  echo "                            json' and increment minor version, then update 'build.gradle'"
  echo "                            and 'dev/add_changelog.sh'"
  echo ""
  echo "Platforms:"
  echo "  android    Build and open Android project"
  echo "  ios        Build and open iOS project"
  echo "  update     Only update native apps with latest web code"
  echo ""
  exit 0
}

# Process command line arguments
parse_args() {
  PLATFORM=""
  
  while [[ $# -gt 0 ]]; do
    case $1 in
      -h|--help)
        show_help
        ;;
      -u|--update-version)
        UPDATE_VERSION=true
        shift
        ;;
      android|ios|update)
        PLATFORM=$1
        shift
        ;;
      *)
        echo "Unknown option: $1"
        show_help
        ;;
    esac
  done
}

# find path to Android Studio dynamically, independent of snap version
find_android_studio() {
  # try to find latest snap path
  SNAP_STUDIO=$(find /snap/android-studio -name studio.sh -type f | sort -r | head -n 1 2>/dev/null)
  
  if [ -n "$SNAP_STUDIO" ] && [ -x "$SNAP_STUDIO" ]; then
    echo "$SNAP_STUDIO"
    return
  fi
  
  # try other common installation paths
  for path in \
    "/usr/local/android-studio/bin/studio.sh" \
    "$HOME/android-studio/bin/studio.sh" \
    "/opt/android-studio/bin/studio.sh"
  do
    if [ -x "$path" ]; then
      echo "$path"
      return
    fi
  done
  
  # fallback: try to find studio.sh in PATH
  command -v studio.sh
}

echo "###### 1. set path to Android Studio"
STUDIO_PATH=$(find_android_studio)

if [ -n "$STUDIO_PATH" ]; then
  echo "Android Studio gefunden unter: $STUDIO_PATH"
  export CAPACITOR_ANDROID_STUDIO_PATH="$STUDIO_PATH"
else
  echo "Warnung: Android Studio nicht gefunden. Das Öffnen des Android-Projekts könnte fehlschlagen."
fi

# Update version in package.json and sync to build.gradle
update_version() {
  PACKAGE_FILE="package.json"
  GRADLE_FILE="android/app/build.gradle"
  CHANGELOG_GENERATOR_FILE="dev/add_changelog.sh"
  
  if [ ! -f "$PACKAGE_FILE" ]; then
    echo "Error: package.json not found!"
    return 1
  fi
  
  # extract current version from package.json
  CURRENT_VERSION=$(grep -oP '"version":\s*"\K[^"]+' "$PACKAGE_FILE")
  
  if [ -z "$CURRENT_VERSION" ]; then
    echo "Error: Could not find version in package.json"
    return 1
  fi
  
  # split version into major.minor
  MAJOR=$(echo "$CURRENT_VERSION" | cut -d. -f1)
  MINOR=$(echo "$CURRENT_VERSION" | cut -d. -f2)
  
  # Check if minor version is 99, then rollover to next major version
  if [ "$MINOR" -eq 99 ]; then
    NEW_MAJOR=$((MAJOR + 1))
    NEW_MINOR=0
    NEW_VERSION="$NEW_MAJOR.$NEW_MINOR"
    echo "Major version rollover: $CURRENT_VERSION → $NEW_VERSION (minor reached 99)"
  else
    # increment minor version (no patch version)
    NEW_MINOR=$((MINOR + 1))
    NEW_VERSION="$MAJOR.$NEW_MINOR"
  fi
  
  echo "###### 2. Updating version in package.json: $CURRENT_VERSION → $NEW_VERSION"
  
  # update version in package.json
  sed -i "s/\"version\":\s*\"$CURRENT_VERSION\"/\"version\": \"$NEW_VERSION\"/" "$PACKAGE_FILE"
  
  # update package-lock.json
  echo "Updating package-lock.json..."
  npm install --package-lock-only --quiet
  
  # Version für Android verwenden (immer nur Major.Minor Format)
  ANDROID_VERSION="$NEW_VERSION"
  
  echo "###### 2.1 Updating version in build.gradle"
  if [ -f "$GRADLE_FILE" ]; then
    # Extrahiere aktuelle versionCode
    CURRENT_CODE=$(grep -oP 'versionCode\s+\K\d+' "$GRADLE_FILE")
    
    if [ -n "$CURRENT_CODE" ]; then
      # versionCode inkrementieren
      NEW_CODE=$((CURRENT_CODE + 1))
      echo "Updating Android versionCode: $CURRENT_CODE → $NEW_CODE"
      
      # versionCode in gradle file ersetzen
      
      # versionCode auch in package.json einfügen für Web-App
      echo "Injecting versionCode into package.json: $NEW_CODE"
      # Prüfe ob versionCode bereits existiert
      if grep -q "versionCode" "$PACKAGE_FILE"; then
        # Ersetze bestehende versionCode
        sed -i "s/\"versionCode\":\s*[0-9]*/\"versionCode\": $NEW_CODE/" "$PACKAGE_FILE"
      else
        # Füge versionCode nach version hinzu
        sed -i "/"version":/a\  "versionCode": $NEW_CODE," "$PACKAGE_FILE"
      fi
      sed -i "s/versionCode $CURRENT_CODE/versionCode $NEW_CODE/" "$GRADLE_FILE"
      
      # Update versionName with new version from package.json
      echo "###### 2.1.1 Updating Android versionName"
      echo "New Android versionName: $ANDROID_VERSION"
      sed -i "s/versionName \"[^\"]*\"/versionName \"$ANDROID_VERSION\"/" "$GRADLE_FILE"
    else
      echo "Could not find versionCode in $GRADLE_FILE"
    fi
  else
    echo "Android gradle file not found at $GRADLE_FILE"
  fi
  
  # Version in add_changelog.sh aktualisieren
  echo "###### 2.2 Updating version in dev/add_changelog.sh"
  if [ -f "$CHANGELOG_GENERATOR_FILE" ]; then
    echo "New version in changelog generator: $ANDROID_VERSION"
    # Ersetze die VERSION_NAME-Zeile in der add_changelog.sh
    sed -i "s/VERSION_NAME=[0-9.]\+/VERSION_NAME=$ANDROID_VERSION/" "$CHANGELOG_GENERATOR_FILE"
  else
    echo "Changelog generator file not found at $CHANGELOG_GENERATOR_FILE"
  fi
}

# Parse command line arguments
parse_args "$@"

# Update version if not skipped
if [ "$UPDATE_VERSION" = true ]; then
  echo "###### 3. Updating version numbers..."
  update_version
else
  echo "###### 3. Skipping version update as requested..."
fi

# Build the web app
echo "###### 4. Building web application fast..."
npm run build:fast
echo "###### 4a. Building web application..."
npm run build

# Function to align package names between capacitor.config.json and Android files
align_package_names() {
  echo "###### 5. Checking package name consistency..."
  
  # Get appId from capacitor.config.json
  CONFIG_FILE="capacitor.config.json"
  if [ ! -f "$CONFIG_FILE" ]; then
    echo "Error: capacitor.config.json not found!"
    return 1
  fi
  
  # Extract appId using grep and sed
  APP_ID=$(grep -o '"appId"[[:space:]]*:[[:space:]]*"[^"]*"' "$CONFIG_FILE" | sed 's/"appId"[[:space:]]*:[[:space:]]*"\([^"]*\)"/\1/')
  
  if [ -z "$APP_ID" ]; then
    echo "Error: Could not find appId in capacitor.config.json"
    return 1
  fi
  
  echo "Found appId in capacitor.config.json: $APP_ID"
  
  # Convert from com.example.app to com/example/app for directory structure
  PACKAGE_DIR_PATH=$(echo "$APP_ID" | tr '.' '/')
  ANDROID_SRC_DIR="android/app/src/main/java"
  TARGET_DIR="$ANDROID_SRC_DIR/$PACKAGE_DIR_PATH"
  
  # Find MainActivity.java (could be in wrong location)
  MAIN_ACTIVITY_FILES=$(find "$ANDROID_SRC_DIR" -name "MainActivity.java")
  
  if [ -z "$MAIN_ACTIVITY_FILES" ]; then
    echo "Warning: MainActivity.java not found in Android project!"
    return 1
  fi
  
  for MAIN_ACTIVITY_FILE in $MAIN_ACTIVITY_FILES; do
    # Extract package from MainActivity.java
    CURRENT_PACKAGE=$(grep -o 'package[[:space:]]*[^;]*;' "$MAIN_ACTIVITY_FILE" | sed 's/package[[:space:]]*\([^;]*\);/\1/')
    
    if [ "$CURRENT_PACKAGE" != "$APP_ID" ]; then
      echo "Package mismatch detected:"
      echo "  - In capacitor.config.json: $APP_ID"
      echo "  - In MainActivity.java: $CURRENT_PACKAGE"
      
      # Create target directory if it doesn't exist
      mkdir -p "$TARGET_DIR"
      
      # Fix package declaration in file
      sed -i "s/package[[:space:]]*[^;]*;/package $APP_ID;/" "$MAIN_ACTIVITY_FILE"
      
      # If MainActivity.java is not in the right directory, move it
      if [ "$(dirname "$MAIN_ACTIVITY_FILE")" != "$TARGET_DIR" ]; then
        echo "Moving MainActivity.java to correct package directory:"
        echo "  From: $MAIN_ACTIVITY_FILE"
        echo "  To: $TARGET_DIR/MainActivity.java"
        
        # Make sure target directory exists
        mkdir -p "$TARGET_DIR"
        
        # Move the file
        mv "$MAIN_ACTIVITY_FILE" "$TARGET_DIR/"
        
        echo "MainActivity.java moved and package declaration updated."
      else
        echo "MainActivity.java is in the correct directory, only package declaration updated."
      fi
    else
      echo "Package names are consistent: $APP_ID"
    fi
  done
}

# Copy public directory contents to dist, excluding android directory (only needed for web dev server)
# Note: The android/ directory in public/ contains XML files for the webpack dev server
# The actual native Android app uses the XML files in the main android/ directory
echo "Copying public assets to dist (excluding android XML files)..."
rsync -av --exclude='android/' public/ dist/

# Für die mobile App verwenden wir nur den app-Unterordner als Root
# Das bedeutet, dass für die native App der "app"-Ordner der Hauptordner ist
echo "Konfiguriere native Apps, damit sie direkt die Web-App im app/-Unterordner laden..."

# Copy package.json to dist for version info
echo "Copying package.json to dist for version information..."
cp package.json dist/

# Sync with Capacitor
echo "###### 5a. Checking and aligning package names..."
align_package_names

echo "###### 6. Syncing with Capacitor..."

# Kopieren der app/-Inhalte nach dist/, damit Capacitor sie findet
# Die ursprüngliche Struktur muss beachtet werden, aber Capacitor erwartet die Dateien in dist/
echo "Kopiere app/-Inhalte in das richtige Verzeichnis für Capacitor..."
mkdir -p dist-temp
cp -r dist/app/* dist-temp/
rm -rf dist/app/
cp -r dist-temp/* dist/
rm -rf dist-temp

# Erstelle unsere native-app-detector.js direkt in dist/
echo "Erstelle native-app-detector.js für die App..."
cp src/native-app-detector.js dist/

# Kopiere die native-app-detector.js auch nach dist/app/
cp src/native-app-detector.js dist/app/

# Jetzt mit der Standardkonfiguration synchronisieren (webDir ist bereits auf 'dist' eingestellt)
echo "Synchronisiere mit Capacitor..."
npx cap sync

# Ensure only used images are copied to Android assets
echo "###### 7. Finding used images in the code..."

# create temp directory for used images
TEMP_IMG_DIR="temp_used_images"
rm -rf "$TEMP_IMG_DIR"
mkdir -p "$TEMP_IMG_DIR"

echo "###### 8. search for image references in code (HTML, CSS, JS files)"
find src -type f \( -name "*.js" -o -name "*.html" -o -name "*.css" \) -exec grep -oE "['\"][^'\"]*\.(png|jpg|jpeg|gif|svg|webp)['\"]" {} \; | \
  tr -d "'\"" | sort | uniq > "$TEMP_IMG_DIR/used_images.txt"

echo "###### 9. Copying only used images to Android assets..."
mkdir -p android/app/src/main/assets/public/images

echo "Found images:"
cat "$TEMP_IMG_DIR/used_images.txt"

echo "###### 10. copy only used images"
while read -r img_path; do
  # remove ./ or / from path
  clean_path=${img_path#./}
  clean_path=${clean_path#/}
  
  # source path - für die App müssen wir die Bilder aus public/ verwenden
  src_path="public/$clean_path"
  
  # target directory - die assets müssen ins korrekte Verzeichnis auf Android
  # Wir kopieren sie direkt ins Wurzelverzeichnis von assets/
  target_dir="android/app/src/main/assets/$(dirname "$clean_path")"
  
  # only copy if file exists
  if [ -f "$src_path" ]; then
    mkdir -p "$target_dir"
    cp "$src_path" "$target_dir/"
    echo "Copied: $clean_path"
  else
    echo "Warning: Image not found: $src_path"
  fi
done < "$TEMP_IMG_DIR/used_images.txt"

# delete temp directory
rm -rf "$TEMP_IMG_DIR"

echo "Only used images copied successfully"

echo "###### 14. Platform-specific commands"
if [ "$1" == "android" ]; then
  echo "Opening Android project in Android Studio..."
  npx cap open android
elif [ "$1" == "ios" ]; then
  echo "Opening iOS project in Xcode..."
  npx cap open ios
elif [ "$1" == "update" ]; then
  echo "Just updating native apps with latest web code."
else
  echo "\nUsage: bash mobile-build.sh [platform]\n"
  echo "Available platforms:"
  echo "  android  - Build and open Android project"
  echo "  ios      - Build and open iOS project"
  echo "  update   - Only update native apps with latest web code"
fi

echo "Done!"
