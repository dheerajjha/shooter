# CI/CD Setup Guide: Flutter iOS to TestFlight via GitHub Actions

This document outlines the complete end-to-end setup for automating Flutter iOS app deployment to TestFlight using GitHub Actions and Fastlane.

## Prerequisites

- Flutter project with iOS target
- Apple Developer Account (paid)
- GitHub repository
- macOS machine for initial setup

## Overview

The CI/CD pipeline consists of:
1. **Fastlane Match** for code signing certificate management
2. **Fastlane** for build automation
3. **GitHub Actions** for CI/CD execution

---

## Phase 1: Apple Developer Setup

### 1.1 App Store Connect API Key

1. Go to [App Store Connect](https://appstoreconnect.apple.com)
2. Navigate to **Users and Access** → **Integrations** → **App Store Connect API**
3. Click **Generate API Key**
   - Name: `GitHub Actions CI/CD`
   - Access: **App Manager** or **Admin**
4. Download the `.p8` key file (you can only download once!)
5. Note down:
   - **Key ID** (e.g., `ABC123DEFG`)
   - **Issuer ID** (UUID format)

### 1.2 Create App in App Store Connect

1. Go to **My Apps** → **+** → **New App**
2. Fill in:
   - Platform: iOS
   - Name: Your app name
   - Primary Language
   - Bundle ID: Must match your Flutter app's bundle identifier
   - SKU: Unique identifier

---

## Phase 2: Fastlane Match Setup

Fastlane Match stores your certificates and provisioning profiles in a private Git repository.

### 2.1 Create Private Certificates Repository

1. Create a new **private** GitHub repository (e.g., `ios-certificates`)
2. Initialize it with a README
3. Generate a **Personal Access Token** with `repo` scope:
   - Go to GitHub Settings → Developer settings → Personal access tokens → Tokens (classic)
   - Generate new token (classic)
   - Select scope: `repo` (full control)
   - Copy the token (you won't see it again!)

### 2.2 Initialize Fastlane Match

```bash
cd ios
bundle init
bundle add fastlane
bundle exec fastlane match init
```

When prompted:
- Select: **git**
- Enter your certificates repo URL: `https://github.com/YOUR_USERNAME/ios-certificates`

### 2.3 Generate Certificates and Profiles

```bash
# For App Store distribution
bundle exec fastlane match appstore --readonly false

# If you need development certificates
bundle exec fastlane match development --readonly false
```

You'll be prompted for:
- **Git URL credentials** (use your GitHub token as password)
- **Passphrase** to encrypt certificates (remember this!)
- **Apple ID** and password
- Select your **Team** if you have multiple

This creates and uploads:
- Distribution certificate
- App Store provisioning profile

---

## Phase 3: Fastlane Configuration

### 3.1 Create Fastfile

Create or update `ios/fastlane/Fastfile`:

```ruby
default_platform(:ios)

platform :ios do
  desc "Push a new beta build to TestFlight"
  lane :beta do
    # Get the bundle identifier from environment or use default
    bundle_id = ENV["APP_BUNDLE_ID"] || "com.yourcompany.yourapp"
    
    # Setup code signing with Match
    setup_ci if ENV['CI']
    
    match(
      type: "appstore",
      readonly: true,
      git_url: ENV["MATCH_GIT_URL"],
      git_basic_authorization: Base64.strict_encode64(ENV["MATCH_GIT_TOKEN"]),
      app_identifier: bundle_id
    )

    # Increment build number
    increment_build_number(
      xcodeproj: "Runner.xcodeproj"
    )

    # Build the app
    build_app(
      workspace: "Runner.xcworkspace",
      scheme: "Runner",
      export_method: "app-store",
      configuration: "Release",
      export_options: {
        method: "app-store",
        provisioningProfiles: {
          bundle_id => "match AppStore #{bundle_id}"
        },
        signingStyle: "manual",
        teamID: ENV["APPLE_TEAM_ID"]
      },
      xcargs: "-allowProvisioningUpdates DEVELOPMENT_TEAM=#{ENV['APPLE_TEAM_ID']}"
    )

    # Upload to TestFlight
    upload_to_testflight(
      api_key_path: "api_key.json",
      skip_waiting_for_build_processing: true,
      skip_submission: true
    )
  end
end
```

### 3.2 Create Appfile

Create `ios/fastlane/Appfile`:

```ruby
app_identifier(ENV["APP_BUNDLE_ID"] || "com.yourcompany.yourapp")
apple_id(ENV["APPLE_ID"] || "your.email@example.com")
team_id(ENV["APPLE_TEAM_ID"] || "YOUR_TEAM_ID")
```

### 3.3 Create Gemfile

Create `ios/Gemfile`:

```ruby
source "https://rubygems.org"

gem "fastlane"
gem "cocoapods"
```

Then run:
```bash
cd ios
bundle install
```

---

## Phase 4: GitHub Secrets Setup

Add these secrets to your GitHub repository (Settings → Secrets and variables → Actions):

| Secret Name | Description | Example/Notes |
|-------------|-------------|---------------|
| `APP_STORE_CONNECT_API_KEY_ID` | API Key ID from Step 1.1 | `ABC123DEFG` |
| `APP_STORE_CONNECT_API_ISSUER_ID` | Issuer ID from Step 1.1 | UUID format |
| `APP_STORE_CONNECT_API_KEY_CONTENT` | Content of .p8 file | Copy entire file content |
| `APPLE_ID` | Your Apple ID email | `you@example.com` |
| `APPLE_TEAM_ID` | Your Team ID | Find in Apple Developer Account |
| `MATCH_PASSWORD` | Passphrase from Step 2.3 | The encryption passphrase |
| `MATCH_GIT_TOKEN` | GitHub token from Step 2.1 | `ghp_xxxxxxxxxxxx` |
| `APP_BUNDLE_ID` | Your app's bundle identifier | `com.yourcompany.yourapp` |

---

## Phase 5: GitHub Actions Workflow

Create `.github/workflows/ios-testflight.yml`:

```yaml
name: iOS TestFlight Deployment

on:
  push:
    branches:
      - main
      - master
  workflow_dispatch:

jobs:
  deploy:
    runs-on: macos-latest
    timeout-minutes: 60

    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      - name: Set up Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.10.0'  # Or compatible version with your pubspec.yaml
          channel: 'stable'
          cache: true

      - name: Install Flutter dependencies
        run: flutter pub get

      - name: Set up Ruby
        uses: ruby/setup-ruby@v1
        with:
          ruby-version: '3.2'
          bundler-cache: true
          working-directory: ios

      - name: Create App Store Connect API Key JSON
        run: |
          mkdir -p ios/fastlane
          cat > ios/fastlane/api_key.json << EOF
          {
            "key_id": "${{ secrets.APP_STORE_CONNECT_API_KEY_ID }}",
            "issuer_id": "${{ secrets.APP_STORE_CONNECT_API_ISSUER_ID }}",
            "key": "${{ secrets.APP_STORE_CONNECT_API_KEY_CONTENT }}",
            "in_house": false
          }
          EOF

      - name: Deploy to TestFlight
        env:
          MATCH_PASSWORD: ${{ secrets.MATCH_PASSWORD }}
          MATCH_GIT_TOKEN: ${{ secrets.MATCH_GIT_TOKEN }}
          MATCH_GIT_URL: https://oauth2:${{ secrets.MATCH_GIT_TOKEN }}@github.com/YOUR_USERNAME/ios-certificates.git
          APPLE_ID: ${{ secrets.APPLE_ID }}
          APPLE_TEAM_ID: ${{ secrets.APPLE_TEAM_ID }}
          APP_BUNDLE_ID: ${{ secrets.APP_BUNDLE_ID }}
          FASTLANE_SKIP_UPDATE_CHECK: "1"
          FASTLANE_HIDE_CHANGELOG: "1"
        run: |
          cd ios
          bundle exec fastlane beta

      - name: Clean up
        if: always()
        run: rm -f ios/fastlane/api_key.json
```

**Important**: Replace `YOUR_USERNAME` with your actual GitHub username in the `MATCH_GIT_URL`.

---

## Phase 6: Verification & Testing

### 6.1 Local Test (Optional)

Before pushing to GitHub, test locally:

```bash
# Set environment variables
export MATCH_PASSWORD="your_passphrase"
export MATCH_GIT_TOKEN="your_github_token"
export MATCH_GIT_URL="https://oauth2:${MATCH_GIT_TOKEN}@github.com/YOUR_USERNAME/ios-certificates.git"
export APPLE_ID="your@email.com"
export APPLE_TEAM_ID="YOUR_TEAM_ID"
export APP_BUNDLE_ID="com.yourcompany.yourapp"

# Run Fastlane
cd ios
bundle exec fastlane beta
```

### 6.2 Trigger CI/CD

1. Commit and push to `main` or `master` branch
2. Go to GitHub → Actions tab
3. Watch the workflow execution
4. Check for errors in each step

### 6.3 Verify TestFlight Upload

1. Go to [App Store Connect](https://appstoreconnect.apple.com)
2. Navigate to your app → TestFlight tab
3. Wait for Apple to process the build (10-30 minutes)
4. Add internal/external testers
5. Submit for beta review if needed

---

## Common Issues & Solutions

### Issue: "No matching provisioning profiles found"
**Solution**: Run `fastlane match appstore --readonly false` locally to regenerate profiles.

### Issue: "Authentication failed"
**Solution**: Verify all secrets are correctly set in GitHub. Check token hasn't expired.

### Issue: "Dart SDK version conflict"
**Solution**: Update Flutter version in workflow to match `pubspec.yaml` Dart SDK requirements.

### Issue: "Certificate already exists"
**Solution**: Use `match nuke` to clear and regenerate (destructive - use carefully!).

### Issue: "Build takes too long"
**Solution**: Increase `timeout-minutes` in workflow. Default is 60.

---

## Maintenance

### Updating Certificates
Certificates expire after 1 year. Regenerate with:
```bash
bundle exec fastlane match appstore --force_for_new_devices
```

### Version Bumping
Build number auto-increments. For version changes, update in `pubspec.yaml`:
```yaml
version: 1.2.0+10  # version+build_number
```

### Adding New Devices
For development/ad-hoc builds:
```bash
bundle exec fastlane match development --force_for_new_devices
```

---

## Security Best Practices

1. ✅ Never commit certificates or `.p8` files to your app repository
2. ✅ Use GitHub Secrets for all sensitive data
3. ✅ Keep certificates repo private
4. ✅ Rotate GitHub tokens periodically
5. ✅ Use strong passphrase for Match encryption
6. ✅ Enable 2FA on Apple ID and GitHub
7. ✅ Limit API key permissions to minimum required
8. ✅ Clean up temporary files in CI (api_key.json)

---

## Workflow Triggers Explained

Current configuration triggers on:
- **Push to main/master**: Every commit triggers deployment
- **Manual dispatch**: Can trigger from GitHub Actions UI

To modify triggers, edit the `on:` section in workflow file:

```yaml
on:
  # Only on tags
  push:
    tags:
      - 'v*'
  
  # Only on pull request merge
  pull_request:
    types: [closed]
    branches: [main]
    
  # Schedule (cron)
  schedule:
    - cron: '0 0 * * 0'  # Weekly on Sunday
```

---

## Cost Considerations

- **Apple Developer Program**: $99/year (required)
- **GitHub Actions**: Free for public repos, 2000 minutes/month for private repos
- **macOS runner usage**: ~10 minutes per build
- **Estimated monthly cost for private repo**: ~$0-10 depending on build frequency

---

## Resources

- [Fastlane Documentation](https://docs.fastlane.tools/)
- [Fastlane Match](https://docs.fastlane.tools/actions/match/)
- [GitHub Actions for Flutter](https://docs.flutter.dev/deployment/cd)
- [App Store Connect API](https://developer.apple.com/documentation/appstoreconnectapi)

---

## Checklist

Use this checklist for new projects:

- [ ] Apple Developer Account active
- [ ] App created in App Store Connect
- [ ] App Store Connect API Key generated and saved
- [ ] Private certificates repository created
- [ ] GitHub Personal Access Token generated
- [ ] Fastlane Match initialized and certificates generated
- [ ] All GitHub Secrets configured
- [ ] Fastfile, Appfile, and Gemfile created
- [ ] GitHub Actions workflow file created
- [ ] Workflow file updated with correct repository URLs
- [ ] Local test successful (optional)
- [ ] First CI/CD deployment successful
- [ ] TestFlight build appears in App Store Connect

---

**Document Version**: 1.0  
**Last Updated**: 2025-10-21  
**Tested With**: Flutter 3.10.0, Fastlane 2.x, GitHub Actions (macos-latest)
