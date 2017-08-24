//
//  YQPhotoListViewController.swift
//  YQImageBrowser
//
//  Created by WangYiqiao on 2017/1/11.
//  Copyright © 2017年 wyq. All rights reserved.
//

import UIKit
import Photos

class YQPhotoListViewController: UIViewController {
    
    fileprivate struct CollectionViewConfig {
        static let cellIdentifier = "CellIdentifier"
        static let kThumbSizeLength: CGFloat = (UIScreen.main.bounds.width - 10) / 4.0
        static let minimumSpacing: CGFloat = 2.0
    }
    
    //data
    let currentAlbum: YQAlbum
    var assetsArray: [PHAsset]
    var selectedIndexes: Set<Int> {
        didSet {
            self.previewButtonItem.isEnabled = selectedIndexes.count > 0
            self.badgeButton.badgeValue = selectedIndexes.count
        }
    }
    

    //views
    lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = CollectionViewConfig.minimumSpacing
        flowLayout.minimumInteritemSpacing = CollectionViewConfig.minimumSpacing
        flowLayout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: UIScreen.main.bounds, collectionViewLayout: flowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.alwaysBounceVertical = true
        collectionView.showsHorizontalScrollIndicator = true
        collectionView.backgroundColor = UIColor.white
        collectionView.register(YQAssetCell.self, forCellWithReuseIdentifier: CollectionViewConfig.cellIdentifier)
        return collectionView
    }()
    
    lazy var badgeButton: YQBadgeButton = {
        let button = YQBadgeButton(frame: CGRect(x: 0, y: 0, width: 56, height: 26))
        button.addTarget(target: self, action: #selector(tappedOnBadgeButton))
        return button
    }()
    
    lazy var previewButtonItem: UIBarButtonItem = {
        let buttonItem = UIBarButtonItem(title: "预览", style: .plain, target: self, action: #selector(tappedOnPreviewButtonItem))
        buttonItem.setTitleTextAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 15)], for: .normal)
        buttonItem.tintColor = UIColor.black
        buttonItem.isEnabled = false
        return buttonItem
    }()
    
    // MARK: - Initialization
    
    init(album: YQAlbum) {
        currentAlbum = album
        assetsArray = YQAssetFetchManager.fetchImageAssetsViaCollectionResults(results: currentAlbum.results).reversed()
        selectedIndexes = []
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigation()
        
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setToolbarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setToolbarHidden(true, animated: true)
    }
    
    // MARK: - Setup
    
    private func setupNavigation() {
        let backBtnItem = UIBarButtonItem(title: "照片", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backBtnItem
    }
    
    private func setupViews() {
        self.title = currentAlbum.name ?? "照片"
        
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(collectionView)
        
        //navigation bar
        let cancelButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(tappedOnCancelButtonItem))
        self.navigationItem.rightBarButtonItem = cancelButtonItem
        
        //toolbar
        let okButtonItem = UIBarButtonItem(customView: badgeButton)
        let flexibleItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let fixedItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        fixedItem.width = -10
        self.setToolbarItems([previewButtonItem, flexibleItem, okButtonItem, fixedItem], animated: false)

    }
    
    // MARK: - User Interaction
    
    @objc private func tappedOnBadgeButton() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }

    @objc private func tappedOnPreviewButtonItem() {
        let selectedAssets = selectedIndexes.map { (index) -> PHAsset in
            return assetsArray[index]
        }
        
        let imageViewer = YQImageViewer(imageAssets: selectedAssets)
        self.navigationController?.pushViewController(imageViewer, animated: true)
    }
    
    @objc private func tappedOnCancelButtonItem() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
}

//MARK: - UICollectionViewDelegate

extension YQPhotoListViewController: UICollectionViewDelegateFlowLayout {

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: CollectionViewConfig.kThumbSizeLength,
                      height: CollectionViewConfig.kThumbSizeLength)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: CollectionViewConfig.minimumSpacing,
                            left: CollectionViewConfig.minimumSpacing,
                            bottom: CollectionViewConfig.minimumSpacing,
                            right: CollectionViewConfig.minimumSpacing)
    }
}

extension YQPhotoListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        let imageViewer = YQImageViewer(imageAssets: assetsArray, startPage: indexPath.row)
        self.navigationController?.pushViewController(imageViewer, animated: true)
    }
}

//MARK: - UICollectionViewDataSource

extension YQPhotoListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return assetsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewConfig.cellIdentifier, for: indexPath) as! YQAssetCell
        let index = indexPath.row
        let photoAsset = assetsArray[index]
        let scale = UIScreen.main.scale
        let size = CGSize(width: CollectionViewConfig.kThumbSizeLength * scale,
                          height: CollectionViewConfig.kThumbSizeLength * scale)
        let options = PHImageRequestOptions()
        options.resizeMode = .exact
        PHCachingImageManager.default().requestImage(for: photoAsset, targetSize: size, contentMode: .aspectFill, options: options) { (image, _) in
            cell.imageView.image = image
        }
        
        cell.selectItemClosure = { [weak self] (isSelected) in
            if isSelected {
                self?.selectedIndexes.insert(index)
            } else {
                self?.selectedIndexes.remove(index)
            }
        }
        
        return cell
    }
}
