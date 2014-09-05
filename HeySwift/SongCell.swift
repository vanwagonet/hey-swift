//
//  SongCell.swift
//  HeySwift
//
//  Created by Andy VanWagoner on 6/15/14.
//  Copyright (c) 2014 Andy VanWagoner. All rights reserved.
//

import UIKit

class SongCell: UITableViewCell {
    
    @IBOutlet var iconView: PlayPauseIconView!
    @IBOutlet var spinner: UIActivityIndicatorView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var artistLabel: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // Initialization code
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func showPlayIcon() {
        spinner.stopAnimating()
        iconView.showPlayIcon()
    }
    
    
    func showPauseIcon() {
        spinner.stopAnimating()
        iconView.showPauseIcon()
    }
    
    
    func showWaitingIcon() {
        spinner.startAnimating()
        iconView.showWaitingIcon()
    }
}

