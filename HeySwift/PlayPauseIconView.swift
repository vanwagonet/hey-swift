//
//  PlayPauseIconView.swift
//  HeySwift
//
//  Created by Andy VanWagoner on 6/16/14.
//  Copyright (c) 2014 Andy VanWagoner. All rights reserved.
//

import UIKit

class PlayPauseIconView: UIView {
    
    var isPlaying = false
    var isWaiting = false
    
    
    func showPlayIcon() {
        isPlaying = false
        isWaiting = false
        setNeedsDisplay()
    }
    
    
    func showPauseIcon() {
        isPlaying = true
        isWaiting = false
        setNeedsDisplay()
    }
    
    
    func showWaitingIcon() {
        isPlaying = true
        isWaiting = true
        setNeedsDisplay()
    }


    override func drawRect(rect: CGRect) {
        // Drawing code
        
        if isPlaying {
            drawPausePathTo(UIGraphicsGetCurrentContext(), boundedBy: rect)
        } else {
            drawPlayPathTo(UIGraphicsGetCurrentContext(), boundedBy: rect)
        }
    }
    
    
    func drawPlayPathTo(context: CGContextRef, boundedBy rect: CGRect) {
        CGContextSetFillColorWithColor(context, UIColor.blackColor().CGColor)
        
        CGContextMoveToPoint(context, rect.width / 4, rect.height / 4)
        CGContextAddLineToPoint(context, rect.width * 3 / 4, rect.height / 2)
        CGContextAddLineToPoint(context, rect.width / 4, rect.height * 3 / 4)
        CGContextAddLineToPoint(context, rect.width / 4, rect.height / 4)
        
        CGContextFillPath(context)
    }
    
    
    func drawPausePathTo(context: CGContextRef, boundedBy rect: CGRect) {
        if isWaiting {
            CGContextTranslateCTM(context, rect.width / 4, rect.height / 4)
            CGContextScaleCTM(context, 0.5, 0.5)
        }
        
        CGContextSetFillColorWithColor(context, UIColor.blackColor().CGColor)
        
        CGContextMoveToPoint(context, rect.width / 4, rect.height / 4)
        CGContextAddLineToPoint(context, rect.width / 4, rect.height * 3 / 4)
        CGContextAddLineToPoint(context, rect.width * 2 / 5, rect.height * 3 / 4)
        CGContextAddLineToPoint(context, rect.width * 2 / 5, rect.height / 4)
        CGContextAddLineToPoint(context, rect.width / 4, rect.height / 4)
        
        CGContextFillPath(context)
        
        CGContextMoveToPoint(context, rect.width * 3 / 4, rect.height / 4)
        CGContextAddLineToPoint(context, rect.width * 3 / 4, rect.height * 3 / 4)
        CGContextAddLineToPoint(context, rect.width * 3 / 5, rect.height * 3 / 4)
        CGContextAddLineToPoint(context, rect.width * 3 / 5, rect.height / 4)
        CGContextAddLineToPoint(context, rect.width * 3 / 4, rect.height / 4)
        
        CGContextFillPath(context)
    }
}
