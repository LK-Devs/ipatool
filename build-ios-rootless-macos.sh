#!/bin/bash
# Build script for iOS rootless (arm64/arm64e)
# Optimized for macOS with Xcode

set -e

echo "Building ipatool for iOS rootless on macOS..."

# Detect iOS SDK
SDK_PATH=$(xcrun --sdk iphoneos --show-sdk-path 2>/dev/null)
if [ -z "$SDK_PATH" ]; then
    echo "Error: iOS SDK not found. Please install Xcode."
    exit 1
fi

echo "Using iOS SDK: $SDK_PATH"

# Set build variables for iOS rootless
export GOOS=ios
export GOARCH=arm64
export CGO_ENABLED=1

# iOS SDK configuration
export CC=$(xcrun --sdk iphoneos --find clang)
export CXX=$(xcrun --sdk iphoneos --find clang++)
export CGO_CFLAGS="-isysroot $SDK_PATH -arch arm64 -miphoneos-version-min=12.0"
export CGO_LDFLAGS="-isysroot $SDK_PATH -arch arm64 -miphoneos-version-min=12.0"

# For arm64e (A12+ devices with pointer authentication)
# Uncomment these lines if you need arm64e support
# export GOARCH=arm64e
# export CGO_CFLAGS="-isysroot $SDK_PATH -arch arm64e -miphoneos-version-min=12.0"
# export CGO_LDFLAGS="-isysroot $SDK_PATH -arch arm64e -miphoneos-version-min=12.0"

echo "GOOS: $GOOS"
echo "GOARCH: $GOARCH"
echo "CGO_ENABLED: $CGO_ENABLED"
echo "CC: $CC"

# Build flags
BUILD_FLAGS="-ldflags=-s -w"
OUTPUT_NAME="ipatool-ios-rootless"

# Build the binary
echo "Building..."
go build $BUILD_FLAGS -o $OUTPUT_NAME .

if [ $? -eq 0 ]; then
    echo "✓ Build successful: $OUTPUT_NAME"
    echo ""
    file $OUTPUT_NAME
    echo ""
    ls -lh $OUTPUT_NAME
    echo ""
    echo "Binary is ready for iOS rootless jailbreak devices."
    echo "Transfer to device and set executable permissions: chmod +x ipatool-ios-rootless"
else
    echo "✗ Build failed"
    exit 1
fi

