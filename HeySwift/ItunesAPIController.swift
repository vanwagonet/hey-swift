//
//  APIController.swift
//  HeySwift
//
//  Created by Andy VanWagoner on 6/11/14.
//  Copyright (c) 2014 Andy VanWagoner. All rights reserved.
//

import UIKit

class ItunesAPIController {
    
    var delegate: ItunesAPIControllerProtocol
    
    let paramTypeMap: Dictionary<ItunesAPISearchType, String> = [
        .Apps: "&media=software",
        .Albums: "&media=music&entity=album",
        .Songs: "&media=music&entity=song",
        .Everything: "&media=all"
    ]
    
    let paramAttributeMap: Dictionary<ItunesAPISearchAttribute, String> = [
        .Artist: "&attribute=artistTerm",
        .Album: "&attribute=albumTerm",
        .Song: "&attribute=songTerm",
        .Developer: "&attribute=softwareDeveloper",
        .Anything: ""
    ]
    
    init(delegate: ItunesAPIControllerProtocol) {
        self.delegate = delegate
    }
    
    
    func searchParamsForType(type: ItunesAPISearchType) -> String {
        if let params = paramTypeMap[type] {
            return params
        }
        return ""
    }
    
    
    func searchParamsForAttribute(attribute: ItunesAPISearchAttribute) -> String {
        if let params = paramAttributeMap[attribute] {
            return params
        }
        return ""
    }
    
    
    func searchItunesFor(type: ItunesAPISearchType, with searchAttribute: ItunesAPISearchAttribute = .Anything, containingTerms searchTerm: String...) {
        
            // The iTunes API wants multiple terms separated by + symbols
        let itunesSearchTerm = join("+", searchTerm),
            escapedSearchTerm = itunesSearchTerm.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding),
        
            typeParams = searchParamsForType(type),
            attributeParams = searchParamsForAttribute(searchAttribute),
        
            url = "https://itunes.apple.com/search?term=\(escapedSearchTerm)\(typeParams)\(attributeParams)"
        
        getJSONFromItunes(url)
    }
    
    
    func lookupInItunes(type: ItunesAPISearchType, inCollection collectionId:Int) {
        let typeParams = searchParamsForType(type),
            url = "https://itunes.apple.com/lookup?id=\(collectionId)\(typeParams)"
        
        getJSONFromItunes(url)
    }
    
    
    func getJSONFromItunes(url: String) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            // Download an NSData representation of the image at the URL
            var error: NSError?
            if let data = NSData.dataWithContentsOfURL(NSURL(string: url), options: nil, error: &error) {
                let jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &error) as? NSDictionary
                if let json = jsonResult {
                    // Update on the main queue
                    dispatch_sync(dispatch_get_main_queue()) {
                        self.delegate.didRecieveAPIResults(json)
                    }
                } else {
                    println("JSON Error: \(error?.localizedDescription)")
                }
            } else {
                println("HTTP Error: \(error?.localizedDescription)")
            }
        }
    }
}
