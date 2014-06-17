//
//  DetailsViewController.swift
//  HeySwift
//
//  Created by Andy VanWagoner on 6/13/14.
//  Copyright (c) 2014 Andy VanWagoner. All rights reserved.
//

import UIKit
import MediaPlayer

class DetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, APIControllerProtocol {

    @IBOutlet var albumCover: UIImageView
    @IBOutlet var priceLabel: UILabel
    @IBOutlet var openButton: UIButton
    @IBOutlet var tracksTableView: UITableView
    
    let mediaPlayer = MPMoviePlayerController()
    
    var api: APIController!
    var album: Album?
    var songs: Song[] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        api = APIController(delegate: self)
        if album?.collectionId {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            api.lookupInItunes(.Songs, inCollection: album!.collectionId!)
        }

        title = album?.title
        priceLabel.text = album?.price
        albumCover.image = UIImage(named: "Blank52")
        
        if let urlString = album?.largeImageURL {
            UIImageLoader.loadURLString(urlString) {
                image, error in
                if image {
                    self.albumCover.image = image
                }
            }
        }
        
        let center = NSNotificationCenter.defaultCenter(),
            queue = NSOperationQueue.mainQueue()
        center.addObserverForName("MPMoviePlayerPlaybackDidFinishNotification", object: mediaPlayer, queue: queue) {
            notification in
            let reasonInt = notification.userInfo["MPMoviePlayerPlaybackDidFinishReasonUserInfoKey"] as? Int,
                reason = reasonInt ? MPMovieFinishReason.fromRaw(reasonInt!) : nil
            if MPMovieFinishReason.PlaybackEnded == reason {
                self.playbackDidFinish()
            }
        }
    }
    
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        mediaPlayer.stop()
        mediaPlayer.contentURL = nil
    }
    
    
    @IBAction func buyLinkTouchUp(sender: AnyObject) {
        println("Open album link at URL \(album?.itemURL)")
        UIApplication.sharedApplication().openURL(NSURL(string: album?.itemURL))
    }
    
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        var cell = tableView.dequeueReusableCellWithIdentifier("SongCell") as SongCell
        
        var song = songs[indexPath.row]
        cell.song = song
        cell.titleLabel.text = song.title
        let artistText = (song.artist && song.artist != album?.artist) ? " - " + song.artist! : ""
        cell.artistLabel.text = (song.price ? song.price! : "") + artistText
        cell.showPlayIcon()
        
        return cell
    }
    
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        if let cell = tableView.cellForRowAtIndexPath(indexPath) as? SongCell {
            let song = songs[indexPath.row]
            let preview = NSURL(string: song.previewURL!)
            if mediaPlayer.contentURL? == preview {
                if cell.iconView.isPlaying {
                    mediaPlayer.pause()
                    cell.showPlayIcon()
                    tableView.deselectRowAtIndexPath(indexPath, animated: true)
                    println("Pause \(song.title) from \(song.previewURL)")
                } else {
                    mediaPlayer.play()
                    cell.showPauseIcon()
                    println("Resume \(song.title) from \(song.previewURL)")
                }
            } else {
                mediaPlayer.stop()
                mediaPlayer.contentURL = preview
                mediaPlayer.play()
                cell.showPauseIcon()
                println("Play \(song.title) from \(song.previewURL)")
            }
        }
    }
    
    
    func tableView(tableView: UITableView!, didDeselectRowAtIndexPath indexPath: NSIndexPath!) {
        if let cell = tableView.cellForRowAtIndexPath(indexPath) as? SongCell {
            cell.showPlayIcon()
        }
    }
    
    
    func didRecieveAPIResults(results: NSDictionary) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        if results["results"] {
            songs = []
            let items = results["results"] as NSDictionary[]
            for result in items {
                if let song = Song.songFromAPIResult(result) {
                    songs.append(song)
                }
            }
            tracksTableView.reloadData()
        }
    }
    
    
    func playbackDidFinish() {
        println("Finshed song")
        if let indexPath = tracksTableView.indexPathForSelectedRow() {
            if let cell = tracksTableView.cellForRowAtIndexPath(indexPath) as? SongCell {
                tracksTableView.deselectRowAtIndexPath(indexPath, animated: true)
                cell.showPlayIcon()
            }
        /*
            // can trigger when the user selects a new row, not just when the song ends
            if indexPath.row < songs.count - 1 {
                let row = indexPath.row + 1,
                newPath = NSIndexPath(forRow: row, inSection: indexPath.section)
                tracksTableView.selectRowAtIndexPath(newPath,
                    animated: true, scrollPosition: UITableViewScrollPosition.Top
                )
                tableView(tracksTableView, didSelectRowAtIndexPath: newPath)
            }
        */
        }
    }
    

    /*
    // #pragma mark - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
