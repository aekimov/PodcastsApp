//
//  Episode.swift
//  Podcasts
//
//  Created by Artem Ekimov on 10.09.2021.
//

import Foundation
import FeedKit

struct Episode {
    let title: String
    let pubDate: Date
    let description: String
    var imageUrl: String?
    let author: String
    let streamUrl: String?
    
    init(feedItem: RSSFeedItem) {
        self.streamUrl = feedItem.enclosure?.attributes?.url ?? ""
        self.title = feedItem.title ?? ""
        self.pubDate = feedItem.pubDate ?? Date()
        self.description = feedItem.iTunes?.iTunesSubtitle ?? feedItem.description ?? ""
        
        self.imageUrl = feedItem.iTunes?.iTunesImage?.attributes?.href
        self.author = feedItem.iTunes?.iTunesAuthor ?? ""
    }
}
