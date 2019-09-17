#!/bin/bash

set -e
set -o pipefail

swift package resolve
swift package generate-xcodeproj
sudo xcode-select --switch /Applications/$1.app/Contents/Developer

xcodebuild -version
xcodebuild build -scheme Swiftlier-Package \
  -sdk iphonesimulator -destination "$IOS_DEVICE" | xcpretty
xcodebuild build -scheme Swiftlier-Package \
  -sdk appletvsimulator -destination "$TVOS_DEVICE" | xcpretty

if [ -n "$CODECOV_JOB" ]; then
  xcodebuild test -enableCodeCoverage YES -scheme Swiftlier-Package \
    -sdk macosx | xcpretty
  bash <(curl -s https://codecov.io/bash)
else
  xcodebuild test -scheme Swiftlier-Package \
    -sdk macosx | xcpretty
fi
