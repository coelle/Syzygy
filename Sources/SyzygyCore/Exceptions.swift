//
//  Exceptions.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation

public func catchException(_ block: () -> Void) throws {
    try ObjectiveC.catchException {
        block()
    }
}
