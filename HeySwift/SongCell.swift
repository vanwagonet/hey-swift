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
    
    var song: Song!
    
    
    init(style: UITableViewCellStyle, reuseIdentifier: String) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // Initialization code
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
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
