//
//  UserDefaults.swift
//  Podcasts
//
//  Created by Artem Ekimov on 18.09.2021.
//

import Foundation
    
extension UserDefaults {
    static let favoritePodcastKey = "favoritePodcastKey"
    
    func savedPodcasts() -> [Podcast] {
        var listOfPodcasts = [Podcast]()
        if let savedPodcastData = UserDefaults.standard.data(forKey: UserDefaults.favoritePodcastKey) {
            do {
                if let savedPodcasts = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedPodcastData) as? [Podcast] {
                    listOfPodcasts = savedPodcasts
                }
            } catch {
                print(error)
            }
        }
        return listOfPodcasts
    }
    
    func deletePodcast(podcast: Podcast) {
        let podcasts = savedPodcasts()
        let filteredPodcasts = podcasts.filter { (p) -> Bool in
            return p.trackName != podcast.trackName && p.artistName != podcast.artistName
        }
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: filteredPodcasts, requiringSecureCoding: false)
            UserDefaults.standard.set(data, forKey: UserDefaults.favoritePodcastKey)
        } catch {
            print(error)
        }
    }
}
