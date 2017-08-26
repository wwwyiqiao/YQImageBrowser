//
//  YQImageBrowser.swift
//  YQImageBrowser
//
//  Created by WangYiqiao on 2017/1/12.
//  Copyright © 2017年 wyq. All rights reserved.
//

import UIKit
import Photos

protocol YQImageBrowserDelegate: NSObjectProtocol {
    
    func imageBrowser(_ imageBrowser: YQImageBrowser, didSelectedPhotos photos: [PHAsset])
    
    func imageBroserDidCancel(_ imageBrowser: YQImageBrowser)
}

class YQImageBrowser: UITableViewController {
    
    //constant
    private struct TableViewConfig {
        static let cellIdentifier = "YQTableViewCellIdentifier"
        static let rowHeight: CGFloat = 60.0
        static let imageSize: CGSize = CGSize(width: 60.0 * UIScreen.main.scale, height: 60.0 * UIScreen.main.scale)
    }
    
    //data
    var albums: [YQAlbum] = []
    
    weak var delegate: YQImageBrowserDelegate?

    // MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.clearsSelectionOnViewWillAppear = false
        self.tableView.tableFooterView  = UIView()
        self.tableView.rowHeight = TableViewConfig.rowHeight
        
        setupViews()
        
        fetchAlbum()
    }
    
    // MARK: - Setup
    
    private func setupViews() {
        self.title = "相册"
        
        self.navigationController?.navigationBar.barTintColor = UIColor(colorLiteralRed: 45 / 255, green: 186 / 255, blue: 239 / 255, alpha: 1.0)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.isTranslucent = true
        
        let cancelButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(tappedOnCancelButtonItem))
        self.navigationItem.rightBarButtonItem = cancelButtonItem
        
        self.tableView.register(YQAlbumCell.self, forCellReuseIdentifier: TableViewConfig.cellIdentifier)
    }
    
    // MARK: - Private 
    
    private func fetchAlbum() {
        self.albums = YQAssetFetchManager.shared.fetchAllAlbums()
        self.tableView.reloadData()
    }
    
    // MARK: - User Interaction
    
    @objc private func tappedOnCancelButtonItem() {
        self.delegate?.imageBroserDidCancel(self)
    }
    
    // MARK: - TableView Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let album = self.albums[indexPath.row]
        let photoListVC = YQPhotoListViewController(album: album)
        self.navigationController?.pushViewController(photoListVC, animated: true)
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewConfig.cellIdentifier, for: indexPath)
        
        let album = albums[indexPath.row]
        let asset = album.results.lastObject!
        let options = PHImageRequestOptions()
        options.resizeMode = .exact
        options.isSynchronous = true
        PHImageManager.default().requestImage(for: asset, targetSize: TableViewConfig.imageSize, contentMode: .aspectFill, options: options) { (image, _) in
            cell.imageView?.image = image
        }

        cell.textLabel?.text = album.name ?? "相册"
        cell.detailTextLabel?.text = "(\(album.count))";
        cell.accessoryType = .disclosureIndicator

        return cell
    }

}
