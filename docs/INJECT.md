## DI 
#### reference https://habr.com/en/post/446134/
run in the folder with pubspec.yaml (root folder)

### build
flutter pub run build_runner build
or 
flutter pub run build_runner build --delete-conflicting-outputs

### clean
flutter pub run build_runner clean

### watch
flutter pub run build_runner watch 

### if sometimes the create files is not deleted by 'clean', use this:
find lib/ -name "*inject.dart" -type f -delete
find lib/ -name "*inject.summary" -type f -delete