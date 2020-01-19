//
//  NSStackView.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 1/18/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

#if BUILDING_FOR_MAC

public extension NSStackView {
    
    private var gravitys: Array<NSStackView.Gravity> {
        switch orientation {
            case .horizontal: return [.leading, .center, .trailing]
            case .vertical: return [.top, .center, .bottom]
            @unknown default: return []
        }
    }
    
    func insertView(_ aView: NSView, afterView: NSView?) {
        guard let after = afterView else { return }
        
        let areas = gravitys
        for area in areas {
            
            let views = self.views(in: area)
            if let index = views.firstIndex(of: after) {
                insertView(aView, at: views.index(after: index), in: area)
                return
            }
            
        }
        
    }
    
    func insertView(_ aView: NSView, beforeView: NSView?) {
        guard let before = beforeView else { return }
        
        let areas = gravitys
        for area in areas {
            
            let views = self.views(in: area)
            if let index = views.firstIndex(of: before) {
                insertView(aView, at: index, in: area)
                return
            }
            
        }
        
    }
    
    func addArrangedSubview(_ subview: NSView?, animated: Bool) {
        guard let view = subview else { return }
        guard animated == true else {
            addArrangedSubview(view)
            return
        }
        animate({
            addArrangedSubview(view)
        })
    }
    
    func removeArrangedSubview(_ subview: NSView?, animated: Bool) {
        guard let view = subview else { return }
        guard animated == true else {
            removeArrangedSubview(view)
            return
        }
        animate({
            view.layer?.opacity = 0
            removeArrangedSubview(view)
        }, completion: {
            view.removeFromSuperview()
            view.layer?.opacity = 1
        })
    }
    
    private func animate(_ block: () -> Void, completion: (() -> Void)? = nil) {
        NSAnimationContext.runAnimationGroup({ ctx in
            ctx.duration = 0.3
            ctx.allowsImplicitAnimation = true
            block()
            window?.layoutIfNeeded()
        }, completionHandler: completion)
    }
    
}

#endif
