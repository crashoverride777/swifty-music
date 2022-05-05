//    The MIT License (MIT)
//
//    Copyright (c) 2016-2022 Dominik Ringler
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

public struct SwiftyMusicFileName: RawRepresentable, Equatable {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    public init(_ rawValue: String) {
        self.rawValue = rawValue
    }
}

public protocol SwiftyMusicType: AnyObject {
    var isMuted: Bool { get }
    func setup(withFileNames fileNames: [SwiftyMusicFileName])
    func play(_ fileName: SwiftyMusicFileName)
    func setVolume(to value: Float)
    func setMuted(_ isMuted: Bool)
    func pause()
    func resume()
    func reset()
}

/**
 SwiftyMusic
 
 A concrete singleton class implementation of SwiftyMusicType to play music using AVAudioPlayer.
 */
public class SwiftyMusic: NSObject {
    
    // MARK: - Static Properties

    /// The shared SwiftyMusic instance.
    public static let shared = SwiftyMusic()
    
    // MARK: - Properties

    private let playerBuilder: SwiftyMusicPlayerBuilderType
    private var players = Set<AVAudioPlayer>()
    private var currentPlayer: AVAudioPlayer?
    private var currentVolume: Float = 1.0
    private var isPaused = false
    private let userDefaults: UserDefaults
    private let mutedKey = "SwiftyMusicMuteKey"
    
    private var muted: Bool {
        get { userDefaults.bool(forKey: mutedKey) }
        set { userDefaults.set(newValue, forKey: mutedKey) }
    }
    
    // MARK: - Initialization
    
    private override convenience init() {
        self.init(playerBuilder: SwiftyMusicPlayerBuilder(bundle: .main), userDefaults: .standard)
    }
    
    init(playerBuilder: SwiftyMusicPlayerBuilderType, userDefaults: UserDefaults) {
        self.playerBuilder = playerBuilder
        self.userDefaults = userDefaults
    }
}

// MARK: - SwiftyMusicType

extension SwiftyMusic: SwiftyMusicType {
    /// Check muted state (persistant)
    public var isMuted: Bool {
        muted
    }
    
    /// Setup music players
    ///
    /// Supported file formats: mp3, wav, aac, ac3, m4a, caf
    ///
    /// - parameter fileNames: An array of file names to prepare.
    public func setup(withFileNames fileNames: [SwiftyMusicFileName]) {
        fileNames.forEach {
            guard let player = playerBuilder.build(withFileName: $0.rawValue, delegate: self) else { return }
            player.volume = muted ? 0 : 1
            players.insert(player)
        }
    }
    
    /// Play music
    ///
    /// - parameter fileName: The player file name to play.
    public func play(_ fileName: SwiftyMusicFileName) {
        guard !isPaused else { return }
        let player = getPlayer(for: fileName)
        guard !player.isPlaying else { return }
        players.forEach { $0.pause() }
        player.play()
        currentPlayer = player
    }

    /// Pause music
    public func pause() {
        isPaused = true
        players.forEach { $0.pause() }
    }

    /// Resume music
    public func resume() {
        isPaused = false
        currentPlayer?.play()
    }
    
    /// Set volume to a level between 0 and 1
    public func setVolume(to value: Float) {
        guard !muted else { return }
        currentVolume = value
        players.forEach { $0.volume = value }
    }
    
    /// Mute/Unmute music
    public func setMuted(_ isMuted: Bool) {
        self.muted = isMuted
        players.forEach { $0.volume = isMuted ? 0 : currentVolume }
    }
    
    /// Stop and reset all music players to initial settings
    public func reset() {
        currentPlayer = .none
        currentVolume = 1
        players.forEach {
            $0.stop()
            $0.currentTime = 0
            $0.volume = muted ? 0 : 1
            $0.prepareToPlay()
        }
    }
}

// MARK: - AVAudioPlayerDelegate

extension SwiftyMusic: AVAudioPlayerDelegate {
    public func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("SwiftyMusic audio player \(player) did finish playing \(flag)")
        // Finish means when music ended not when stopped
    }
    
    public func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        if let error = error {
            print("SwiftyMusic audio player error:", error.localizedDescription)
        }
    }
}

// MARK: - Private Methods

private extension SwiftyMusic {
    func getPlayer(for fileName: SwiftyMusicFileName) -> AVAudioPlayer {
        guard let player = players.first(where: {
            $0.url?.lastPathComponent.components(separatedBy: ".").first == fileName.rawValue
        }) else {
            fatalError("SwiftyMusic did not find player for fileName \(fileName.rawValue). Call setup method with valid file names.")
        }
        return player
    }
}
