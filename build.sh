#!/bin/bash

set -e  # หยุด script ทันทีหากเจอ error

echo "🧹 Cleaning previous builds..."
flutter clean

echo "📦 Running flutter pub get..."
flutter pub get

echo "🚧 Building Flutter macOS app with dart-define values..."
flutter build macos \
  --dart-define=APPWRITE_ENDPOINT=https://baas.moevedigital.com/v1 \
  --dart-define=APPWRITE_PROJECT=667afb24000fbd66b4df \
  --dart-define=NEXT_SERVER=https://admin.mylaos.life/ \
  --dart-define=JWT_SECRET=T0LPZL+X1Faej0wikHcMGazu9BilhgQ6vBMxckEFmvvLMkPexH9MCG1x/GcjeSnF \
  --dart-define=JWT_ISSUER=ck_dashboard \
  --dart-define=WEBSOCKET_URL=wss://admin.mylaos.life/api/calculation/realtime
# flutter build macos \
#   --dart-define=APPWRITE_ENDPOINT=https://baas-dev.moevedigital.com/v1 \
#   --dart-define=APPWRITE_PROJECT=667afb24000fbd66b4df \
#   --dart-define=NEXT_SERVER=https://demo.mylaos.life/ \
#   --dart-define=JWT_SECRET=T0LPZL+X1Faej0wikHcMGazu9BilhgQ6vBMxckEFmvvLMkPexH9MCG1x/GcjeSnF \
#   --dart-define=JWT_ISSUER=ck_dashboard \
#   --dart-define=WEBSOCKET_URL=wss://demo.mylaos.life/api/calculation/realtime

echo "✅ Build complete."

APP_NAME=$(grep name pubspec.yaml | awk '{ print $2 }')
APP_PATH="./build/macos/Build/Products/Release/$APP_NAME.app/Contents/MacOS/$APP_NAME"

echo "🚀 Running built app..."
chmod +x "$APP_PATH"
"$APP_PATH"
