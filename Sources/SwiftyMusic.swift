//    The MIT License (MIT)
//
//    Copyright (c) 2016-2020 Dominik Ringler
//
//    Permission is hereby granted, free of charge, to any person obtaining a copy
//    of this software and associated documentation files (the "Software"), to deal
//    in the Software without restriction, including without limitation the rights
//    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//    copies of the Software, and to permit persons to whom the Software is
//    furnished to do so, subject to the following conditions:
//
//    The above copyright notice and this permission notice shall be included in all
//    copies or substantial portions of the Software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//    SOFTWARE.

import AVFoundation

public protocol SwiftyMusicType: AnyObject {
    func setup(withFileNames fileNames: [SwiftyMusicFileName])
    func play(_ fileName: SwiftyMusicFileName)
    func setVolume(to value: Float)
    func resetVolume()
    func pause()
    func resume()
    func stopAndResetAll()
}

/**
 SwiftyMusic
 
 A concrete singleton class implementation of SwiftyMusicType to play music using AVAudioPlayer.
 */
public class SwiftyMusic: NSObject {
    
    // MARK: - Static Properties
    
    /// Shared instance
    public static let shared = SwiftyMusic()
    
    // MARK: - Properties

    /// Is muted
    public var isMuted: Bool {
        get { return userDefaults.bool(forKey: "SwiftyMusicMuteKey") }
        set {
            userDefaults.set(newValue, forKey: "SwiftyMusicMuteKey")
            players.forEach { $1.volume = newValue ? 0 : currentVolume }
        }
    }
    
    /// Private
    private var currentlyPlaying: SwiftyMusicFileName = .none
    private var currentVolume: Float = 1.0
    private var players = [String: AVAudioPlayer]()
    private var isPaused = false
    private let fileExtensions = ["mp3", "wav", "aac", "ac3", "m4a", "caf"]
    private let userDefaults: UserDefaults
    
    // MARK: - Init
    
    private override convenience init() {
        self.init(userDefaults: .standard)
    }
    
    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }
}

// MARK: - SwiftyMusicType

extension SwiftyMusic: SwiftyMusicType {
    
    // MARK: Setup
    
    /// Setup music players
    ///
    /// Supported file formats: mp3, wav, aac, ac3, m4a, caf
    ///
    /// - parameter fileNames: An array of file names to prepare.
    public func setup(withFileNames fileNames: [SwiftyMusicFileName]) {
        fileNames.forEach {
            guard let player = prepare(withFileName: $0) else { return }
            players[$0.rawValue] = player
        }
    }
    
    // MARK: Play
    
    /// Play music
    ///
    /// - parameter fileName: The player fileName of the music file to play.
    public func play(_ fileName: SwiftyMusicFileName) {
        guard currentlyPlaying != fileName, let avPlayer = players[fileName.rawValue] else { return }
        
        currentlyPlaying = fileName
        
        guard !isPaused else { return }
        
        players.forEach { $1.pause() }
        avPlayer.volume = isMuted ? 0 : currentVolume
        avPlayer.play()
    }
    
    // MARK: Adjust Volume
    
    /// Set volume to a level between 0 and 1
    public func setVolume(to value: Float) {
        guard !isMuted else { return }
        
        currentVolume = value
        players.forEach { $1.volume = value }
    }
    
    /// Reset volume to 1
    public func resetVolume() {
        setVolume(to: 1)
    }
    
    // MARK: Pause / Resume
    
    /// Pause music
    public func pause() {
        isPaused = true
        players.forEach { $1.pause() }
    }
    
    /// Resume music
    public func resume() {
        isPaused = false
        
        players.forEach {
            guard $0 == currentlyPlaying.rawValue && !$1.isPlaying else { return }
            $1.play()
        }
    }
    
    // MARK: Stop
    
    /// Stop and reset all music
    public func stopAndResetAll() {
        currentlyPlaying = .none
        currentVolume = 1
        
        players.forEach {
            $1.stop()
            $1.currentTime = 0
            loadDefaultProperties(forPlayer: $1)
        }
    }
}

// MARK: - AVAudioPlayerDelegate

extension SwiftyMusic: AVAudioPlayerDelegate {
    
    public func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("Audio player \(player) did finish playing \(flag)")
        // Finish means when music ended not when stopped
    }
    
    public func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        if let error = error {
            print(error.localizedDescription)
        }
    }
}

// MARK: - Private Methods

private extension SwiftyMusic {
    
    func prepare(withFileName fileName: SwiftyMusicFileName) -> AVAudioPlayer? {
        var bundleURL: URL?
        
        for fileExtension in fileExtensions {
            guard let url = Bundle.main.url(forResource: fileName.rawValue, withExtension: fileExtension) else { continue }
            bundleURL = url
            break
        }
        
        guard let url = bundleURL else { return nil }
        
        do {
            let avPlayer = try AVAudioPlayer(contentsOf: url)
            avPlayer.delegate = self
            loadDefaultProperties(forPlayer: avPlayer)
            return avPlayer
        }
            
        catch let error {
            print(error)
            return nil
        }
    }
    
    func loadDefaultProperties(forPlayer avPlayer: AVAudioPlayer) {
        avPlayer.volume = isMuted ? 0 : 1
        avPlayer.numberOfLoops = -1
        avPlayer.prepareToPlay()
    }
}
