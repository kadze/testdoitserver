//
//  ImageCollection.swift
//  TestDoitServer
//
//  Created by ASH on 4/23/17.
//  Copyright © 2017 SAP. All rights reserved.
//

import Foundation

class ImageCollection {
    var items = [ImageCollectionItem]()
    var loadHandler: (() -> Void)? = nil
    var collectionLoadingContext: PictureListLoadingContext?  = nil {
        didSet {
            collectionLoadingContext?.execute()
        }
    }
    
    var count: Int {
        get {
            return items.count
        }
    }
    
    subscript(index: Int) -> ImageCollectionItem {
        get {
            return items[index]
        }
        set(newValue) {
            items[index] = newValue
        }
    }
    
    func load() {
        collectionLoadingContext = PictureListLoadingContext(imageCollection: self, completionHandler: loadHandler)
    }
}
