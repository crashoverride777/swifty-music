# Swift Music Helper

A swift protocol extension to handle music playback.

# Set-Up

- Add the Music.swift file to your project.
- Add your music tracks to your project

# SetUp

Create a global enum with all your music file names.

```swift
enum MusicURL: String {
    case menu = "AngryFlappiesMenuMusic"
    case game = "AngryFlappiesGameMusic"
    
    static var all = [menu.rawValue, game.rawValue]
}
```

NOTE: By default the helper supports mp3 and wav as file formats. If you have another format go to the MusicPlayer.swift file update the prepare method with the new file extension.

Than init the helper as soon as your app launches like this

```swift
MusicPlayer.sharedInstance.setup(withURLs: MusicURL.all)
```

# How to use

Conform to the musicControls protocol in the class you need to play music from

```swift
class MyClass: ..., MusicControls
```

- To play music call the play method with the corresponding Music URL. This will automatically pause (not stop and reset) any previously playing music
```swift
playMusic(playerURL: MusicURL.menu.rawValue)
playMusic(playerURL: MusicURL.game.rawValue)
```

- To pause music manually, eg when game paused, for advertising etc
```swift
pauseMusic()
```

- To resume paused music
```swift
resumeMusic()
```

- To stop and reset music, eg gameover
```swift
stopMusic()
```

- To mute music
```swift
muteMusic()
```

- To unmute music
```swift
unmuteMusic()
```

- To check if music is muted, eg when setting up your mute music button
```swift
if musicIsMuted {
    // music is muted, show unmute button
} else {
    // music not muted, show mute button
}
```

# Release notes

- v2.0

Redesign using protocol extension. Please read the instructions again.
