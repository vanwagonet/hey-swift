//
//  APIController.swift
//  HeySwift
//
//  Created by Andy VanWagoner on 6/11/14.
//  Copyright (c) 2014 Andy VanWagoner. All rights reserved.
//

import UIKit

class APIController {
    
    var delegate: APIControllerProtocol
    
    
    init(delegate:APIControllerProtocol) {
        self.delegate = delegate
    }
    
    
    func searchItunesFor(type: APISearchType, with searchAttribute: APISearchAttribute = .Anything, containingTerms searchTerm: String...) {
        
            // The iTunes API wants multiple terms separated by + symbols
        let itunesSearchTerm = join("+", searchTerm),
            escapedSearchTerm = itunesSearchTerm.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding),
        
            typeParams = type.searchParams(),
            attributeParams = searchAttribute.searchParams(),
        
            url = "https://itunes.apple.com/search?term=\(escapedSearchTerm)\(typeParams)\(attributeParams)"
        
        getJSONFromItunes(url)
    }
    
    
    func lookupInItunes(type: APISearchType, inCollection collectionId:Int) {
        let typeParams = type.searchParams(),
            url = "https://itunes.apple.com/lookup?id=\(collectionId)\(typeParams)"
        
        getJSONFromItunes(url)
    }
    
    
    func getJSONFromItunes(url: String) {
        println("Search iTunes API at URL \(url)")
        
        let request = NSURLRequest(URL: NSURL(string: url))
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {
            response, data, error in
            if error {
                println("ERROR: (error.localizedDescription)")
            } else {
                var error: NSError?,
                jsonResult = NSJSONSerialization.JSONObjectWithData(data,
                    options: NSJSONReadingOptions.MutableContainers,
                    error: &error) as NSDictionary
                // Now send the JSON result to our delegate object
                if error {
                    println("HTTP Error: (error?.localizedDescription)")
                } else {
                    println("Results recieved")
                    self.delegate.didRecieveAPIResults(jsonResult)
                }
            }
        }
    }
}
