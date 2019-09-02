## DI 
- Run the following commands in the folder with pubspec.yaml (root folder)
- If sometimes the created files is not deleted after **clean**, use this:
```
find lib/ -name "*inject.dart" -type f -delete
find lib/ -name "*inject.summary" -type f -delete
```

- **Build**
```
flutter pub run build_runner build
```
- **Clean**
```
flutter pub run build_runner clean
```
- **Watch**
```
flutter pub run build_runner watch
```

#### Reference https://habr.com/en/post/446134/
 
