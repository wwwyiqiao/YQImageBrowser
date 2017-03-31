//
//  YQAlbum.swift
//  YQImagePicker
//
//  Created by WangYiqiao on 2016/11/11.
//  Copyright © 2016年 wyq. All rights reserved.
//

import Foundation
import Photos

class YQAlbum {

    let count: Int
    let results: PHFetchResult<PHAsset>
    let name: String?
    let startDate: NSDate?
    let identifier: String?
    
    init(results: PHFetchResult<PHAsset>, name: String?, startDate: NSDate?, identifier: String?){
        self.count = results.count
        self.results = results
        self.name = name
        self.startDate = startDate
        self.identifier = identifier
    }
}
