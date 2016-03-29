# Swift2 Music Helper

A simple and extendable music helper class.

# Set-Up

- Add the Music.swift file to your project.
- Add your music tracks to your project
- In Music.swift go to the struct URL and change the names to match your music tracks names

# How to use

Check the sample project for a demo.

- To play music call 1 of the userMethods. This will automatically pause (not stop and reset) any previously playing music if playing
```swift
Music.sharedInstance.playMenu()
Music.sharedInstance.playGame()
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
if !Music.sharedInstance.isMuted() {
     // music not muted, show mute button
} else {
    // music is muted, show unmute button
}
```

# How to add more audio players

- To add more audio players  

1) Add the names of the files to the "URL" struct
2) Create more avAudioPlayer properties
3) Add them to the "allPlayers" array
4) Create the "play" methods for them
5) set them up in the "preparePlayers" method.

This should be fairly straight forward and as of v1.2 no further edits to other methods such as pause/resume are required.

# Release notes

- v1.2

Improvements to require less code edits when adding more audio players.
Other fixes and improvements

- v1.1

Small fixes and improvements.

- v 1.0
