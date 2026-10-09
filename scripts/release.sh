#!/bin/zsh
# Builds a Compositor DMG signed with the user's Personal Team.
#
# Personal Team cannot notarize (that requires a Developer ID Application
# certificate), so the DMG will install cleanly on the build machine and on
# any Mac the user signs in to with the same Apple ID, but other Macs will
# see a Gatekeeper "from an unidentified developer" warning unless they
# right-click → Open once.
#
# Needs, all kept out of this repository:
#   - an "Apple Development" certificate in the login keychain
#     for Team ID FDQLLU43U7
#   - create-dmg (brew install create-dmg)
# The DMG window background is scripts/dmg/dmg-bg.jpg (600 × 380, the window's
# exact size) plus dmg-bg-retina.jpg (1200 × 760) for Retina displays.
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
APP=Compositor
TEAM=FDQLLU43U7
IDENTITY="Apple Development"
# Personal Team re-signs expire after 7 days, so give the work dir a fork-specific
# name and keep it under the user's cache dir, not the upstream path.
WORK="$HOME/Library/Caches/CompositorRelease-zh-CN"
DIST="$PROJECT_DIR/dist"

settings=$(xcodebuild -project "$PROJECT_DIR/$APP.xcodeproj" -scheme "$APP" -configuration Release -showBuildSettings 2>/dev/null)
VERSION=$(print -r -- "$settings" | awk -F' = ' '/ MARKETING_VERSION = /{print $2; exit}')
BUILD=$(print -r -- "$settings" | awk -F' = ' '/ CURRENT_PROJECT_VERSION = /{print $2; exit}')
echo "==> $APP $VERSION ($BUILD)"

rm -rf "$WORK"
mkdir -p "$WORK" "$DIST"

echo "==> Archiving a Release build (Personal Team automatic signing)"
xcodebuild archive -quiet \
  -project "$PROJECT_DIR/$APP.xcodeproj" -scheme "$APP" -configuration Release \
  -destination "generic/platform=macOS" \
  -archivePath "$WORK/$APP.xcarchive" -derivedDataPath "$WORK/DerivedData" \
  CODE_SIGN_STYLE=Automatic CODE_SIGN_IDENTITY="$IDENTITY" DEVELOPMENT_TEAM="$TEAM"

# The archive already runs codesign during `xcodebuild archive`; just verify and
# copy out. We deliberately do not use `xcodebuild -exportArchive` here — its
# only valid signing methods for macOS are app-store / developer-id / package,
# none of which accept a Personal Team signing identity.
APP_PATH="$WORK/$APP.xcarchive/Products/Applications/$APP.app"
codesign --verify --deep --strict --verbose=2 "$APP_PATH"

echo "==> Building the DMG window"
STAGE="$WORK/dmg"
mkdir -p "$STAGE"
cp -R "$APP_PATH" "$STAGE/"
DMG="$DIST/$APP-$VERSION.dmg"
rm -f "$DMG"
# Icon centers in the DMG window, in points from its top-left.
APP_X=160
APPLICATIONS_X=440
ICON_Y=180
background=()
LOW="$PROJECT_DIR/scripts/dmg/dmg-bg.jpg"
HIGH="$PROJECT_DIR/scripts/dmg/dmg-bg-retina.jpg"
if [[ -f "$LOW" && -f "$HIGH" ]]; then
  # Finder takes one background file; a TIFF holding both sizes stays sharp on Retina displays.
  sips -s format png -s dpiWidth 72 -s dpiHeight 72 "$LOW" --out "$WORK/background.png" >/dev/null
  sips -s format png -s dpiWidth 144 -s dpiHeight 144 "$HIGH" --out "$WORK/background@2x.png" >/dev/null
  tiffutil -cathidpicheck "$WORK/background.png" "$WORK/background@2x.png" -out "$WORK/background.tiff" >/dev/null
  background=(--background "$WORK/background.tiff")
elif [[ -f "$LOW" ]]; then
  background=(--background "$LOW")
fi
create-dmg \
  --volname "$APP" \
  --window-pos 200 120 --window-size 600 380 \
  --icon-size 128 --text-size 13 \
  --icon "$APP.app" "$APP_X" "$ICON_Y" --hide-extension "$APP.app" \
  --app-drop-link "$APPLICATIONS_X" "$ICON_Y" \
  "${background[@]}" \
  "$DMG" "$STAGE"

# Sign the DMG with the same Personal Team identity. No stapling: there's no
# notarization ticket to staple.
echo "==> Signing the DMG"
codesign --sign "$IDENTITY" --timestamp "$DMG"

# spctl on a Personal-Team-signed DMG is informational only — it will likely
# say "rejected" because the build is not notarized. Run it anyway so the
# user can see what Gatekeeper will say on their own machine.
echo "==> What spctl will say on the build machine"
spctl --assess --type open --context context:primary-signature --verbose=2 "$DMG" || true
spctl --assess --type execute --verbose=2 "$APP_PATH" || true
echo "==> Done: $DMG"
