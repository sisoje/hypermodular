#!/bin/sh
# Builds the example and runs its evidence tests on a simulator.
set -eu
cd "$(dirname "$0")"
xcodegen generate
xcodebuild test \
    -project BookApp.xcodeproj \
    -scheme BookAppTests \
    -destination "platform=iOS Simulator,name=iPhone 17 Pro" \
    -collect-test-diagnostics never
