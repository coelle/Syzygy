//
//  TargetAction~ios.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 7/22/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import UIKit

extension UIBarButtonItem: TargetActionProtocol { }

public extension UIBarButtonItem {
    
    convenience init(image: UIImage?, style: UIBarButtonItem.Style) {
        self.init(image: image, style: style, target: nil, action: nil)
    }
    
    convenience init(image: UIImage?, landscapeImagePhone: UIImage?, style: UIBarButtonItem.Style) {
        self.init(image: image, landscapeImagePhone: landscapeImagePhone, style: style, target: nil, action: nil)
    }
    
    convenience init(title: String?, style: UIBarButtonItem.Style) {
        self.init(title: title, style: style, target: nil, action: nil)
    }
    
    convenience init(barButtonSystemItem systemItem: UIBarButtonItem.SystemItem) {
        self.init(barButtonSystemItem: systemItem, target: nil, action: nil)
    }
    
    convenience init(image: UIImage?, style: UIBarButtonItem.Style, actionBlock: @escaping (UIBarButtonItem) -> Void) {
        self.init(image: image, style: style, target: nil, action: nil)
        self.actionBlock = actionBlock
    }
    
    convenience init(image: UIImage?, landscapeImagePhone: UIImage?, style: UIBarButtonItem.Style, actionBlock: @escaping (UIBarButtonItem) -> Void) {
        self.init(image: image, landscapeImagePhone: landscapeImagePhone, style: style, target: nil, action: nil)
        self.actionBlock = actionBlock
    }
    
    convenience init(title: String?, style: UIBarButtonItem.Style, actionBlock: @escaping (UIBarButtonItem) -> Void) {
        self.init(title: title, style: style, target: nil, action: nil)
        self.actionBlock = actionBlock
    }
    
    convenience init(barButtonSystemItem systemItem: UIBarButtonItem.SystemItem, actionBlock: @escaping (UIBarButtonItem) -> Void) {
        self.init(barButtonSystemItem: systemItem, target: nil, action: nil)
        self.actionBlock = actionBlock
    }
    
}


private var ButtonActionsAssociatedObjectKey: UInt8 = 0

public extension UIButton {
    
    func addAction(_ action: Action) {
        let target = ButtonActionHelper(action: action)
        self.addTarget(target, action: #selector(ButtonActionHelper.actionMethod(_:)), for: .touchUpInside)
        
        var helpers: Array<ButtonActionHelper> = associatedObject(for: &ButtonActionsAssociatedObjectKey) ?? []
        helpers.append(target)
        setAssociatedObject(helpers, forKey: &ButtonActionsAssociatedObjectKey)
    }
    
}



internal class ButtonActionHelper: NSObject {
    internal let action: Action
    
    init(action: Action) {
        self.action = action
        super.init()
    }
    
    @objc func actionMethod(_ sender: Any) {
        action.handler(sender)
    }
}
