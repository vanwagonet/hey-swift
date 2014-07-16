//
//  ViewController.swift
//  HeySwift
//
//  Created by Andy VanWagoner on 6/10/14.
//  Copyright (c) 2014 Andy VanWagoner. All rights reserved.
//

import UIKit

class SearchResultsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ItunesAPIControllerProtocol {
    @IBOutlet var appsTableView: UITableView
    
    var api: ItunesAPIController!
    var albums = [Album]()
    var imageCache = [String:UIImage]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        api = ItunesAPIController(delegate: self)
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        api.searchItunesFor(.Albums, with: .Artist, containingTerms: "Piano", "Guys")
        title = "Piano Guys"
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        ADBMobile.trackState("Album List", data: [
            "swf.searchterms": title
        ])
        ADBMobile.trackTimedActionStart("Selected Album", data: nil)
    }
    
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }
    
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let reuseId = "SearchResultCell",
            reused = tableView.dequeueReusableCellWithIdentifier(reuseId) as? UITableViewCell,
            cell = reused ? reused! : UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: reuseId),
            album = albums[indexPath.row]
        
        cell.textLabel.text = album.name
        cell.detailTextLabel.text = album.formattedPrice
        
        var urlString: String? = album.artworkThumbnailURL.isEmpty ? nil : album.artworkThumbnailURL
        // Check our image cache for the existing key. This is just a dictionary of UIImages
        let image = urlString ? self.imageCache[urlString!] : nil
        // Use blank if we don't have an image already
        cell.imageView.image = image ? image! : UIImage(named: "Blank52")
        
        if !image && urlString {
            UIImageLoader.loadURLString(urlString!) {
                (image: UIImage!, error: NSError!) in
                if image {
                    self.imageCache[urlString!] = image
                    cell.imageView.image = image
                }
            }
        }
    
        return cell
    }
    
    
    func didRecieveAPIResults(results: NSDictionary) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        if results["results"] {
            albums = []
            let items = results["results"] as [NSDictionary]
            for result in items {
                if let album = Album.albumFromItunesAPIResult(result) {
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
        ADBMobile.trackTimedActionUpdate("Selected Album", data: [
            "swf.album": selectedAlbum.name
        ])
        ADBMobile.trackTimedActionEnd("Selected Album", logic: nil)
    }
}


