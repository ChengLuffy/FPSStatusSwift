//
//  FPSStatus.swift
//  FPSStatusSwift
//
//  Created by 成璐飞 on 16/7/30.
//  Copyright © 2016年 成璐飞. All rights reserved.
//

import UIKit

public class FPSStatus: NSObject {
    public static let sharedInstance = FPSStatus()
    var fpsLabel: UILabel?
    fileprivate var displayLink: CADisplayLink?
    fileprivate var lastTime: TimeInterval = 0
    fileprivate var count: NSInteger = 0
    fileprivate var handler: ((NSInteger) -> ())?
    
    fileprivate override init() {
        super.init()
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIApplicationDidBecomeActive, object: nil, queue: nil) { (_) in
            self.displayLink?.isPaused = false
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIApplicationWillResignActive, object: self, queue: nil) { (_) in
            self.displayLink?.isPaused = true
        }
        
        displayLink = CADisplayLink(target: self, selector: #selector(self.displayLinkTick(_:)))
        displayLink?.isPaused = true
        displayLink?.add(to: RunLoop.current, forMode: RunLoopMode.commonModes)
        
        
        fpsLabel = UILabel(frame: CGRect(x: (UIScreen.main.bounds.size.width - 50) / 2 + 50, y: 0, width: 50, height: 20))
        fpsLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        fpsLabel?.textColor = UIColor(red: 0.33, green: 0.84, blue: 0.43, alpha: 1.00)
        fpsLabel?.backgroundColor = UIColor.clear
        fpsLabel?.textAlignment = .center
        
    }
    
    @objc fileprivate func displayLinkTick(_ displayLink: CADisplayLink) {
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
    
    public func open() {
        let appDelegate = UIApplication.shared.delegate
        let window = appDelegate!.window
        if window!!.rootViewController?.isKind(of: UIViewController.self) == true {
            for subView in (window?!.rootViewController?.view.subviews)! {
                if subView == fpsLabel {
                    print("have opened")
                    return
                }
            }
            
            displayLink?.isPaused = false
            window?!.rootViewController?.view.addSubview(fpsLabel!)
            window?!.rootViewController?.view.bringSubview(toFront: fpsLabel!)
            
        } else {
            for subView in window!!.subviews {
                if subView == fpsLabel {
                    print("have opened")
                    return
                }
            }
            
            displayLink?.isPaused = false
            window!!.addSubview(fpsLabel!)
            window!!.bringSubview(toFront: fpsLabel!)
        }
        
    }
    
    public func close() {
        displayLink?.isPaused = true
        handler = nil
        fpsLabel?.removeFromSuperview()
    }
    
    public func open(_ handler: ((_ fpsValue: NSInteger) -> ())?) {
        self.handler = handler
        open()
    }
    
    deinit {
        displayLink?.isPaused = true
        displayLink?.remove(from: RunLoop.current, forMode: RunLoopMode.commonModes)
    }
    
}
