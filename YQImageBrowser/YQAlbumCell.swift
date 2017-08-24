//
//  AlbumCell.swift
//  YQImageBrowser
//
//  Created by WangYiqiao on 2017/1/19.
//  Copyright © 2017年 wyq. All rights reserved.
//

import UIKit

class YQAlbumCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.imageView?.frame  = CGRect(x: 0.0, y: 0.0, width: 60, height: 60)
    }
    
}
