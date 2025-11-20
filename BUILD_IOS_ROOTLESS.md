# Building ipatool for iOS Rootless

This guide explains how to build `ipatool` for iOS rootless jailbreak devices.

## Prerequisites

### Option 1: macOS (Recommended)
- macOS with Xcode installed
- Go 1.23+ installed
- iOS SDK (comes with Xcode)

### Option 2: Windows/Linux
- Go 1.23+ installed
- Note: Full iOS cross-compilation requires the iOS SDK, which is only available on macOS
- You may need to use a macOS build server, VM, or CI/CD service

## Build Instructions

### Using GitHub Actions (Recommended for Windows/Linux users)

The easiest way to build for iOS rootless without macOS is to use GitHub Actions:

1. **Push to GitHub**: Push your code to a GitHub repository
2. **Trigger the workflow**: 
   - The workflow runs automatically on pushes to `main` branch
   - Or manually trigger it: Go to Actions → "Build iOS Rootless" → "Run workflow"
3. **Download artifacts**: After the build completes, download the binaries from the Actions artifacts:
   - `ipatool-ios-rootless-arm64` - For all 64-bit devices
   - `ipatool-ios-rootless-arm64e` - For A12+ devices

The workflow file is located at `.github/workflows/build-ios-rootless.yml` and builds both arm64 and arm64e architectures automatically.

### On macOS

Use the optimized macOS build script:

```bash
chmod +x build-ios-rootless-macos.sh
./build-ios-rootless-macos.sh
```

Or build manually:

```bash
# Set environment variables
export GOOS=ios
export GOARCH=arm64
export CGO_ENABLED=1

# Configure iOS SDK
export CC=$(xcrun --sdk iphoneos --find clang)
export CXX=$(xcrun --sdk iphoneos --find clang++)
SDK_PATH=$(xcrun --sdk iphoneos --show-sdk-path)
export CGO_CFLAGS="-isysroot $SDK_PATH -arch arm64 -miphoneos-version-min=12.0"
export CGO_LDFLAGS="-isysroot $SDK_PATH -arch arm64 -miphoneos-version-min=12.0"

# Build
go build -ldflags="-s -w" -o ipatool-ios-rootless .
```

### For arm64e (A12+ devices with pointer authentication)

If you need arm64e architecture support for newer devices:

```bash
export GOOS=ios
export GOARCH=arm64e
export CGO_ENABLED=1

export CC=$(xcrun --sdk iphoneos --find clang)
SDK_PATH=$(xcrun --sdk iphoneos --show-sdk-path)
export CGO_CFLAGS="-isysroot $SDK_PATH -arch arm64e -miphoneos-version-min=12.0"
export CGO_LDFLAGS="-isysroot $SDK_PATH -arch arm64e -miphoneos-version-min=12.0"

go build -ldflags="-s -w" -o ipatool-ios-rootless .
```

### On Windows (Limited)

On Windows, you can attempt a build without CGO (may have limitations):

```powershell
# PowerShell
$env:GOOS = "ios"
$env:GOARCH = "arm64"
$env:CGO_ENABLED = "0"
go build -ldflags="-s -w" -o ipatool-ios-rootless.exe .
```

**Note:** This may not work if the project has dependencies requiring CGO. For full iOS support, use macOS or a macOS build environment.

## Architecture Options

- **arm64**: Compatible with all 64-bit iOS devices (iPhone 5s and later)
- **arm64e**: Required for A12+ devices (iPhone XS and later) with pointer authentication

For rootless jailbreaks, both architectures work, but arm64e is recommended for newer devices.

## Installing on iOS Device

1. Transfer the built binary to your iOS device (via SSH, SCP, or file manager)
2. Place it in a location like `/var/jb/usr/local/bin/` (rootless) or `/usr/local/bin/` (rootful)
3. Set executable permissions:
   ```bash
   chmod +x ipatool-ios-rootless
   ```
4. Optionally add to PATH or create a symlink

## Troubleshooting

### "iOS SDK not found"
- Install Xcode from the App Store
- Run `xcode-select --install` to install command line tools
- Verify with: `xcrun --sdk iphoneos --show-sdk-path`

### "CGO_ENABLED=1 but C compiler not found"
- Ensure Xcode is properly installed
- Check that `xcrun --find clang` returns a valid path

### Build fails on Windows
- iOS cross-compilation from Windows is limited
- Consider using:
  - macOS VM or remote macOS server
  - GitHub Actions with macOS runner
  - Docker with macOS (if available)
  - WSL2 with macOS setup (complex)

## Testing

After building, you can verify the binary:

```bash
file ipatool-ios-rootless
# Should show: Mach-O 64-bit executable arm64 (or arm64e)
```

