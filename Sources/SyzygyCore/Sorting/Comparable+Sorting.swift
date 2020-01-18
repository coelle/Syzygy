//
//  Comparable+Sorting.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 7/24/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

public extension Comparable {
    
    static func ascending() -> AnySorter<Self> {
        return AnySorter(sorter: <)
    }
    
    static func descending() -> AnySorter<Self> {
        return AnySorter(sorter: >)
    }
    
}
