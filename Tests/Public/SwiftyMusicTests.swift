//
//  SwiftyMusicTests.swift
//  SwiftyMusicTests
//
//  Created by Dominik Ringler on 05/03/2020.
//  Copyright © 2020 Dominik. All rights reserved.
//

import XCTest
@testable import SwiftyMusic
import AVFoundation

class SwiftyMusicTests: XCTestCase {

    // MARK: - Properties
    
    private var playerBuilder: MockPlayerBuilder!
    private var userDefaults: MockUserDefaults!
    private let fileName: SwiftyMusicFileName = .init("Sample")

    // MARK: - Life Cycle
    
    override func setUp() {
        super.setUp()
        playerBuilder = MockPlayerBuilder()
        userDefaults = MockUserDefaults()
    }
    
    override func tearDown() {
        playerBuilder = nil
        userDefaults = nil
        super.tearDown()
    }

    // MARK: - Tests

    // MARK: Setup

    func test_setup_isNotMuted_setsCorrectPlayerVolume() {
        let expectedPlayer = MockAVAudioPlayer()
        playerBuilder.stub.build = { _, _ in expectedPlayer }
        userDefaults.set(false, forKey: "SwiftyMusicMuteKey")

        let sut = makeSUT()
        sut.setup(withFileNames: [fileName])

        XCTAssertEqual(expectedPlayer.volume, 1.0)
    }

    func test_setup_isMuted_setsCorrectPlayerVolume() {
        let expectedPlayer = MockAVAudioPlayer()
        playerBuilder.stub.build = { _, _ in expectedPlayer }
        userDefaults.set(true, forKey: "SwiftyMusicMuteKey")

        let sut = makeSUT()
        sut.setup(withFileNames: [fileName])

        XCTAssertEqual(expectedPlayer.volume, 0.0)
    }

    // MARK: Play
    
    func test_play_isPaused_doesNothing() {
        let expectedPlayer = MockAVAudioPlayer()
        playerBuilder.stub.build = { _, _ in expectedPlayer }

        let sut = makeSUT()
        sut.setup(withFileNames: [fileName])
        sut.pause()
        sut.play(fileName)

        XCTAssertFalse(expectedPlayer.mock.playCalled)
    }

    func test_play_isNotPaused_startsPlaying() {
        let expectedPlayer = MockAVAudioPlayer()
        playerBuilder.stub.build = { _, _ in expectedPlayer }

        let sut = makeSUT()
        sut.setup(withFileNames: [fileName])
        sut.play(fileName)

        XCTAssertTrue(expectedPlayer.mock.playCalled)
    }

    // MARK: Pause

    func test_pause_pausesPlayer() {
        let expectedPlayer = MockAVAudioPlayer()
        playerBuilder.stub.build = { _, _ in expectedPlayer }

        let sut = makeSUT()
        sut.setup(withFileNames: [fileName])
        sut.pause()

        XCTAssertTrue(expectedPlayer.mock.pauseCalled)
    }

    // MARK: Resume

    func test_resume_hasNoCurrentPlayer_doesNotStartPlaying() {
        let expectedPlayer = MockAVAudioPlayer()
        playerBuilder.stub.build = { _, _ in expectedPlayer }

        let sut = makeSUT()
        sut.setup(withFileNames: [fileName])
        sut.resume()

        XCTAssertFalse(expectedPlayer.mock.playCalled)
    }

    func test_resume_hasCurrentPlayer_startsPlaying() {
        let expectedPlayer = MockAVAudioPlayer()
        playerBuilder.stub.build = { _, _ in expectedPlayer }

        let sut = makeSUT()
        sut.setup(withFileNames: [fileName])
        sut.play(fileName)
        sut.resume()

        XCTAssertTrue(expectedPlayer.mock.playCalled)
    }
    
    // MARK: Volume
    
    func test_setVolume_isMuted_doesNothing() {
        let expectedPlayer = MockAVAudioPlayer()
        playerBuilder.stub.build = { _, _ in expectedPlayer }

        let sut = makeSUT()
        sut.setup(withFileNames: [fileName])
        userDefaults.set(true, forKey: "SwiftyMusicMuteKey")
        sut.setVolume(to: 0.5)

        XCTAssertEqual(expectedPlayer.volume, 1.0)
    }
    
