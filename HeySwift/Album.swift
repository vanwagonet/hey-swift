//
//  Album.swift
//  HeySwift
//
//  Created by Andy VanWagoner on 6/12/14.
//  Copyright (c) 2014 Andy VanWagoner. All rights reserved.
//

import Foundation

class Album {
    var title: String?
    var artist: String?
    var price: String?
    var thumbnailImageURL: String?
    var largeImageURL: String?
    var itemURL: String?
    var artistURL: String?
    var collectionId: Int?
    
    
    init(title: String?, artist: String?, price: String?, thumbnailImageURL: String?, largeImageURL: String?, itemURL: String?, artistURL: String?, collectionId: Int?) {
        self.title = title
        self.artist = artist
        self.price = price
        self.thumbnailImageURL = thumbnailImageURL
        self.largeImageURL = largeImageURL
        self.itemURL = itemURL
        self.artistURL = artistURL
        self.collectionId = collectionId
    }
    
    
    class func albumFromAPIResult(result: NSDictionary) -> Album? {
        var title = result["trackName"] as? String
        if !title {
            title = result["collectionName"] as? String
        }
        
        // Sometimes price comes in as formattedPrice, sometimes as collectionPrice.
        var price = result["formattedPrice"] as? String
        if !price {
            price = result["collectionPrice"] as? String
            if !price {
                let priceFloat = result["collectionPrice"] as? Float
                let format = NSNumberFormatter()
                format.maximumFractionDigits = 2;
                if priceFloat? {
                    price = "$" + format.stringFromNumber(priceFloat)
                }
            }
        }
        
        var itemURL = result["collectionViewUrl"] as? String
        if !itemURL? {
            itemURL = result["trackViewUrl"] as? String
        }
        
        return Album(
            title: title,
            artist: result["artistName"] as? String,
            price: price,
            thumbnailImageURL: result["artworkUrl60"] as? String,
            largeImageURL: result["artworkUrl100"] as? String,
            itemURL: itemURL,
            artistURL: result["artistViewUrl"] as? String,
            collectionId: result["collectionId"] as? Int
        )
    }
}
