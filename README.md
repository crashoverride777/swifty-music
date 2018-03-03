# SwiftyMusic

A Swift helper to handle music playback using AVFoundation.

## Requirements

- iOS 9.3+
- Swift 4.0+

# Installation

CocoaPods is a dependency manager for Cocoa projects. Simply install the pod by adding the following to your pod file

```swift
pod 'SwiftyMusic'
```

Altenatively you can drag the swift file(s) manually into your project.

# Usage

And add the import statements to your .swift file(s) if you installed via cocoa pods.

```swift
import SwiftyMusic 
```

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
