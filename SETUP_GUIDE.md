# iOS TestFlight Deployment Setup Guide

## 🎉 What's Been Completed

✅ **Bundle ID Updated**: Changed from `com.example.shooter` to `com.dailypro.shooter`  
✅ **Fastlane Configuration**: Complete Fastfile with TestFlight deployment lane  
✅ **GitHub Actions Workflow**: Automated CI/CD pipeline created  
✅ **Appfile Configured**: Apple Developer credentials properly set  

---

## 📋 Next Steps (Manual Actions Required)

### Step 1: Create App ID in Apple Developer Portal

Run this command:
```bash
cd ~/Documents/RealFlutterAP/OctMusings2025/shooter/ios
fastlane produce --app_identifier com.dailypro.shooter --app_name "Shooter" --skip_itc true
```

**Expected**: App ID `com.dailypro.shooter` created in Developer Portal  
**Verify**: https://developer.apple.com/account/resources/identifiers/list

---

### Step 2: Create App in App Store Connect

Run this command:
```bash
cd ~/Documents/RealFlutterAP/OctMusings2025/shooter/ios
fastlane produce --app_identifier com.dailypro.shooter --app_name "Shooter" --skip_devcenter true
```

**Expected**: App "Shooter" created in App Store Connect  
**Verify**: https://appstoreconnect.apple.com/ → My Apps

**Alternative (if fastlane fails)**: Create manually:
1. Go to https://appstoreconnect.apple.com/apps
2. Click "+" to add new app
3. Select iOS platform, enter name "Shooter"
4. Select bundle ID: com.dailypro.shooter
5. Fill in SKU (any unique identifier)

---

### Step 3: Generate App Store Connect API Key

**🔑 IMPORTANT: This is required for CI/CD authentication**

1. Go to https://appstoreconnect.apple.com/access/api
2. Sign in with `dheeraj.jha.ub@gmail.com`
3. Click "Keys" → "+" (Generate API Key)
4. Name: "GitHub CI/CD - Shooter"
5. Access: **Developer** (required for TestFlight)
6. Click "Generate"

**Save these values:**
- **Issuer ID**: (format: xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx)
- **Key ID**: (format: XXXXXXXXXX)
- **Download .p8 file**: ⚠️ You can only download this ONCE!

**Convert .p8 to base64:**
```bash
cat ~/Downloads/AuthKey_XXXXXXXXXX.p8 | base64
```
Copy the output - you'll need it for GitHub secrets!

---

### Step 4: Set Up Code Signing with match

**4a. Create Private GitHub Repository:**
1. Go to https://github.com/new
2. Repository name: `shooter-certificates`
3. Make it **Private**
4. Click "Create repository"

**4b. Initialize match:**
```bash
cd ~/Documents/RealFlutterAP/OctMusings2025/shooter/ios
fastlane match init
```
- Select option **1** (git)
- Enter: `https://github.com/dheerajjha/shooter-certificates.git`

**4c. Generate certificates:**
```bash
fastlane match appstore --app_identifier com.dailypro.shooter
```
- Enter a **passphrase** (save this securely!)
- This creates certificates and provisioning profiles
- Stores them in your certificates repo

**Save for later:**
- Match passphrase (for GitHub secret: `MATCH_PASSWORD`)

---

### Step 5: Configure GitHub Secrets

Go to https://github.com/dheerajjha/shooter/settings/secrets/actions

Add these 5 secrets:

| Secret Name | Value |
|-------------|-------|
| `APP_STORE_CONNECT_API_KEY_ID` | Key ID from Step 3 |
| `APP_STORE_CONNECT_API_ISSUER_ID` | Issuer ID from Step 3 |
| `APP_STORE_CONNECT_API_KEY_CONTENT` | base64-encoded .p8 content from Step 3 |
| `MATCH_PASSWORD` | Passphrase from Step 4 |
| `MATCH_GIT_BASIC_AUTHORIZATION` | See below ⬇️ |

**For MATCH_GIT_BASIC_AUTHORIZATION:**
1. Create GitHub Personal Access Token at https://github.com/settings/tokens
2. Token needs **"repo"** scope (for private repository access)
3. Encode it: `echo -n "dheerajjha:YOUR_TOKEN_HERE" | base64`
4. Use the base64 output as the secret value

---

### Step 6: Test Locally (Optional but Recommended)

Before pushing to GitHub, test the setup locally:

```bash
cd ~/Documents/RealFlutterAP/OctMusings2025/shooter/ios
bundle exec fastlane beta
```

**Expected**:
- Build number increments
- App builds successfully
- Uploads to TestFlight
- Check App Store Connect → TestFlight for the build

---

### Step 7: Commit and Deploy

```bash
cd ~/Documents/RealFlutterAP/OctMusings2025/shooter

git add .
git commit -m "Configure iOS TestFlight deployment

- Update bundle ID to com.dailypro.shooter
- Set up fastlane with match for code signing
- Configure GitHub Actions workflow for automated deployment
- Add comprehensive Fastfile with beta lane"

git push origin main
```

**Monitor the deployment:**
- Go to https://github.com/dheerajjha/shooter/actions
- Watch the workflow run in real-time
- Build should appear in App Store Connect within 15-30 minutes

---

## 🎯 Success Indicators

- ✅ GitHub Actions workflow shows green checkmark
- ✅ Build appears in App Store Connect → TestFlight
- ✅ Build status shows "Processing" or "Ready to Submit"
- ✅ No error notifications from Apple

---

## 🚀 Future Deployments

Once setup is complete, every push to `main` branch automatically:
1. Runs Flutter tests
2. Builds the iOS app
3. Signs with match certificates
4. Uploads to TestFlight
5. Increments build number automatically

**Manual deployment:**
```bash
cd ios && bundle exec fastlane beta
```

---

## 📱 Adding Testers

1. Log into https://appstoreconnect.apple.com/
2. Navigate to TestFlight → Internal Testing
3. Add testers by email
4. Testers receive invitation to test the app

---

## ⚙️ Configuration Summary

- **Bundle ID**: `com.dailypro.shooter`
- **App Name**: Shooter
- **Team ID**: `83C822A4J3`
- **ITC Team ID**: `127480247`
- **Apple ID**: `dheeraj.jha.ub@gmail.com`

---

## 🆘 Troubleshooting

**"No signing certificate found"**
```bash
cd ios && fastlane match appstore --app_identifier com.dailypro.shooter
```

**"Invalid API Key"**
- Verify Key ID and Issuer ID in GitHub secrets
- Ensure .p8 file was properly base64-encoded

**"App not found"**
- Confirm app was created in App Store Connect (Step 2)
- Verify bundle ID matches: `com.dailypro.shooter`

**Check logs:**
- GitHub Actions: https://github.com/dheerajjha/shooter/actions
- Local logs: `ios/fastlane/report.xml`

---

## 📞 Need Help?

- Fastlane docs: https://docs.fastlane.tools
- GitHub Actions docs: https://docs.github.com/en/actions
- App Store Connect: https://developer.apple.com/support/app-store-connect/
