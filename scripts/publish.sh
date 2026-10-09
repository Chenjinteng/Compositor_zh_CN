#!/bin/zsh
# Publishes the DMG that release.sh built: a GitHub Release (tag = $VERSION, no v
# prefix — this fork uses 1.4.7_zh-style tags rather than v1.4.7) on
# Chenjinteng/Compositor_zh_CN holding Compositor.dmg, then commits an
# appcast.xml pointing at it so Sparkle can auto-update installed copies.
#
# Run release.sh first. Needs the Sparkle signing key in the login keychain and
# `gh` signed in.
# Release notes: RELEASE_NOTES="…" ./scripts/publish.sh
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
APP=Compositor
REPO=Chenjinteng/Compositor_zh_CN
WORK="$HOME/Library/Caches/CompositorRelease-zh-CN"
SIGN_UPDATE="$WORK/DerivedData/SourcePackages/artifacts/sparkle/Sparkle/bin/sign_update"

settings=$(xcodebuild -project "$PROJECT_DIR/$APP.xcodeproj" -scheme "$APP" -configuration Release -showBuildSettings 2>/dev/null)
VERSION=$(print -r -- "$settings" | awk -F' = ' '/ MARKETING_VERSION = /{print $2; exit}')
BUILD=$(print -r -- "$settings" | awk -F' = ' '/ CURRENT_PROJECT_VERSION = /{print $2; exit}')
MINIMUM=$(print -r -- "$settings" | awk -F' = ' '/ MACOSX_DEPLOYMENT_TARGET = /{print $2; exit}')
# This fork tags Personal Team releases without the leading "v" that the
# upstream repo uses, to keep 1.4.7_zh visually distinct from upstream's
# v1.4.6 / v1.4.7.
TAG="$VERSION"
SOURCE="$PROJECT_DIR/dist/$APP-$VERSION.dmg"
[[ -f "$SOURCE" ]] || { echo "No $SOURCE — run scripts/release.sh first."; exit 1; }
[[ -x "$SIGN_UPDATE" ]] || { echo "Sparkle's sign_update isn't built — run scripts/release.sh first."; exit 1; }
if gh release view "$TAG" --repo "$REPO" >/dev/null 2>&1; then
  echo "Release $TAG already exists. Raise the version (and build number) first."
  exit 1
fi

echo "==> $APP $VERSION ($BUILD)"
# Every release names its file Compositor.dmg, so …/releases/latest/download/Compositor.dmg always works.
mkdir -p "$WORK/publish"
DMG="$WORK/publish/$APP.dmg"
cp "$SOURCE" "$DMG"

echo "==> Signing the update for Sparkle"
signature=$("$SIGN_UPDATE" "$DMG")

echo "==> Creating GitHub Release $TAG"
gh release create "$TAG" "$DMG" --repo "$REPO" --title "$APP $VERSION" --notes "${RELEASE_NOTES:-$APP $VERSION}"

echo "==> Publishing the update feed"
cat > "$PROJECT_DIR/appcast.xml" <<XML
<?xml version="1.0" encoding="utf-8"?>
<rss version="2.0" xmlns:sparkle="http://www.andymatuschak.org/xml-namespaces/sparkle">
  <channel>
    <title>$APP</title>
    <item>
      <title>Version $VERSION</title>
      <pubDate>$(LC_ALL=C date -u "+%a, %d %b %Y %H:%M:%S +0000")</pubDate>
      <sparkle:version>$BUILD</sparkle:version>
      <sparkle:shortVersionString>$VERSION</sparkle:shortVersionString>
      <sparkle:minimumSystemVersion>$MINIMUM</sparkle:minimumSystemVersion>
      <link>https://github.com/$REPO/releases/tag/$TAG</link>
      <enclosure url="https://github.com/$REPO/releases/download/$TAG/$APP.dmg" $signature type="application/octet-stream"/>
    </item>
  </channel>
</rss>
XML
git -C "$PROJECT_DIR" add appcast.xml
git -C "$PROJECT_DIR" commit -q -m "Publish update feed for $APP $VERSION"
git -C "$PROJECT_DIR" push -q
echo "==> Done: https://github.com/$REPO/releases/tag/$TAG"
