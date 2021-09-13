//
//  Podcast.swift
//  Podcasts
//
//  Created by Artem Ekimov on 08.09.2021.
//

import Foundation

struct Podcast: Codable {
    var trackName: String?
    var artistName: String?
    var artworkUrl600: String?
    var trackCount: Int?
    var feedUrl: String?
}

