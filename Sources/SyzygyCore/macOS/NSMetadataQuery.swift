//
//  NSMetadataQuery.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation

public extension NSMetadataQuery {
    
    convenience init(localSearch: NSPredicate?) {
        self.init()
        self.predicate = localSearch
        self.searchScopes = [NSMetadataQueryIndexedLocalComputerScope]
        self.operationQueue = .main
    }
    
}
