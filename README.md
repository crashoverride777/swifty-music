# SwiftyMusic

A swift singleton class to handle music playback using AVFoundation.

# Cocoa Pods

I know that the current way of copying the .swift file(s) into your project sucks and is bad practice, so I am working hard to finally support CocoaPods very soon. Stay tuned.

In the meantime I would create a folder on your Mac, called something like SharedFiles, and drag the swift file(s) into this folder. Than drag the files from this folder into your project, making sure that "copy if needed" is not selected. This way its easier to update the files and to share them between projects.

# Set-Up

- Add the SwiftyMusic.swift file to your project.
- Add your music tracks to your project

Anywhere in your project create an extension of FileName to add your music file names that you want to use.

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

- v4.0.1

Cleanup

- v4.0

Project has been renamed to SwiftyMusic

No more source breaking changes unless after this update. All future changes will be handled with deprecated messages unless the whole API changes.
