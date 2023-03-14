# Vision Object Recoginition Aid

## An app helping vision impaired people.

## Website

https://vorastudio.org/

## Features

- [x] Realtime Object Detection
- [x] Use bluetooth selfie button to start/stop
- [x] TTS to speak out the recognized object
- [x] Add facetime call to volunteers for help
- [x] Created website http://vora.ml/ for volunteer registeration

## Command Line to Compile and Install on Iphone

```console
flutter build ios
flutter install ios
```

## Install Cocoapods for iOS

```console
sudo gem install cocoapods
gem which cocoapods
```

## Check Flutter Environment

```console
## Check environment
flutter docter

## Set Up the App
flutter packages get
```

## Debug

open visual studio code  
install flutter plugin  
open visual_aid directory  
open lib/main.dart, click the run to install on iphone

## iPhone Setup

Open ios/Runner.xcworkspace in XCode
Runner->Targets->Signing&Capabilities
Select your personal team
Change Bundle Indentifier to yours

## Accept the iPhone Developer Profile to run the app on iOS

General->Device Management->Accept developer
