//
//  Decimal.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 11/9/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

public extension Decimal {
    
    static func +(lhs: Decimal, rhs: Int) -> Decimal {
        return lhs + Decimal(rhs)
    }
    
    static func -(lhs: Decimal, rhs: Int) -> Decimal {
        return lhs - Decimal(rhs)
    }
    
    static func *(lhs: Decimal, rhs: Int) -> Decimal {
        return lhs * Decimal(rhs)
    }
    
    static func /(lhs: Decimal, rhs: Int) -> Decimal {
        return lhs / Decimal(rhs)
    }
    
    static func += (lhs: inout Decimal, rhs: Int) {
        lhs += Decimal(rhs)
    }
    
    static func -= (lhs: inout Decimal, rhs: Int) {
        lhs -= Decimal(rhs)
    }
    
    static func *= (lhs: inout Decimal, rhs: Int) {
        lhs *= Decimal(rhs)
    }
    
    static func /= (lhs: inout Decimal, rhs: Int) {
        lhs /= Decimal(rhs)
    }
    
}
