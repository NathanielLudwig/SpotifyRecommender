//
//  TrackTableViewCell.swift
//  SpotifyRecommender
//
//  Created by 90303054 on 5/17/20.
//  Copyright © 2020 90303054. All rights reserved.
//

import UIKit
protocol TrackCellDelegate {
    func moreButtonPressed(at track: Track, button: UIButton)
}
class TrackTableViewCell: UITableViewCell {

    @IBOutlet weak var albumArt: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var track: Track?
    
    var delegate: TrackCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        albumArt.isHidden = true
        titleLabel.isHidden = true
        artistLabel.isHidden = true
        // Initialization code
    }
    func configure(with track: Track, image: UIImage) {
        titleLabel.text = track.name
        var artistNames: [String] = []
        for artist in track.artists {
            artistNames.append(artist.name)
        }
        artistLabel.text = artistNames.joined(separator: ", ")
        albumArt.image = image
        spinner.stopAnimating()
        albumArt.isHidden = false
        titleLabel.isHidden = false
        artistLabel.isHidden = false
        self.track = track
    }

    @IBAction func moreButtonPressed(_ sender: Any) {
        if let track = track {
            delegate?.moreButtonPressed(at: track, button: sender as! UIButton)
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
