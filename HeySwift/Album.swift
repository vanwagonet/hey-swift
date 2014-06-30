//
//  Album.swift
//  HeySwift
//
//  Created by Andy VanWagoner on 6/12/14.
//  Copyright (c) 2014 Andy VanWagoner. All rights reserved.
//

import Foundation

class Album {
    var
        id: Int,
        name: String,
        viewURL: String,
        artworkThumbnailURL: String,
        artworkDetailURL: String,
        artistName: String,
        price: Double?,
        currency: String
    
    var formattedPrice: String {
        get {
            if price {
                let formatter = NSNumberFormatter();
                formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
                formatter.currencyCode = currency
                return formatter.stringFromNumber(NSNumber(double: price!))
            } else {
                return "Not Available"
            }
        }
    }
    
    
    init(id: Int, name: String, viewURL: String, artworkThumbnailURL: String, artworkDetailURL: String, artistName: String, price: Double?, currency: String) {
        self.id = id
        self.name = name
        self.viewURL = viewURL
        self.artworkThumbnailURL = artworkThumbnailURL
        self.artworkDetailURL = artworkDetailURL
        self.artistName = artistName
        self.price = price
        self.currency = currency
    }
    
    
    /*
    Example JSON:
    {
        "wrapperType":"collection", "collectionType":"Album",
        "collectionId":557345871, "collectionName":"The Piano Guys", "collectionCensoredName":"The Piano Guys",
        "collectionViewUrl":"https://itunes.apple.com/us/album/the-piano-guys/id557345871?uo=4",
        "artworkUrl60":"http://a4.mzstatic.com/us/r30/Music/v4/6a/3a/ed/6a3aeda1-219d-caf8-a187-1c39c2d08c36/886443608467.60x60-50.jpg",
        "artworkUrl100":"http://a3.mzstatic.com/us/r30/Music/v4/6a/3a/ed/6a3aeda1-219d-caf8-a187-1c39c2d08c36/886443608467.100x100-75.jpg",
        "artistId":498030399, "amgArtistId":2597956, "artistName":"The Piano Guys",
        "artistViewUrl":"https://itunes.apple.com/us/artist/the-piano-guys/id498030399?uo=4",
        "collectionPrice":10.99, "currency":"USD", "collectionExplicitness":"notExplicit", "trackCount":13,
        "copyright":"℗ 2012 TPG Productions LLC", "country":"USA", "releaseDate":"2012-10-02T07:00:00Z", "primaryGenreName":"Classical"
    }
    */
    class func albumFromItunesAPIResult(result: NSDictionary) -> Album? {
        let type = result["collectionType"] as? String
        if "Album" != type {
            return nil
        }
        
        let
        id = result["collectionId"] as? Int,
        name = result["collectionName"] as? String
        if !id || !name { return nil }
        
        var viewURL = result["collectionViewUrl"] as? String
        if !viewURL { viewURL = "" }
        
        var artworkThumbnailURL = result["artworkUrl60"] as? String
        if !artworkThumbnailURL { artworkThumbnailURL = "" }
        
        var artworkDetailURL = result["artworkUrl100"] as? String
        if !artworkDetailURL { artworkDetailURL = "" }
        
        var artistName = result["artistName"] as? String
        if !artistName { artistName = "" }
        
        var price = result["collectionPrice"] as? Double
        if price < 0 { price = nil }
        
        var currency = result["currency"] as? String
        if !currency { currency = "USD" }
        
        return Album(
            id: id!,
            name: name!,
            viewURL: viewURL!,
            artworkThumbnailURL: artworkThumbnailURL!,
            artworkDetailURL: artworkDetailURL!,
            artistName: artistName!,
            price: price,
            currency: currency!
        )
    }
}
