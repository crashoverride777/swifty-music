//
//  SwiftyMusicTests.swift
//  SwiftyMusicTests
//
//  Created by Dominik Ringler on 05/03/2020.
//  Copyright © 2020 Dominik. All rights reserved.
//

import XCTest
@testable import SwiftyMusic

class SwiftyMusicTests: XCTestCase {

    // MARK: - Properties
    
    private var playerBuilder: MockPlayerBuilder!
    private var userDefaults: MockUserDefaults!
    
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
    
    // MARK: Volume
    
    func test_setVolume_isMuted_doesNothing() {
        
    }
    
    func test_setVolume_isNotMuted_updatesPlayers() {
        
    }
    
    func test_resetVolume() {
        
    }
    
    // MARK: Mute
    
    func test_setMuted_false_updatesUserDefaults() {
        let sut = makeSUT()
        sut.setMuted(false)
        XCTAssertFalse(userDefaults.bool(forKey: "SwiftyMusicMuteKey"))
    }
    
    func test_setMuted_true_updatesUserDefaults() {
        let sut = makeSUT()
        sut.setMuted(false)
        XCTAssertTrue(userDefaults.bool(forKey: "SwiftyMusicMuteKey"))
    }
    
    // MARK: Pause/Resume
    
    func test_pause() {
        
    }
    
    func test_resume() {
        
    }
    
    // MARK: Stop and Reset
    
    func test_stopAndResetAll() {
        
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
