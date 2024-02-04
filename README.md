# Audio Shaker

A Music Player in which you can control audio player by shaking device in a particular manner.

To play/pause the current audio file, you can shake the device from center to back, like in video below.

![](preview/play_pause.mp4)

To change speed of the current audio file, you can shake the device, like in video below.
- center to left to decrease the speed
TODO: GIF

- center to right to increase the speed
TODO: GIF

# Application Folder Structure
1. app - contains config and setup related files
2. models - data classes which will be used everywhere in the app
3. resources - data provider classes and contains dto classes to convert response to model classes
4. repositories - classes used to fetch data from any provider. called from viewmodels.
3. screens
    1. view files - main screen UI
    2. viewmodel files - contains business logic of the app.
4. theme - contains styling and dimensions related code
5. utils - helper classes
6. widgets - common widgets used throughout the app

# Architecture Used
MVVM (Model View ViewModel)
- Model: Simply holds the data.
- View: Shows the UI to the user.
- ViewModel: Link b/w model and view and this can have some business logic as well.

# Steps to run the application on local
```
- start the emulator or connect to physical device.
- run `flutter devices` to check if your device is available to connect.
- run `flutter pub get`
- run `flutter pub run build_runner build --delete-conflicting-outputs`
- run `flutter run`
```

# To generate files after dependency or router changes
```
flutter pub run build_runner build --delete-conflicting-outputs
```

# Main packages used
- Stacked - For state management, routing and service locator
- sensor_plus - To get accelerometer and gyroscope data
- just_audio - For Audio Player

> note: To check the logic used see file -> lib/screens/soundDetail/sound_detail_viewmodel.dart
