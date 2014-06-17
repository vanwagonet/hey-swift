//
//  Song.swift
//  HeySwift
//
//  Created by Andy VanWagoner on 6/14/14.
//  Copyright (c) 2014 Andy VanWagoner. All rights reserved.
//

import Foundation

class Song {
    var title: String?
    var artist: String?
    var price: String?
    var duration: String?
    var previewURL: String?
    
    
    init(title: String?, artist: String?, price: String?, duration: String?, previewURL: String?) {
        self.title = title
        self.artist = artist
        self.price = price
        self.duration = duration
        self.previewURL = previewURL
    }
    
    
    class func songFromAPIResult(result: NSDictionary) -> Song? {
        let kind = result["kind"] as? String
        if "song" != kind {
            return nil
        }
        
        var duration: String?
        if let trackTime = result["trackTimeMillis"] as? Int {
            duration = "\(trackTime / 60000):\(trackTime / 1000)"
        }

        var price: String?
        if let priceFloat = result["trackPrice"] as? Float {
            if priceFloat > 0 {
                let format = NSNumberFormatter()
                format.maximumFractionDigits = 2;
                price = "$" + format.stringFromNumber(priceFloat)
            } else {
                price = "Album only"
            }
        }
        
        return Song(
            title: result["trackName"] as? String,
            artist: result["artistName"] as? String,
            price: price,
            duration: duration,
            previewURL: result["previewUrl"] as? String
        )
    }
}
