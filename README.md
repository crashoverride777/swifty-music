# Swift Music Helper

A simple and extendable music helper class.

# Set-Up

- Add the Music.swift file to your project.
- Add your music tracks to your project

# How to use

Create a global enum with all your music file names.

```swift
enum MusicURL: String {
    case menu = "AngryFlappiesMenuMusic"
    case game = "AngryFlappiesGameMusic"
    
    static var all = [menu.rawValue, game.rawValue]
}
```

NOTE: By default the helper supports mp3 and wav as file formats. If you have another format go to the helper and update the prepare method with the new file extension.

Than init the helper as soon as your app launches like this

```swift
Music.sharedInstance.setUp(withURLs: MusicURL.all)
```

- To play music call the play method with the corresponding Music URL. This will automatically pause (not stop and reset) any previously playing music
```swift
Music.sharedInstance.play(playerURL: MusicURL.menu.rawValue)
Music.sharedInstance.play(playerURL: MusicURL.game.rawValue)
```

- To pause music manually, eg when game paused, for advertising etc
```swift
Music.sharedInstance.pause()
```

- To resume paused music
```swift
Music.sharedInstance.resume()
```

- To stop and reset music, eg gameover
```swift
Music.sharedInstance.stop()
```

- To mute music
```swift
Music.sharedInstance.mute()
```

- To unmute music
```swift
Music.sharedInstance.unmute()
```

- To check if music is muted, eg when setting up your mute music button
```swift
if !Music.sharedInstance.isMuted {
     // music not muted, show mute button
} else {
    // music is muted, show unmute button
}
```

# Release notes

- v1.4

Clean-up and improvements

- v1.3.2

Clean-up and improvements

- v1.3.1

Small improvements

- v1.3

Further clean-up.

- v1.2

Improvements to require less code edits when adding more audio players.

Other fixes and improvements

- v1.1

Small fixes and improvements.

- v 1.0
