//
//  FPSStatus.swift
//  FPSStatusSwift
//
//  Created by 成璐飞 on 16/7/30.
//  Copyright © 2016年 成璐飞. All rights reserved.
//

import UIKit

class FPSStatus: NSObject {
    static let sharedInstance = FPSStatus()
    var fpsLabel: UILabel?
    private var displayLink: CADisplayLink?
    private var lastTime: NSTimeInterval = 0
    private var count: NSInteger = 0
    private var handler: ((NSInteger) -> ())?
    
    private override init() {
        super.init()
        NSNotificationCenter.defaultCenter().addObserverForName(UIApplicationDidBecomeActiveNotification, object: nil, queue: nil) { (_) in
            self.displayLink?.paused = false
        }
        
        NSNotificationCenter.defaultCenter().addObserverForName(UIApplicationWillResignActiveNotification, object: self, queue: nil) { (_) in
            self.displayLink?.paused = true
        }
        
        displayLink = CADisplayLink(target: self, selector: #selector(self.displayLinkTick(_:)))
        displayLink?.paused = true
        displayLink?.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSRunLoopCommonModes)
        
        
        fpsLabel = UILabel(frame: CGRect(x: (UIScreen.mainScreen().bounds.size.width - 50) / 2 + 50, y: 0, width: 50, height: 20))
        fpsLabel?.font = UIFont.boldSystemFontOfSize(12)
        fpsLabel?.textColor = UIColor(red: 0.33, green: 0.84, blue: 0.43, alpha: 1.00)
        fpsLabel?.backgroundColor = UIColor.clearColor()
        fpsLabel?.textAlignment = .Center
        
    }
    
    @objc private func displayLinkTick(displayLink: CADisplayLink) {
        if lastTime == 0 {
            lastTime = displayLink.timestamp
        } else if displayLink.timestamp - lastTime > 1.00 {
            fpsLabel?.text = "\(count)"
            lastTime = displayLink.timestamp
            if handler != nil {
                handler!(count)
            }
            count = 0
        } else {
            count += 1
        }
    }
    
    func open() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let window = appDelegate.window
        if window?.rootViewController?.isKindOfClass(UIViewController.self) == true {
            for subView in (window?.rootViewController?.view.subviews)! {
                if subView == fpsLabel {
                    print("have opened")
                    return
                }
            }
            
            displayLink?.paused = false
            window?.rootViewController?.view.addSubview(fpsLabel!)
            window?.rootViewController?.view.bringSubviewToFront(fpsLabel!)
            
        } else {
            for subView in window!.subviews {
                if subView == fpsLabel {
                    print("have opened")
                    return
                }
            }
            
            displayLink?.paused = false
            window!.addSubview(fpsLabel!)
            window!.bringSubviewToFront(fpsLabel!)
        }
        
    }
    
    func close() {
        displayLink?.paused = true
        handler = nil
        fpsLabel?.removeFromSuperview()
    }
    
    func open(handler: ((fpsValue: NSInteger) -> ())?) {
        self.handler = handler
        open()
    }
    
    deinit {
        displayLink?.paused = true
        displayLink?.removeFromRunLoop(NSRunLoop.currentRunLoop(), forMode: NSRunLoopCommonModes)
    }
    
}
