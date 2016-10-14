# SwiftyMusic

A swift singleton class to handle music playback using AVFoundation.

# Cocoa Pods

I know that the current way of copying the .swift file(s) into your project sucks and is bad practice, so I am working hard to finally support CocoaPods very soon. Stay tuned.

# Set-Up

- Add the SwiftyMusic.swift file to your project.
- Add your music tracks to your project

Create an extension of FileName to add your music file names in your project.

```swift
extension SwiftyMusic.FileName {
    static let menu = SwiftyMusic.FileName(rawValue: "MenuMusic")
    static let game = SwiftyMusic.FileName(rawValue: "GameMusic")
    
    static var all: [SwiftyMusic.FileName] = [.menu, .game]
}
```

NOTE: The following file formats are supported: mp3, wav, aac, ac3, m4a, caf

Than init the helper as soon as your app launches. 

```swift
SwiftyMusic.shared.setup(withFileNames: SwiftyMusic.FileName.all)
```

# How to use

- To play music call the play method with the corresponding Music URL. This will automatically pause (not stop and reset) any previously playing music
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

- To mute music
```swift
SwiftyMusic.shared.mute()
```

- To unmute music
```swift
SwiftyMusic.shared.unmute()
```

- To stop and reset all music players, eg gameover
```swift
SwiftyMusic.shared.stopAndResetAll()
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

- v4.0

Project has been renamed to SwiftyMusic

No more source breaking changes after this update. All future changes will be handled with deprecated messages.
