//
//  EpisodesController.swift
//  Podcasts
//
//  Created by Artem Ekimov on 09.09.2021.
//

import UIKit
import FeedKit

class EpisodesController: UITableViewController {
    
    var podcast: Podcast? {
        didSet {
            navigationItem.title = podcast?.trackName
            fetchEpisodes()
        }
    }
    
    fileprivate func fetchEpisodes() {
        print("Looking for Episodes at feed URL:", podcast?.feedUrl ?? "")
        guard let feedUrl = podcast?.feedUrl else { return }
        
        APIService.shared.fetchEpisodes(feedUrl: feedUrl) { episodes in
            self.episodes = episodes
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    fileprivate let cellId = "cellId"
    
    var episodes = [Episode]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNavigationBarButtons()
    }
    
    
    //MARK:- Setups
    
    fileprivate func setupNavigationBarButtons() {
        
        let savedPodcasts = UserDefaults.standard.savedPodcasts()
        let hasFavourited = savedPodcasts.firstIndex(where: { $0.trackName == self.podcast?.trackName && $0.artistName == self.podcast?.artistName }) != nil
        if hasFavourited {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "35_heart"), style: .plain, target: nil, action: nil)
            
        } else {
            navigationItem.rightBarButtonItems = [
                UIBarButtonItem(title: "Favorite", style: .plain, target: self, action: #selector(handleSaveFavorite)),
//                UIBarButtonItem(title: "Fetch", style: .plain, target: self, action: #selector(handleFetchSavedPodcasts))
            ]
        }
    }
    
    @objc fileprivate func handleSaveFavorite() {
        print("Saving info into UD")
        
//        var listOfPodcasts = [Podcast]()
        
        guard let podcast = self.podcast else { return }
        
        
        
        //fetch saved podcasts
//        if let savedPodcastData = UserDefaults.standard.data(forKey: favoritePodcastKey) {
//            do {
//                if let savedPodcasts = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedPodcastData) as? [Podcast] {
//                    listOfPodcasts = savedPodcasts
//                }
//            } catch {
//                print(error)
//            }
//        }
        var listOfPodcasts = UserDefaults.standard.savedPodcasts()
        
        listOfPodcasts.append(podcast)
        
        //transform podcast into data
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: listOfPodcasts, requiringSecureCoding: false)
            UserDefaults.standard.set(data, forKey: UserDefaults.favoritePodcastKey)
            showBadgeHighlight()
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "35_heart"), style: .plain, target: nil, action: nil)
        } catch let error {
            print("Error encoding podcast", error)
        }
    }
    fileprivate func showBadgeHighlight() {
        UIApplication.mainTabBarController()?.viewControllers?[1].tabBarItem.badgeValue = "New"
    }


    @objc fileprivate func handleFetchSavedPodcasts() {
        print("Fetching saved Podcasts from UD")
        
        let value = UserDefaults.standard.value(forKey: UserDefaults.favoritePodcastKey) as? String
        print(value ?? "")
        
        //retrieve podcast info
        
        guard let data = UserDefaults.standard.data(forKey: UserDefaults.favoritePodcastKey) else { return }
        do {
            let savedPodcast = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [Podcast]
            savedPodcast?.forEach({ podcast in
                print(podcast.trackName ?? "")
            })
        } catch let error {
            print("Error decoding", error)
        }
        
    }
    
    fileprivate func setupTableView() {
        let nib = UINib(nibName: "EpisodeCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellId)
        tableView.tableFooterView = UIView()
    }
    
    //MARK: - UITableView
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let activityIndicatorView = UIActivityIndicatorView(style: .large)
        activityIndicatorView.color = .darkGray
        activityIndicatorView.startAnimating()
        return activityIndicatorView
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return episodes.isEmpty ? 200 : 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! EpisodeCell
        let episode = episodes[indexPath.row]
        cell.episode = episode
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 132
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let episode = self.episodes[indexPath.row]
        UIApplication.mainTabBarController()?.maximizedPlayerDetails(episode: episode, playlistEpisodes: self.episodes)

    }
}
