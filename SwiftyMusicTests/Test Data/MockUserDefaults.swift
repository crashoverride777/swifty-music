//
//  MockUserDefaults.swift
//  SwiftyMusicTests
//
//  Created by Dominik Ringler on 05/03/2020.
//  Copyright © 2020 Dominik. All rights reserved.
//

import Foundation

final class MockUserDefaults: UserDefaults {
    
    convenience init() {
        self.init(suiteName: "Mock User Defaults")!
    }
    
    override init?(suiteName suitename: String?) {
        UserDefaults().removePersistentDomain(forName: suitename!)
        super.init(suiteName: suitename)
    }
}
