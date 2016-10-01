# Swift Music Helper

A swift singleton class to handle music playback using AVFoundation.

# Set-Up

- Add the MusicManager.swift file to your project.
- Add your music tracks to your project

Create an extension of FileName to add your music file names in your project.

```swift
extension Music.FileName {
    static let menu = Music.FileName(rawValue: "MenuMusic")
    static let game = Music.FileName(rawValue: "GameMusic")
    
    static var all: [Music.FileName] = [.menu, .game]
}
```

NOTE: The following file formats are supported: mp3, wav, aac, ac3, m4a, caf

Than init the helper as soon as your app launches. 

```swift
Music.shared.setup(forFileNames: Music.FileName.all)
```

# How to use

- To play music call the play method with the corresponding Music URL. This will automatically pause (not stop and reset) any previously playing music
```swift
Music.shared.play(.menu)
Music.shared.play(.game)
```

- To pause music manually, eg game paused, advertising etc
```swift
Music.shared.pause()
```

- To resume paused music
```swift
Music.shared.resume()
```

- To mute music
```swift
Music.shared.mute()
```

- To unmute music
```swift
Music.shared.unmute()
```

- To stop and reset all music players, eg gameover
```swift
Music.shared.stopAndResetAll()
```

- To check if music is muted, eg when setting up your mute music button
```swift
if Music.shared.isMuted {
    // music is muted, show unmute button
} else {
    // music not muted, show mute button
}
```

# Release notes

- v3.0.2

Added support for the following file formats: aac, ac3, m4a, caf

- v3.0.1

Cleanup and documentation fixes

Stop method is now called

```swift
Music.shared.stopAndResetAll()
```

- v3.0

Updated to Swift 3 

Revert project back into a singleton class to make the API easier to use and understand

Documentation and other improvements
