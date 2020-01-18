//
//  Font.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 8/26/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

#if BUILDING_FOR_DESKTOP
public typealias PlatformFont = NSFont
#else
public typealias PlatformFont = UIFont
#endif

public extension PlatformFont {
    
    func bolded() -> PlatformFont {
        var descriptor = self.fontDescriptor
        #if BUILDING_FOR_DESKTOP
        descriptor = descriptor.withSymbolicTraits([.bold])
        return PlatformFont(descriptor: descriptor, size: pointSize) ?? self
        #else
        descriptor = descriptor.withSymbolicTraits(.traitBold) ?? descriptor
        return PlatformFont(descriptor: descriptor, size: pointSize)
        #endif
    }
    
}
