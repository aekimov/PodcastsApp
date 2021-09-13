//
//  EpisodeCell.swift
//  Podcasts
//
//  Created by Artem Ekimov on 10.09.2021.
//

import UIKit

class EpisodeCell: UITableViewCell {
    
    var episode: Episode! {
        didSet {
            
            titleLabel.text = episode.title
            descriptionLabel.text = episode.description

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy"
            pubDateLabel.text = dateFormatter.string(from: episode.pubDate)
            
            let url = URL(string: episode.imageUrl?.toSecureHTTPS() ?? "")
            episodeImageView.sd_setImage(with: url, completed: nil)
        }
    }

    @IBOutlet weak var episodeImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var pubDateLabel: UILabel!
    
    
}
