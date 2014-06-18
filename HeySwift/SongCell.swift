//
//  SongCell.swift
//  HeySwift
//
//  Created by Andy VanWagoner on 6/15/14.
//  Copyright (c) 2014 Andy VanWagoner. All rights reserved.
//

import UIKit

class SongCell: UITableViewCell {
    
    @IBOutlet var iconView: PlayPauseIconView
    @IBOutlet var titleLabel: UILabel
    @IBOutlet var artistLabel: UILabel
    
    
    init(style: UITableViewCellStyle, reuseIdentifier: String) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // Initialization code
    }
    
    
    func showPlayIcon() {
        iconView.showPlayIcon()
    }
    
    
    func showPauseIcon() {
        iconView.showPauseIcon()
    }
    
    
    func showWaitingIcon() {
        iconView.showWaitingIcon()
    }
}
