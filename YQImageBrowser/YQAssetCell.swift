//
//  YQAssetCell.swift
//  YQImagePicker
//
//  Created by WangYiqiao on 2016/11/14.
//  Copyright © 2016年 wyq. All rights reserved.
//

import UIKit

class YQAssetCell: UICollectionViewCell {
    
    var selectItemClosure: ( (Bool) -> Void )?
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "assets_placeholder_picture"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var checkButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(tappedOnCheckButton), for: .touchUpInside)
        button.setImage(UIImage(named: "photo_check_default"), for: .normal)
        button.setImage(UIImage(named: "photo_check_selected"), for: .highlighted)
        button.setImage(UIImage(named: "photo_check_selected"), for: .selected)
        return button
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.addSubview(checkButton)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        contentView.addSubview(imageView)
        contentView.addSubview(checkButton)
    }
    
    //MARK: - Life Cycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.frame = contentView.bounds
        let buttonWidth = contentView.bounds.width / 4.0
        let padding: CGFloat = 4.0
        checkButton.frame = CGRect(x: contentView.bounds.width - buttonWidth - padding,
                                   y: padding,
                                   width: buttonWidth,
                                   height: buttonWidth)
    }
    
    //MARK: - User Interaction
    
    func tappedOnCheckButton(button: UIButton) {
        button.isSelected = !button.isSelected
        selectItemClosure?(button.isSelected)
        
        if button.isSelected {
            UIView.animate(withDuration: 0.2, animations: {
                    button.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                }) { (_) in
                    UIView.animate(withDuration: 0.2, animations: { 
                        button.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    })
            }
        }
        
    }
}
