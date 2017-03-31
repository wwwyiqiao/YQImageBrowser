//
//  ViewController.swift
//  YQImageBrowser
//
//  Created by WangYiqiao on 2017/1/11.
//  Copyright © 2017年 wyq. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func tappedOnButton() {
        let imageBrowser = YQImageBrowser()
        let naviVC = UINavigationController(rootViewController: imageBrowser)
        self.show(naviVC, sender: nil)
    }
}

