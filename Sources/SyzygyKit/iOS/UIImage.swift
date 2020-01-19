//
//  UIImage.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 8/1/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

#if BUILDING_FOR_MOBILE

public typealias PlatformImage = UIImage

extension UIImage: BundleResourceLoadable {
    public static func loadResource(name: String, in bundle: Bundle?) -> UIImage? {
        let i = UIImage(named: name)
        return i?.withRenderingMode(.alwaysTemplate)
    }
}

#endif
