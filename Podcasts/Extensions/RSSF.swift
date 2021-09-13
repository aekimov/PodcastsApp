//
//  RSSF.swift
//  Podcasts
//
//  Created by Artem Ekimov on 11.09.2021.
//

import FeedKit

extension RSSFeed {
    func toEpisodes() -> [Episode] {
        
        let imageUrl = iTunes?.iTunesImage?.attributes?.href
        var episodes = [Episode]() // blank episode array
        
        items?.forEach({ feedItem in
            var episode = Episode(feedItem: feedItem)
            
            if episode.imageUrl == nil {
                episode.imageUrl = imageUrl
            }
            episodes.append(episode)
        })
        return episodes
    }
}
