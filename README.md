# SwiftyMusic

A Swift helper to handle music playback using AVFoundation.

# Cocoa Pods

CocoaPods is a dependency manager for Cocoa projects. You can install it with the following command:

```swift
$ gem install cocoapods
```

CocoaPods 1.1+ is required to build.

To integrate SwiftyMusic into your Xcode project using CocoaPods, specify it in your Podfile:

```swift
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.3.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'SwiftyMusic'
end
```

Then, run the following command:

```swift
$ pod install
```

You can also download the CocoaPods app for macOS and manage your pods this way.

https://cocoapods.org/app

# Set-Up

- Add the SwiftyMusic.swift file to your project.
- Add your music tracks to your project

Anywhere in your project create an extension of FileName to add the file names of the music tracks that you will use. You can exclude the file extension of the file. 

SwiftyMusic supports the following file formats: 
mp3, wav, aac, ac3, m4a, caf

```swift
extension SwiftyMusic.FileName {
    static let menu = SwiftyMusic.FileName("MenuMusic")
    static let game = SwiftyMusic.FileName("GameMusic")
    
    static var all: [SwiftyMusic.FileName] = [.menu, .game]
}
```

Than setup the helper as soon as your app launches. 

```swift
SwiftyMusic.shared.setup(withFileNames: SwiftyMusic.FileName.all)
```

# How to use

- To play music call the play method with the corresponding Music URL you created above. This will automatically pause (not stop and reset) any previously playing music
```swift
SwiftyMusic.shared.play(.menu)
SwiftyMusic.shared.play(.game)
```

- To pause music manually, eg game paused, advertising etc
```swift
SwiftyMusic.shared.pause()
```

- To resume paused music
```swift
SwiftyMusic.shared.resume()
```

- To adjust volume (e.g game paused)
```swift
SwiftyMusic.shared.setVolume(to: 0.5)
```

- To reset volume (e.g game resumed)
```swift
SwiftyMusic.shared.resetVolume()
```

- To stop and reset all music players, eg gameover
```swift
SwiftyMusic.shared.stopAndResetAll()
```

- To mute music
```swift
SwiftyMusic.shared.isMuted = true
```

- To unmute music
```swift
SwiftyMusic.shared.isMuted = false
```

- To check if music is muted, eg when setting up your mute music button
```swift
if SwiftyMusic.shared.isMuted {
    // music is muted, show unmute button
} else {
    // music not muted, show mute button
}
```

# Release notes

- v4.1.5

Swift 4 update

- v4.1.4

Fixed mute bug

- v4.1.3

Print statements will now only print in DEBUG mode

Cleanup

- v4.1.2

Cleanup

- v4.1.1

Nested enumerations to closer follow Swift API design guidelines

- v4.1

Added ability to adjust volume

- v4.0.5

Cleanup

- v4.0.4

Updated play method to only fire if not currently paused

- v4.0.3

Play method will not fire if its calling the same file thats already playing

Cleanup

- v4.0.2

Cleanup (check setup instructions)

- v4.0.1

Cleanup

- v4.0

Project has been renamed to SwiftyMusic

No more source breaking changes after this update. All future changes will be handled with deprecated messages unless the whole API changes.