    func test_setVolume_isNotMuted_updatesVolume() {
        let expectedPlayer = MockAVAudioPlayer()
        playerBuilder.stub.build = { _, _ in expectedPlayer }

        let sut = makeSUT()
        sut.setup(withFileNames: [fileName])
        userDefaults.set(false, forKey: "SwiftyMusicMuteKey")
        sut.setVolume(to: 0.5)

        XCTAssertEqual(expectedPlayer.volume, 0.5)
    }
    
    // MARK: Mute

    func test_setMuted_false_updatesPlayer() {
        let expectedPlayer = MockAVAudioPlayer()
        playerBuilder.stub.build = { _, _ in expectedPlayer }

        let sut = makeSUT()
        sut.setup(withFileNames: [fileName])
        sut.setVolume(to: 0.5)
        sut.setMuted(false)

        XCTAssertEqual(expectedPlayer.volume, 0.5)
    }

    func test_setMuted_false_updatesUserDefaults() {
        let sut = makeSUT()
        sut.setMuted(false)

        XCTAssertFalse(userDefaults.bool(forKey: "SwiftyMusicMuteKey"))
    }

    func test_setMuted_true_updatesPlayer() {
        let expectedPlayer = MockAVAudioPlayer()
        playerBuilder.stub.build = { _, _ in expectedPlayer }

        let sut = makeSUT()
        sut.setup(withFileNames: [fileName])
        sut.setVolume(to: 0.5)
        sut.setMuted(true)

        XCTAssertEqual(expectedPlayer.volume, 0.0)
    }
    
    func test_setMuted_true_updatesUserDefaults() {
        let sut = makeSUT()
        sut.setMuted(true)
        
        XCTAssertTrue(userDefaults.bool(forKey: "SwiftyMusicMuteKey"))
    }
    
    // MARK: Reset

    func test_reset_stopsPlaying() {
        let expectedPlayer = MockAVAudioPlayer()
        playerBuilder.stub.build = { _, _ in expectedPlayer }

        let sut = makeSUT()
        sut.setup(withFileNames: [fileName])
        sut.reset()

        XCTAssertTrue(expectedPlayer.mock.stopCalled)
    }

    func test_reset_resetsCurrentTime() {
        let expectedPlayer = MockAVAudioPlayer()
        playerBuilder.stub.build = { _, _ in expectedPlayer }

        let sut = makeSUT()
        sut.setup(withFileNames: [fileName])
        sut.reset()

        XCTAssertEqual(expectedPlayer.currentTime, 0.0)
    }

    func test_reset_isNotMuted_updatesVolume() {
        let expectedPlayer = MockAVAudioPlayer()
        playerBuilder.stub.build = { _, _ in expectedPlayer }

        let sut = makeSUT()
        sut.setup(withFileNames: [fileName])
        userDefaults.set(false, forKey: "SwiftyMusicMuteKey")
        sut.reset()

        XCTAssertEqual(expectedPlayer.volume, 1.0)
    }

    func test_reset_isMuted_updatesVolume() {
        let expectedPlayer = MockAVAudioPlayer()
        playerBuilder.stub.build = { _, _ in expectedPlayer }

        let sut = makeSUT()
        sut.setup(withFileNames: [fileName])
        userDefaults.set(true, forKey: "SwiftyMusicMuteKey")
        sut.reset()

        XCTAssertEqual(expectedPlayer.volume, 0.0)
    }

    func test_reset_preparesPlayerToPlay() {
        let expectedPlayer = MockAVAudioPlayer()
        playerBuilder.stub.build = { _, _ in expectedPlayer }

        let sut = makeSUT()
        sut.setup(withFileNames: [fileName])
        sut.reset()

        XCTAssertTrue(expectedPlayer.mock.prepareToPlayCalled)
    }
}

// MARK: - Private Methods

private extension SwiftyMusicTests {
    
    func makeSUT() -> SwiftyMusic {
        SwiftyMusic(
            playerBuilder: playerBuilder,
            userDefaults: userDefaults
        )
    }
}
