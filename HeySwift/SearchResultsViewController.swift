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
    var albums = Album[]()
    var imageCache = Dictionary<String, UIImage>()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        api = APIController(delegate: self)
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        api.searchItunesFor(.Albums, with: .Artist, containingTerms: "Piano", "Guys")
        title = "Piano Guys"
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }
    
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell = tableView.dequeueReusableCellWithIdentifier("SearchResultCell") as UITableViewCell,
            album = albums[indexPath.row]
        
        cell.text = album.title
        cell.detailTextLabel.text = album.price
        
        var urlString = album.thumbnailImageURL
        // Check our image cache for the existing key. This is just a dictionary of UIImages
        let image = urlString ? self.imageCache[urlString!] : nil
        // Use blank if we don't have an image already
        cell.image = image ? image! : UIImage(named: "Blank52")
        
        if !image && urlString {
            UIImageLoader.loadURLString(urlString!) {
                image, error in
                if image {
                    self.imageCache[urlString!] = image
                    cell.image = image
                }
            }
        }
    
        return cell
    }
    
    
    func didRecieveAPIResults(results: NSDictionary) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        if results["results"] {
            albums = []
            let items = results["results"] as NSDictionary[]
            for result in items {
                if let album = Album.albumFromAPIResult(result) {
                    albums.append(album)
                }
            }
            appsTableView.reloadData()
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject) {
        var detailsViewController = segue.destinationViewController as DetailsViewController
        let albumIndex = appsTableView.indexPathForSelectedRow().row
        let selectedAlbum = self.albums[albumIndex]
        detailsViewController.album = selectedAlbum
        println("Selected album \(selectedAlbum.title)")
    }
}


