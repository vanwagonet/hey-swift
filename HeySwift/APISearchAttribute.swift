//
//  APISearchAttribute.swift
//  HeySwift
//
//  Created by Andy VanWagoner on 6/12/14.
//  Copyright (c) 2014 Andy VanWagoner. All rights reserved.
//

import Foundation

enum APISearchAttribute {
    case Artist
    case Album
    case Song
    case Developer
    case Anything
    
    
    func searchParams() -> String {
        var params = ""
        switch(self) {
        case .Artist:
            params = "&attribute=artistTerm"
        case .Album:
            params = "&attribute=albumTerm"
        case .Song:
            params = "&attribute=songTerm"
        case .Developer:
            params = "&attribute=softwareDeveloper"
        case .Anything:
            params = ""
        }
        return params
    }
}