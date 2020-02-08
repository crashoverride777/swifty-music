# SwiftyMusic

[![Swift 5.0](https://img.shields.io/badge/swift-5.0-ED523F.svg?style=flat)](https://swift.org/download/)
[![Platform](https://img.shields.io/cocoapods/p/SwiftyMusic.svg?style=flat)]()
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/SwiftyMusic.svg)](https://img.shields.io/cocoapods/v/SwiftyMusic.svg)

A Swift helper to handle music playback using AVFoundation.

## Requirements

- iOS 10.3+
- Swift 5.0+

## Installation

### Cocoa Pods

[CocoaPods](https://developers.google.com/admob/ios/quick-start#streamlined_using_cocoapods) is a dependency manager for Cocoa projects. Simply install the pod by adding the following line to your pod file


```swift
pod 'SwiftyMusic'
```

There is now an [app](https://cocoapods.org/app) which makes handling pods much easier

### Swift Package Manager

The Swift Package Manager is a tool for automating the distribution of Swift code and is integrated into the swift compiler.

To add a swift package to your project simple open your project in xCode and click File > Swift Packages > Add Package Dependency.
Than enter `https://github.com/crashoverride777/swifty-music` as the repository URL and finish the setup wizard.

Alternatively if you have a Framwork that requires adding SwiftyMusic as a dependency is as easy as adding it to the dependencies value of your Package.swift.
```swift
dependencies: [
.package(url: "https://github.com/crashoverride777/swifty-music.git", from: "4.4.0")
]
```

### Manually 

Altenatively you can drag the `SwiftyMusic.swift` file into your project.

## Usage

- Add your music tracks to your project. 

SwiftyMusic supports the following file formats: mp3, wav, aac, ac3, m4a, caf

- Add the import statements to your .swift file(s) if you installed via cocoa pods or swift package manager.

```swift
import SwiftyMusic 
```

- Anywhere in your project create an extension of `FileName` to add the file names of the music tracks that you will use. These must be the same as the actual filename of the music file.

```swift
extension SwiftyMusic.FileName {
    static let menu = SwiftyMusic.FileName("MenuMusic")
    static let game = SwiftyMusic.FileName("GameMusic")
    
    static var all: [SwiftyMusic.FileName] = [.menu, .game]
}
```

- Than setup the helper as soon as your app launches. 

```swift
SwiftyMusic.shared.setup(withFileNames: SwiftyMusic.FileName.all)
```

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
