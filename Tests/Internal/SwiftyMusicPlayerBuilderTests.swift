//
//  SwiftyMusicPlayerBuilderTests.swift
//  SwiftyMusicTests
//
//  Created by Dominik Ringler on 05/03/2020.
//  Copyright © 2020 Dominik. All rights reserved.
//

import XCTest
import AVFoundation
@testable import SwiftyMusic

class SwiftyMusicPlayerBuilderTests: XCTestCase {

    // MARK: - Tests
    
    func test_invalidURL_returnsNil() {
        let sut = makeSUT()
        let player = sut.build(withFileName: "invalid", delegate: self)
        XCTAssertNil(player)
    }
    
    func test_validURL_returnsPlayer() {
        let sut = makeSUT()
        let player = sut.build(withFileName: "Sample.mp3", delegate: self)
        XCTAssertNotNil(player)
    }
    
    func test_validURL_setsPlayerDelegate() {
        let sut = makeSUT()
        let player = sut.build(withFileName: "Sample.mp3", delegate: self)
        XCTAssertTrue(player?.delegate is SwiftyMusicPlayerBuilderTests)
    }
    
    func test_validURL_setsCorrectPlayerLoops() {
        let sut = makeSUT()
        let player = sut.build(withFileName: "Sample.mp3", delegate: self)
        XCTAssertEqual(player?.numberOfLoops, -1)
    }
}

// MARK: - AVAudioPlayerDelegate

extension SwiftyMusicPlayerBuilderTests: AVAudioPlayerDelegate {}

// MARK: - Private Methods

private extension SwiftyMusicPlayerBuilderTests {
    
    func makeSUT() -> SwiftyMusicPlayerBuilder {
        SwiftyMusicPlayerBuilder(bundle: .module)
    }
}
