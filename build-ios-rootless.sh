#!/bin/bash
# Build script for iOS rootless (arm64/arm64e)
# Note: This requires macOS with Xcode installed for iOS SDK

set -e

echo "Building ipatool for iOS rootless..."

# Set build variables for iOS rootless
export GOOS=ios
export GOARCH=arm64
export CGO_ENABLED=1

# For rootless jailbreaks, we typically use arm64e architecture
# Uncomment the line below if you need arm64e instead of arm64
# export GOARCH=arm64e

# iOS SDK path (adjust if needed)
export SDK_PATH=$(xcrun --sdk iphoneos --show-sdk-path 2>/dev/null || echo "")

if [ -z "$SDK_PATH" ]; then
    echo "Warning: iOS SDK not found. Trying without CGO..."
    export CGO_ENABLED=0
fi

# Build flags
BUILD_FLAGS="-ldflags=-s -w"
OUTPUT_NAME="ipatool-ios-rootless"

echo "GOOS: $GOOS"
echo "GOARCH: $GOARCH"
echo "CGO_ENABLED: $CGO_ENABLED"

# Build the binary
go build $BUILD_FLAGS -o $OUTPUT_NAME .

if [ $? -eq 0 ]; then
    echo "✓ Build successful: $OUTPUT_NAME"
    file $OUTPUT_NAME
    ls -lh $OUTPUT_NAME
else
    echo "✗ Build failed"
    exit 1
fi

