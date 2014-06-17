//
//  APISearchType.swift
//  HeySwift
//
//  Created by Andy VanWagoner on 6/12/14.
//  Copyright (c) 2014 Andy VanWagoner. All rights reserved.
//

import Foundation

enum APISearchType {
    case Apps
    case Albums
    case Songs
    case Everything
    
    
    func searchParams() -> String {
        var params = ""
        switch(self) {
        case .Apps:
            params = "&media=software"
        case .Albums:
            params = "&media=music&entity=album"
        case .Songs:
            params = "&media=music&entity=song"
        case .Everything:
            params = "&media=all"
        }
        return params
    }
}
