//
//  ViewController.swift
//  HeySwift
//
//  Created by Andy VanWagoner on 6/10/14.
//  Copyright (c) 2014 Andy VanWagoner. All rights reserved.
//

import UIKit

class SearchResultsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, APIControllerProtocol {
    @IBOutlet var appsTableView: UITableView
    
    var api: APIController!
    var tableData = NSDictionary[]()
    var imageCache = Dictionary<String, UIImage>()
                            
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.api = APIController(delegate: self)
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        self.api.searchItunesFor("Adobe")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell = tableView.dequeueReusableCellWithIdentifier("SearchResultCell") as UITableViewCell,
            rowData = tableData[indexPath.row]
        
        cell.text = rowData["trackName"] as? String
        cell.detailTextLabel.text = rowData["formattedPrice"] as? String
        
        var urlString = rowData["artworkUrl60"] as? String
        // Check our image cache for the existing key. This is just a dictionary of UIImages
        let image = urlString ? self.imageCache[urlString!] : nil
        // Use blank if we don't have an image already
        cell.image = image ? image! : UIImage(named: "Blank52")
        
        if !image && urlString {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                // If the image does not exist, we need to download it
                // Download an NSData representation of the image at the URL
                var error: NSError?
                let data = NSData.dataWithContentsOfURL(NSURL(string: urlString), options: nil, error: &error)
                if !data {
                    println("Error: \(error?.localizedDescription)")
                } else {
                    let image = UIImage(data: data)
                    
                    // Update on the main queue
                    dispatch_async(dispatch_get_main_queue()) {
                        // Store the image in to our cache
                        self.imageCache[urlString!] = image
                        cell.image = image
                    }
                }
            }
        }
    
        return cell
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        // Get the row data for the selected row
        let rowData: AnyObject = self.tableData[indexPath.row] as AnyObject
        
        let alert = UIAlertView()
        alert.title = rowData["trackName"] as String
        alert.message = rowData["formattedPrice"] as String
        alert.addButtonWithTitle("Ok")
        alert.show()
    }
    
    func didRecieveAPIResults(results: NSDictionary) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        if results["results"] {
            tableData = results["results"] as NSDictionary[]
            appsTableView.reloadData()
        }
    }
}


