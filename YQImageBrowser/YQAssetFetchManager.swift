//
//  YQAssetFetchManager.swift
//  YQImageBrowser
//
//  Created by WangYiqiao on 2017/1/12.
//  Copyright © 2017年 wyq. All rights reserved.
//

import Foundation
import Photos

class YQAssetFetchManager {
    
    static let shared = YQAssetFetchManager()
    
    private init() {}

    /// 获取所有相册
    ///
    /// - Returns: [YQAlbum]
    func fetchAllAlbums() -> [YQAlbum]{
        var albums: [YQAlbum] = []
        
        let options = PHFetchOptions()
        options.predicate = NSPredicate(format: "estimatedAssetCount > 0")
        
        //Alums
        let allAlbumsResult = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: nil)
        allAlbumsResult.enumerateObjects(using: { (collection, index, _) in
            let title = collection.localizedTitle
            let options = PHFetchOptions()
            options.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
            let results = PHAsset.fetchAssets(in: collection, options: options)
            if results.count > 0 {
                let yqAlbum = YQAlbum(results: results, name: title, startDate: collection.startDate as NSDate?, identifier: collection.localIdentifier)
                albums.append(yqAlbum)
            }
        })
        
        //Smart Albums
        let smartAlbumsResult = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: options)
        smartAlbumsResult.enumerateObjects(using: { (collection, index, _) in
            let title = collection.localizedTitle
            let options = PHFetchOptions()
            options.predicate = NSPredicate(format: "mediaType = %i", PHAssetMediaType.image.rawValue)
            let results = PHAsset.fetchAssets(in: collection, options: options)
            if results.count > 0 {
                let yqAlbum = YQAlbum(results: results, name: title, startDate: collection.startDate as NSDate?, identifier: collection.localIdentifier)
                albums.append(yqAlbum)
            }
        })
        
        return albums
    }
    
    ///获取图片Assets
    class func fetchImageAssetsViaCollectionResults(results: PHFetchResult<PHAsset>?) -> [PHAsset]{
        var resutsArray : [PHAsset] = []
        guard results != nil else {
            return resutsArray
        }
        results?.enumerateObjects({ (asset, index, isStop) -> Void in
            resutsArray.append(asset)
        })
        return resutsArray
    }
    
}
