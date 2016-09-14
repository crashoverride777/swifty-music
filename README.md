# Swift Music Helper

A swift singleton class to handle music playback using AVFoundation.

# Set-Up

- Add the Music.swift file to your project.
- Add your music tracks to your project


Create an extension of FileName to add your file names

```swift
extension Music.FileName {
    static let menu = Music.FileName(rawValue: "MenuMusic")
    static let game = Music.FileName(rawValue: "GameMusic")
    
    static var all = [Music.FileName.menu, Music.FileName.game]
}
```

NOTE: By default the helper supports mp3 and wav as file formats. If you have another format go to the MusicPlayer.swift file and update the prepare method with the new file extension.

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

- To stop and reset music, eg gameover
```swift
Music.shared.stop()
```

- To mute music
```swift
Music.shared.mute()
```

- To unmute music
```swift
Music.shared.unmute()
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

- v3.0

Revert project back into a singleton class to make the API easier to use and understand.

Documentation and other improvements.

Swift 3 support.
