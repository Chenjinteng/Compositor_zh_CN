#!/bin/zsh
# Generates (or refreshes) the Sparkle ed25519 signing key used by this fork's
# appcast feed, and reports the SUPublicEDKey value that Config/Info.plist must
# contain so installed copies of the fork accept self-published updates.
#
# Why this exists: Compositor ships Sparkle via SwiftPM, so generate_keys is
# only present after an Xcode build. The script makes sure that build has
# happened, then runs the binary. The private key always lands in the user's
# login keychain under service "https://sparkle-project.org" / account
# "ed25519"; that keychain entry is what scripts/publish.sh's sign_update
# reads from when it signs each release DMG. The private key never leaves the
# keychain — this script only prints the matching public key.
#
# Use:
#   ./scripts/sparkle-keys.sh                  # generate a new key (if none
#                                              # exists) and print public key
#   ./scripts/sparkle-keys.sh --rotate         # force a fresh key pair
#   ./scripts/sparkle-keys.sh --write-info     # also patch Config/Info.plist
#                                              # with the public key just shown
#   ./scripts/sparkle-keys.sh --public-key K   # patch Info.plist with a known
#                                              # key (e.g. one generated on
#                                              # another machine)
#
# rotate: every installed copy of the fork will reject future updates until
# it's republished and each user re-downloads the DMG manually, so don't
# rotate without a reason.
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
APP=Compositor
WORK="$HOME/Library/Caches/CompositorRelease-zh-CN"
SPARKLE_BIN="$WORK/DerivedData/SourcePackages/artifacts/sparkle/Sparkle/bin"
INFO_PLIST="$PROJECT_DIR/Config/Info.plist"
KEYCHAIN_SVC="https://sparkle-project.org"
KEYCHAIN_ACCT="ed25519"
# In zsh `$0` inside a function is the function name, not the script path; the
# usage() helper needs the script path to print its own header.
SELF="$0"

usage() {
  sed -n '2,/^set /p' "$SELF" | sed 's/^# \{0,1\}//'
  exit "${1:-0}"
}

rotate=0
write_info=0
public_key=""
while (( $# )); do
  case "$1" in
    --rotate) rotate=1 ;;
    --write-info) write_info=1 ;;
    --public-key) shift; public_key="${1:-}" ;;
    -h|--help) usage 0 ;;
    *) echo "Unknown option: $1" >&2; usage 1 ;;
  esac
  shift
done

# Make sure Sparkle's CLI tools are built. The Release cache used by
# scripts/release.sh / publish.sh is the same path we read from; building here
# avoids a separate DerivedData under the project.
if [[ ! -x "$SPARKLE_BIN/generate_keys" ]]; then
  echo "==> Sparkle tools not built yet; building the Release scheme"
  rm -rf "$WORK"
  mkdir -p "$WORK"
  xcodebuild build -quiet \
    -project "$PROJECT_DIR/$APP.xcodeproj" -scheme "$APP" -configuration Release \
    -destination "generic/platform=macOS" \
    -derivedDataPath "$WORK/DerivedData"
fi

# Detect an existing keychain entry without blocking on a locked keychain.
# `security find-generic-password` against a locked keychain hangs forever
# in a non-interactive shell; list-keychains + a tight timeout avoids that.
# macOS has no `timeout(1)`, so we use perl for the alarm.
key_exists=$(security list-keychains 2>/dev/null | tr -d '"' | while read kc; do
  perl -e 'alarm 5; exec @ARGV' security find-generic-password \
    -s "$KEYCHAIN_SVC" -a "$KEYCHAIN_ACCT" "$kc" >/dev/null 2>&1 && { echo yes; break; }
done)

if [[ -n "$key_exists" && -z "$public_key" && $rotate -eq 0 ]]; then
  echo "==> Sparkle signing key already in keychain (service $KEYCHAIN_SVC, account $KEYCHAIN_ACCT)"
  echo "    Pass --rotate to make a fresh one, or --public-key <key> to patch Info.plist with a known key."
  exit 0
fi

if [[ -z "$public_key" ]]; then
  echo "==> Generating a new Sparkle signing key"
  out=$("$SPARKLE_BIN/generate_keys")
  print -r -- "$out"
  public_key=$(print -r -- "$out" | awk -F'[<>]' '/SUPublicEDKey/{getline; print}' \
                                       | sed -n 's/.*<string>\(.*\)<\/string>.*/\1/p')
  [[ -n "$public_key" ]] || { echo "Failed to parse public key from generate_keys output" >&2; exit 1; }
fi

echo
echo "SUPublicEDKey = $public_key"

if [[ $write_info -eq 1 ]]; then
  echo "==> Patching $INFO_PLIST"
  /usr/bin/python3 - "$INFO_PLIST" "$public_key" <<'PY'
import sys, pathlib
path, new_key = pathlib.Path(sys.argv[1]), sys.argv[2]
text = path.read_text()
needle = "<key>SUPublicEDKey</key>"
idx = text.find(needle)
if idx == -1:
    sys.exit("SUPublicEDKey not found in Info.plist")
start = text.find("<string>", idx) + len("<string>")
end = text.find("</string>", start)
path.write_text(text[:start] + new_key + text[end:])
PY
fi