# A4G Admob iOS Adapter – Sample App

<img width="150" alt="Screenshot 2024-02-02 at 14 58 44" src="https://github.com/hakim-d/a4g-admob-adapter-ios-sample-app/assets/7389034/05219820-021a-474a-be85-ecb5672e9538">


Add these 2 dependencies into your Podfile and run ```pod install```

Use ```:tag => "main"``` for Ad4AdmobMediation pod

```
  ...
  pod "Ad4AdmobMediation", :git => "https://github.com/ad4game/a4g-admob-ios.git", :tag => "main"
  pod "Google-Mobile-Ads-SDK", "9.13.0"
  ...
```

## Troubleshooting

Add your Admob app ID into your application ```Info.plist``` file

```
  <key>GADApplicationIdentifier</key>
  <string>ca-app-pub-3940256099942544~1458002511</string>
```

Add [SKAdNetwork entries](https://developers.google.com/admob/ios/quick-start#update_your_infoplist) to your ```Info.plist```

You might need to set ```Use Script Sandboxing``` to ```No```

<img width="450" alt="Screenshot 2024-01-31 at 15 59 12" src="https://github.com/hakim-d/a4g-admob-adapter-ios-sample-app/assets/7389034/09bfd760-8625-404c-9939-a85998ca4b4b">

Clean build folder and rebuild your app.


