# SwiftyMusic

[![Swift 5.0](https://img.shields.io/badge/swift-5.0-ED523F.svg?style=flat)](https://swift.org/download/)
[![Platform](https://img.shields.io/cocoapods/p/SwiftyMusic.svg?style=flat)]()
[![SPM supported](https://img.shields.io/badge/SPM-supported-DE5C43.svg?style=flat)](https://swift.org/package-manager)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/SwiftyMusic.svg)](https://img.shields.io/cocoapods/v/SwiftyMusic.svg)

A Swift helper to handle music playback using AVFoundation.

## Requirements

- iOS 11.4+
- Swift 5.0+

## Installation

### Cocoa Pods

[CocoaPods](https://developers.google.com/admob/ios/quick-start#streamlined_using_cocoapods) is a dependency manager for Cocoa projects. Simply install the pod by adding the following line to your pod file


```swift
pod 'SwiftyMusic'
```

### Swift Package Manager

The Swift Package Manager is a tool for automating the distribution of Swift code and is integrated into the swift compiler.

To add a swift package to your project simple open your project in xCode and click File > Swift Packages > Add Package Dependency.
Than enter `https://github.com/crashoverride777/swifty-music.git` as the repository URL and finish the setup wizard.

Alternatively if you have a Swift package that requires adding SwiftyMusic as a dependency it is as easy as adding it to the dependencies value of your Package.swift.
```swift
dependencies: [
    .package(url: "https://github.com/crashoverride777/swifty-music.git", from: "4.4.0")
]
```

### Manually 

Alternatively you can drag the `Sources` folder and its containing files into your project.

## Usage

- Add your music tracks to your project. 

SwiftyMusic supports the following file formats: `mp3, wav, aac, ac3, m4a, caf`

- Add the import statements to your .swift file(s) if you installed via cocoa pods or swift package manager.

```swift
import SwiftyMusic 
```

- Anywhere in your project create an extension of `SwiftyMusicFileName` to add the file names of the music tracks that you will use. These must be the same as the actual filename of the music file.

```swift
extension SwiftyMusicFileName {
    static let menu = SwiftyMusicFileName("MenuMusic")
    static let game = SwiftyMusicFileName("GameMusic")
    
    static var all: [SwiftyMusicFileName] = [.menu, .game]
}
```

- Than setup the helper as soon as your app launches. 

```swift
SwiftyMusic.shared.setup(withFileNames: SwiftyMusicFileName.all)
```

- To play music call the play method with the corresponding Music URL you have created above. This will automatically pause any previously playing music
```swift
SwiftyMusic.shared.play(.menu)
SwiftyMusic.shared.play(.game)
```

- Pause music
```swift
SwiftyMusic.shared.pause()
```

- Resume paused music
```swift
SwiftyMusic.shared.resume()
```

- Adjust volume
```swift
SwiftyMusic.shared.setVolume(to: 0.5)
```

- Stop and reset all music players
```swift
SwiftyMusic.shared.reset()
```

- Mute
```swift
SwiftyMusic.shared.setMuted(true)

if SwiftyMusic.shared.isMuted {
    // music is muted, show unmute button
} else {
    // music not muted, show mute button
}
```

## Testing

To test your classes using SwiftyMusic you can inject the `SwiftyMusicType` protocol

```swift
class SomeClass {
    private let swiftyMusic: SwiftyMusicType
    
    init(swiftyMusic: SwiftyMusicType = SwiftyMusic.shared) {
        self.swiftyMusic = swiftyMusic
    }
}
```

and than provide a mock implementation when testing

```swift
class MockSwiftyMusic { }
extension MockSwiftyMusic: SwiftyMusicType { ... }

class SomeClassTests {
    func test() {
        let sut = SomeClass(swiftyMusic: MockSwiftyMusic())
    }
}
```
