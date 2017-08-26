//
//  ViewController.swift
//  YQImageBrowser
//
//  Created by WangYiqiao on 2017/1/11.
//  Copyright © 2017年 wyq. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController, YQImageBrowserDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func tappedOnButton() {
        let imageBrowser = YQImageBrowser()
        imageBrowser.delegate = self
        let naviVC = UINavigationController(rootViewController: imageBrowser)
        self.present(naviVC, animated: true, completion: nil)
    }
    
    func imageBrowser(_ imageBrowser: YQImageBrowser, didSelectedPhotos photos: [PHAsset]) {
        imageBrowser.dismiss(animated: true, completion: nil)
        
        let requestUrlGroup = DispatchGroup()
        
        DispatchQueue.global().async {
            var imageUrls: [URL] = []
            for asset in photos {
                let options: PHContentEditingInputRequestOptions = PHContentEditingInputRequestOptions()
                options.canHandleAdjustmentData = {(adjustmeta: PHAdjustmentData) -> Bool in
                    return true
                }
                
                requestUrlGroup.enter()
                asset.requestContentEditingInput(with: options, completionHandler: { (input, _) in
                    if let url = input?.fullSizeImageURL {
                        imageUrls.append(url)
                        requestUrlGroup.leave()
                    }
                })
            }
            
            requestUrlGroup.wait()
            DispatchQueue.main.async {
                print(imageUrls)
            }
        }
    }
    
    func imageBroserDidCancel(_ imageBrowser: YQImageBrowser) {
        imageBrowser.dismiss(animated: true, completion: nil)
    }
}

