//
//  APIController.swift
//  HeySwift
//
//  Created by Andy VanWagoner on 6/11/14.
//  Copyright (c) 2014 Andy VanWagoner. All rights reserved.
//

import UIKit

protocol APIControllerProtocol {
    func didRecieveAPIResults(results: NSDictionary)
}

class APIController {
    
    var delegate: APIControllerProtocol
    
    init(delegate:APIControllerProtocol) {
        self.delegate = delegate
    }
    
    func searchItunesFor(searchTerm: String) {
        
            // The iTunes API wants multiple terms separated by + symbols, so replace spaces with + signs
        var itunesSearchTerm = searchTerm.stringByReplacingOccurrencesOfString(" ", withString: "+"),
        
            // Now escape anything else that isn't URL-friendly
            escapedSearchTerm = itunesSearchTerm.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding),
        
            urlPath = "https://itunes.apple.com/search?term=\(escapedSearchTerm)&media=software",
            url = NSURL(string: urlPath),
            request = NSURLRequest(URL: url)
        
        println("Search iTunes API at URL \(url)")
        
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
