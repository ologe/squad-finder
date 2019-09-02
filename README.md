# Squad finder
Squad finder is a maps application that allows to share your location with your squad. 
<br>
I created the app to familiarize with:
- Dart
- Flutter 
- Dependency injection with Flutter
- Clean architecture with Flutter
- rx_dart
- Google Maps


### Screenshots
- UI in progress

### Build
- Download [dart.inject](https://github.com/google/inject.dart/tree/4ffd3d339d8b776b2bec8d95ae6d3d168856e76c) submodule: 
```
cd inject.dart/
git submodule update --init
```

- Run `flutter packages get` in the root folder, check [docs](https://github.com/ologe/squad-finder/blob/master/docs/INJECT.md)
for more information.

- Build the dependency graph using `flutter pub run build_runner build`. To avoid writing this every time, 
I created some simple helpers (bash scripts). Run the script using `./script_name` inside the root folder.  
    - `di_clean`
    - `di_build`: clean then build the graph
    - `di_run`: clean, build, then run the app
    - `di_watch`: clean then watches file changes to build the graph incrementally

- Add your **Google Maps API** key to:
    - **Android**, in `android/local.properties`, add:
    ```properties
    maps_key="your_api_key"
    ```

    - **iOS**, create a file called `keys.plist` inside `ios/Runner` folder, and paste:
    ```
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
    
        <key>MapsKey</key>
        <string>your_api_key</string>
    
    </dict>
    </plist>
    ```
### TODO
- [] Finish
- [ ] Add unit tests
- [ ] Add material/cupertino theming  

### Libraries
- [dart.inject](https://github.com/google/inject.dart/tree/4ffd3d339d8b776b2bec8d95ae6d3d168856e76c)
- [rx_dart](https://pub.dev/packages/rxdart)
- [firebase_auth](https://pub.dev/packages/firebase_auth)
- [firestore](https://pub.dev/packages/cloud_firestore)
- [google_sign_in](https://pub.dev/packages/google_sign_in)
- [geolocator](https://pub.dev/packages/geolocator)
- [google_maps_flutter](https://pub.dev/packages/google_maps_flutter)
- [location_permissions](https://pub.dev/packages/location_permissions)
- [logger](https://pub.dev/packages/logger)