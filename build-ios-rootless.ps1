# Build script for iOS rootless (arm64/arm64e)
# PowerShell version for Windows
# Note: Go iOS cross-compilation typically requires macOS with Xcode
# This script provides the commands but may not work on Windows without special setup

Write-Host "Building ipatool for iOS rootless..." -ForegroundColor Cyan

# Set build variables for iOS rootless
$env:GOOS = "ios"
$env:GOARCH = "arm64"
$env:CGO_ENABLED = "0"  # Disable CGO on Windows (no iOS SDK available)

# For rootless jailbreaks, you might need arm64e architecture
# Uncomment the line below if you need arm64e instead of arm64
# $env:GOARCH = "arm64e"

Write-Host "GOOS: $env:GOOS"
Write-Host "GOARCH: $env:GOARCH"
Write-Host "CGO_ENABLED: $env:CGO_ENABLED"

# Build flags
$buildFlags = "-ldflags=-s -w"
$outputName = "ipatool-ios-rootless.exe"

Write-Host "`nAttempting to build..." -ForegroundColor Yellow

# Build the binary
go build $buildFlags -o $outputName .

if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ Build successful: $outputName" -ForegroundColor Green
    Get-Item $outputName | Select-Object Name, Length, LastWriteTime
} else {
    Write-Host "✗ Build failed" -ForegroundColor Red
    Write-Host "`nNote: iOS cross-compilation from Windows is limited." -ForegroundColor Yellow
    Write-Host "For full iOS support, you may need:" -ForegroundColor Yellow
    Write-Host "  1. macOS with Xcode installed" -ForegroundColor Yellow
    Write-Host "  2. Or use a macOS build server/CI" -ForegroundColor Yellow
    Write-Host "  3. Or use gomobile for iOS builds" -ForegroundColor Yellow
    exit 1
}

