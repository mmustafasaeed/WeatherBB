//
//  UIView+Frame.swift
//  WeatherBB
//
//  Created by Mustafa Saeed on 8/4/17.
//  Copyright © 2017 Mustafa Saeed. All rights reserved.
//

import Foundation
import UIKit

public extension UIView {
    
    public var width: CGFloat {
        
        set { self.frame.size.width = newValue }
        get { return self.frame.width }
    }
    
    public var height: CGFloat {
        
        set { self.frame.size.height = newValue }
        get { return self.frame.height }
    }
    
    public var size: CGSize {
        
        set { self.frame.size = newValue }
        get { return self.frame.size }
    }
    
    public var origin: CGPoint {
        
        set { self.frame.origin = newValue }
        get { return self.frame.origin }
    }
    
    public var x: CGFloat {
        
        set { self.frame.origin = CGPoint(x: newValue, y: self.frame.origin.y) }
        get { return self.frame.origin.x }
    }
    
    public var y: CGFloat {
        
        set { self.frame.origin = CGPoint(x: self.frame.origin.x, y: newValue) }
        get { return self.frame.origin.y }
    }
    
    public var centerX: CGFloat {
        
        set { self.center = CGPoint(x: newValue, y: self.center.y) }
        get { return self.center.x }
    }
    
    public var centerY: CGFloat {
        
        set { self.center = CGPoint(x: self.center.x, y: newValue) }
        get { return self.center.y }
    }
    
    public var left: CGFloat {
        
        set { self.frame.origin.x = newValue }
        get { return self.frame.minX }
    }
    
    public var right: CGFloat {
        
        set { self.frame.origin.x = newValue - self.frame.size.width }
        get { return self.frame.maxX }
    }
    
    public var top: CGFloat {
        
        set { self.frame.origin.y = newValue }
        get { return self.frame.minY }
    }
    
    public var bottom: CGFloat {
        
        set { self.frame.origin.y = newValue - self.frame.size.height }
        get { return self.frame.maxY }
    }
    
    public func centerInSuperView() {
        
        if superview != nil {
            origin = (CGPoint(x: rint(superview!.width - width) / 2, y: rint(superview!.height - height) / 2))
        }
    }
    
    public func centerHorizontallyInSuperView () {
        
        if superview != nil {
            origin = (CGPoint(x: rint(superview!.width - width) / 2, y: self.y))
        }
    }
    
    public func centerVerticallyInSuperView () {
        
        if superview != nil {
            origin = (CGPoint(x: self.x, y: (superview!.height - self.height) / 2.0))
        }
    }
    
}
