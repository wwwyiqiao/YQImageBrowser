//
//  YQBadgeButton.swift
//  YQImagePicker
//
//  Created by WangYiqiao on 2016/11/14.
//  Copyright © 2016年 wyq. All rights reserved.
//

import UIKit

class YQBadgeButton: UIView {
    
    //views
    private lazy var titleButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("确定", for: .normal)
        button.setTitleColor(UIColor.init(red: 31/255, green: 184/255, blue: 35/255, alpha: 1.0), for: .normal)
        button.setTitleColor(UIColor.init(red: 201/255, green: 239/255, blue: 202/255, alpha: 1.0), for: .highlighted)
        button.setTitleColor(UIColor.init(red: 201/255, green: 239/255, blue: 203/255, alpha: 1.0), for: .disabled)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.contentEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0)
        button.backgroundColor = UIColor.clear
        button.isEnabled = false
        
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.backgroundColor = UIColor.clear
        label.isHidden = true
        
        return label
    }()
    
    private lazy var circleView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 31/255, green: 184/255, blue: 35/255, alpha: 1.0)
        view.clipsToBounds = true
        view.isHidden = true
        return view
    }()
    
    //properties
    var badgeValue: Int = 0 {
        didSet{
            if badgeValue <= 0 {
                titleLabel.isHidden = true
                circleView.isHidden = true
                titleButton.isEnabled = false
            } else {
                titleLabel.isHidden = false
                circleView.isHidden = false
                titleButton.isEnabled = true
                titleLabel.text = "\(badgeValue)"
                
                circleView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                UIView.animate(withDuration: 0.2, animations: { 
                        self.circleView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                    }, completion: { (_) in
                        self.circleView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                })
            }
        }
    }
    
    //MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(titleButton)
        self.addSubview(circleView)
        self.addSubview(titleLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.addSubview(titleButton)
        self.addSubview(circleView)
        self.addSubview(titleLabel)
    }
    
    //MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleButton.frame = self.bounds
        let centerY = self.bounds.height * 0.5
        titleLabel.frame = CGRect(x: 0, y: centerY - 10, width: 20, height: 20)
        circleView.frame = CGRect(x: 0, y: centerY - 10, width: 20, height: 20)
        circleView.layer.cornerRadius = 10.0
    }

    //MARK: - public
    
    func addTarget(target: AnyObject?, action: Selector) {
        self.titleButton.addTarget(target, action: action, for: .touchUpInside)
    }
  
}
