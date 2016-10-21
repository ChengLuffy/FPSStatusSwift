//
//  ViewController.swift
//  FPSStatusSwift
//
//  Created by 成璐飞 on 16/7/30.
//  Copyright © 2016年 成璐飞. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let fps = FPSStatus.sharedInstance
        fps.open { (fpsValue) in
            print(fpsValue)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func btnDidClicked(_ sender: AnyObject) {
        
        FPSStatus.sharedInstance.close()
        
    }

}

