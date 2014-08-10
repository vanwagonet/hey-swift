//
//  UIImageLoader.swift
//  HeySwift
//
//  Created by Andy VanWagoner on 6/13/14.
//  Copyright (c) 2014 Andy VanWagoner. All rights reserved.
//

import UIKit

class UIImageLoader {
    class func loadURLString(url: String, completionHandler: (UIImage!, NSError!) -> ()) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            // Download an NSData representation of the image at the URL
            var image: UIImage?, error: NSError?
            if let data = NSData.dataWithContentsOfURL(NSURL(string: url), options: nil, error: &error) {
                image = UIImage(data: data)
            } else {
                println("Error: \(error?.localizedDescription)")
            }
            // Update on the main queue, since UI will need to redraw
            dispatch_sync(dispatch_get_main_queue()) {
                completionHandler(image, error)
            }
        }
    }
}
