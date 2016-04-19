# Swift2 Music Helper

A simple and extendable music helper class.

# Set-Up

- Add the Music.swift file to your project.
- Add your music tracks to your project
- In Music.swift go to the struct URL and change the names to match your music tracks names

# How to use

Check the sample project for a demo.

It best to init the helper as soon as your app launches to make sure the correct mute settings are used.

In your GameViewController or your 1st SKScene thats presented call

```swift
Music.sharedInstance
```

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
if !Music.sharedInstance.isMuted {
     // music not muted, show mute button
} else {
    // music is muted, show unmute button
}
```

# How to add more audio players

- To add more audio players  

1) Add the names of the files to the "URL" struct

2) Create more avAudioPlayer properties

3) Prepare them in the init method

4) Add them to the "allPlayers" array

5) Create the "play" methods for them

This should be fairly straight forward and as of v1.2 no further edits to other methods such as pause/resume are required.

NOTE: 

By default this helper expects the music files to be mp3s. If you some or all of your files are in different format you have to either edit the preparePlayerMethod or create another one with the correct format extension.

# Release notes

- v1.3

Further clean-up.

- v1.2

Improvements to require less code edits when adding more audio players.

Other fixes and improvements

- v1.1

Small fixes and improvements.

- v 1.0
