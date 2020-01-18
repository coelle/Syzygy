//
//  NSPredicate+Predicate.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 7/26/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

extension NSPredicate: Predicate {
    
    public func contains(_ value: Any) -> Bool {
        var c = false
        try? catchException {
            c = self.evaluate(with: value)
        }
        return c
    }
    
}
