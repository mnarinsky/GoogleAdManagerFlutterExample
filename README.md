# firebase_GAM_example

Demonstrates how to use the firebase_admob plugin with Google Ad Manager.

## Getting Started

For help getting started with Flutter AdMob plugin read [documentation](https://github.com/flutter/flutterfire_temporary/blob/master/packages/firebase_admob/README.md).

## Platform Specific Setup for the Google Ad Manager sample app

This sample app supports Android and iOS and requires additional setup on both platforms before it can
be used in your app. The sections below explain the setup for each platform.

### Android

#### Ensure your AndroidManifest.xml is configured to use Google Ad Manager

Declare that your app is an Ad Manager app by adding the following <meta-data> tag in your AndroidManifest.xml.

```xml
<manifest>
    <application>
        <meta-data
            android:name="com.google.android.gms.ads.AD_MANAGER_APP"
            android:value="true"/>
    </application>
</manifest>
```
See https://developers.google.com/ad-manager/mobile-ads-sdk/android/quick-start#update_your_androidmanifestxml for more information about configuring `AndroidManifest.xml` and setting up your App ID.
This step is required as of Google Mobile Ads SDK version 17.0.0. Failure to add this <meta-data> tag results in a crash with the message: The Google Mobile Ads SDK was initialized incorrectly.

### iOS

### Ensure your Info.plist is configured to use Google Ad Manager

Declare that your app is an Ad Manager app by adding the GADIsAdManagerApp key with a <true/> value to your app's Info.plist.

```xml
<key>GADIsAdManagerApp</key>
<true/>
```

See https://developers.google.com/ad-manager/mobile-ads-sdk/ios/quick-start#update_your_infoplist for more information
about configuring `Info.plist`

## Ad request parameters

The following Google Ad Manager ad requests parameters are supported and can be modified per request:
- Google Ad Manager Key-Value pairs
- Content URL
- TFCD flag
- NPA flag
- Test device ID