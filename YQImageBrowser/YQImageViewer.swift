//
//  YQImageViewer.swift
//  YQImageViewer
//
//  Created by stu on 2016/12/18.
//  Copyright © 2016年 wyq. All rights reserved.
//

import UIKit
import Photos

class YQImageViewer: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    private static let cellIdentifier = "YQImageViewerCellIdentifier"
    
    private var oldBarTintColor: UIColor?
    
    let startPage: Int
    
    // views
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.black
        collectionView.register(YQImageViewerCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    private lazy var pageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.white
        label.textAlignment = .center
        return label
    }()
    
    //data
    let imageAssets: [PHAsset]
    
    init(imageAssets: [PHAsset], startPage: Int) {
        self.imageAssets = imageAssets
        
        if startPage < imageAssets.count {
            self.startPage = startPage
        } else {
            self.startPage = 0
        }
        
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init(imageAssets: [PHAsset]) {
        self.init(imageAssets: imageAssets, startPage: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigation()
        
        setupViews()
        
        let indexPath = IndexPath(item: startPage, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        didScrollToPage(startPage + 1)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.barTintColor = self.oldBarTintColor
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
    }
    
    // MARK: - Setup
    
    private func setupNavigation() {
        self.oldBarTintColor = self.navigationController?.navigationBar.barTintColor
        let backgroundImage = generateNavigationBarImage()
        self.navigationController?.navigationBar.setBackgroundImage(backgroundImage, for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.backgroundColor = UIColor.clear
    }
    
    private func setupViews() {
        self.automaticallyAdjustsScrollViewInsets = false
        
        collectionView.frame = CGRect(x: -10, y: 0, width: self.view.bounds.width + 20, height: self.view.bounds.height)
        pageLabel.frame = CGRect(x: 0, y: self.view.bounds.height - 44, width: self.view.bounds.width, height: 21)
        
        didScrollToPage(1)
        
        self.view.addSubview(collectionView)
        self.view.addSubview(pageLabel)
    }
    
    // MARK: - Private
    
    private func generateNavigationBarImage() -> UIImage {
        let navigationBarSize = self.navigationController!.navigationBar.frame.size
        let statusBarSize = UIApplication.shared.statusBarFrame.size
        let imageSize = CGSize(width: statusBarSize.width, height: statusBarSize.height + navigationBarSize.height)
        let color = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
        
        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0.0)
        color.set()
        UIRectFill(CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    private func didScrollToPage(_ page: Int) {
        pageLabel.text = "\(page)/\(imageAssets.count)"
    }

    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: YQImageViewer.cellIdentifier, for: indexPath) as! YQImageViewerCell
        
        let imageAsset = imageAssets[indexPath.row]
        PHImageManager.default().requestImageData(for: imageAsset, options: nil) { (data, _, _, _) in
            if let data = data, let image = UIImage(data: data) {
                cell.displayImage(image)
            }
        }
        
        cell.singleTapAction = {
            if let hidden = self.navigationController?.navigationBar.isHidden {
                self.navigationController?.setNavigationBarHidden(!hidden, animated: true)
                UIApplication.shared.statusBarStyle = hidden ? .lightContent : .default
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageAssets.count
    }

    
    // NARK: - UICollectionViewDelegate
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x >= 0 {
            let page = scrollView.contentOffset.x / collectionView.bounds.width
            didScrollToPage(Int(page) + 1)
        }
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.view.bounds.size.width + 20, height: self.view.bounds.size.height)
    }
    
}





