//
//  BezierPath~macos.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 7/6/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

public typealias BezierPath = NSBezierPath

public extension BezierPath {
    
    var CGPath: CGPath {
        let p = CGMutablePath()
        
        let count = self.elementCount
        var didClose = false
        for i in 0 ..< count {
            
            var points = Array<NSPoint>(repeating: .zero, count: 3)
            let e = self.element(at: i, associatedPoints: &points)
            
            switch e {
                case .moveTo:
                    p.move(to: points[0])
                
                case .lineTo:
                    p.addLine(to: points[0])
                    didClose = false
                case .curveTo:
                    p.addCurve(to: points[2], control1: points[0], control2: points[1])
                    didClose = false
                case .closePath:
                    p.closeSubpath()
                    didClose = true
                @unknown default:
                    NSLog("Unknown type of path element: \(e). Skipping...")
            }
        }
        
        if didClose == false {
            p.closeSubpath()
        }
        
        return p
    }
    
    convenience init(roundedRect: NSRect, cornerRadius: CGFloat) {
        self.init(roundedRect: roundedRect, xRadius: cornerRadius, yRadius: cornerRadius)
    }
    
    func apply(_ transform: CGAffineTransform) {
        self.transform(using: AffineTransform(transform))
    }
    
    func addCurve(to: CGPoint, controlPoint1: CGPoint, controlPoint2: CGPoint) {
        self.relativeCurve(to: to, controlPoint1: controlPoint1, controlPoint2: controlPoint2)
    }
    
    func addLine(to point: CGPoint) {
        self.line(to: point)
    }
    
}
