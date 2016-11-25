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
        
        let app = UIApplication.shared
        let subviews = ((app.value(forKey: "statusBar") as! UIView).value(forKey: "foregroundView") as! UIView).subviews
        
        var timeLabelFrame = CGRect()
        for subview in subviews {
            if subview.isKind(of: NSClassFromString("UIStatusBarTimeItemView")!) {
                timeLabelFrame = subview.frame
                break
            }
            
        }
        
//        fpsLabel = UILabel(frame: CGRect(x: (UIScreen.main.bounds.size.width - 50) / 2 + 50, y: 0, width: 50, height: 20))
        fpsLabel = UILabel(frame: CGRect(x: timeLabelFrame.origin.x+timeLabelFrame.size.width+5, y: 0, width: 20, height: 20))
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
        let app = UIApplication.shared
        let statusView = (app.value(forKey: "statusBar") as! UIView).value(forKey: "foregroundView") as! UIView
        statusView.addSubview(fpsLabel!)
        displayLink?.isPaused = false
        print("have opened")
        
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
