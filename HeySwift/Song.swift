//
//  Song.swift
//  HeySwift
//
//  Created by Andy VanWagoner on 6/14/14.
//  Copyright (c) 2014 Andy VanWagoner. All rights reserved.
//

import Foundation

class Song {
    var
        id: Int,
        name: String,
        previewURL: String,
        artistName: String,
        durationMs: Int,
        price: Double?,
        currency: String
    
    var formattedPrice: String {
        get {
            if price != nil {
                let formatter = NSNumberFormatter();
                formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
                formatter.currencyCode = currency
                return formatter.stringFromNumber(NSNumber(double: price!))
            } else {
                return "Album Only"
            }
        }
    }
    
    var formattedDuration: String {
        get {
            return "\(durationMs / 60000):\(durationMs / 1000)"
        }
    }
    
    
    init(id: Int, name: String, previewURL: String, artistName: String, durationMs: Int, price: Double?, currency: String) {
        self.id = id
        self.name = name
        self.previewURL = previewURL
        self.artistName = artistName
        self.durationMs = durationMs
        self.price = price
        self.currency = currency
    }
    
    
    /*
    Example JSON:
    {
        "wrapperType":"track", "kind":"song",
        "trackId":557345879, "trackName":"Titanium / Pavane", "trackCensoredName":"Titanium / Pavane",
        "trackViewUrl":"https://itunes.apple.com/us/album/titanium-pavane/id557345871?i=557345879&uo=4",
        "artworkUrl30":"http://a5.mzstatic.com/us/r30/Music/v4/6a/3a/ed/6a3aeda1-219d-caf8-a187-1c39c2d08c36/886443608467.30x30-50.jpg",
        "artworkUrl60":"http://a4.mzstatic.com/us/r30/Music/v4/6a/3a/ed/6a3aeda1-219d-caf8-a187-1c39c2d08c36/886443608467.60x60-50.jpg",
        "artworkUrl100":"http://a3.mzstatic.com/us/r30/Music/v4/6a/3a/ed/6a3aeda1-219d-caf8-a187-1c39c2d08c36/886443608467.100x100-75.jpg",
        "previewUrl":"http://a921.phobos.apple.com/us/r1000/065/Music/a9/aa/a7/mzi.uxnumujc.aac.p.m4a",
        "radioStationUrl":"https://itunes.apple.com/station/idra.557345879",
        "collectionId":557345871, "collectionName":"The Piano Guys", "collectionCensoredName":"The Piano Guys",
        "collectionViewUrl":"https://itunes.apple.com/us/album/titanium-pavane/id557345871?i=557345879&uo=4",
        "artistId":498030399, "artistName":"The Piano Guys",
        "artistViewUrl":"https://itunes.apple.com/us/artist/the-piano-guys/id498030399?uo=4",
        "collectionPrice":10.99, "trackPrice":1.29, "currency":"USD",
        "collectionExplicitness":"notExplicit", "trackExplicitness":"notExplicit",
        "discCount":1, "discNumber":1, "trackCount":13, "trackNumber":1, "trackTimeMillis":290437,
        "releaseDate":"2012-10-02T07:00:00Z", "country":"USA", "primaryGenreName":"Classical"
    }
    */
    class func songFromItunesAPIResult(result: NSDictionary) -> Song? {
        if "song" != result["kind"] as? String {
            return nil
        }
        
        let
        id = result["trackId"] as? Int,
        name = result["trackName"] as? String
        if id == nil || name == nil {
			return nil
		}
        
        let
		previewURL = result["previewUrl"] as? String ?? "",
        artistName = result["artistName"] as? String ?? "",
        durationMs = result[""] as? Int ?? 0,
		currency = result["currency"] as? String ?? "USD"
        
        var price = result["trackPrice"] as? Double
        if price < 0 { price = nil }
        
        return Song(
            id: id!,
            name: name!,
            previewURL: previewURL,
            artistName: artistName,
            durationMs: durationMs,
            price: price,
            currency: currency
        )
    }
}

