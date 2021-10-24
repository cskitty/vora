# App for Object Detection, Voice Recognition, TTS using Flutter, TF Lite

## Features

- [x] Realtime Object Detection
- [x] Use bluetooth selfie button to start/stop
- [x] TTS to speak out the recognized object
- [ ] Add location information on TTS
- [ ] Add distance estimation
- [ ] Add warning for objects in front of your feet
- [ ] Voice interaction for more commands

## Install Flutter

```console
git clone https://github.com/flutter/flutter.git -b stable
cd flutter
flutter --version
flutter precache
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

## Command Line to Install on Iphone

```console
flutter build ios
flutter install
```

## iPhone Setup

Open ios/Runner.xcworkspace in XCode
Runner->Targets->Signing&Capabilities
Select your personal team
Change Bundle Indentifier to yours

## Accept the iPhone Developer Profile

General->Device Management->Accept developer
