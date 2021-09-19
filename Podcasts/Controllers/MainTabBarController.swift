//
//  MainTabBarController.swift
//  Podcasts
//
//  Created by Artem Ekimov on 07.09.2021.
//

import UIKit

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = .purple
        UINavigationBar.appearance().prefersLargeTitles = true
        setupViewControllers()
        setupPlayerDetailsView()
        
    }
    
    
    @objc func minimizePlayerDetails() {
        
        maximizedTabBarAnchorConstraint.isActive = false
        bottomAnchorConstraint.constant = view.frame.height
        minimizedTabBarAnchorConstraint.isActive = true
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut) {
            self.view.layoutIfNeeded()
            self.tabBar.isHidden = false
            self.playerDetailsView.maximizedStackView.alpha = 0
            self.playerDetailsView.miniPlayerView.alpha = 1
        }
    }
    
    func maximizedPlayerDetails(episode: Episode?, playlistEpisodes: [Episode] = []) {
        
        minimizedTabBarAnchorConstraint.isActive = false
        maximizedTabBarAnchorConstraint.isActive = true
        maximizedTabBarAnchorConstraint.constant = 0
        
        bottomAnchorConstraint.constant = 0
        
        if episode != nil {
            playerDetailsView.episode = episode
        }
        playerDetailsView.playlistEpisodes = playlistEpisodes
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut) {
            self.tabBar.isHidden = true
            self.view.layoutIfNeeded()
            
            self.playerDetailsView.maximizedStackView.alpha = 1
            self.playerDetailsView.miniPlayerView.alpha = 0
        }
    }
    
// MARK: - Setup Functions
    
    let playerDetailsView = PlayerDetailsView.initFromNib()
    
    var maximizedTabBarAnchorConstraint: NSLayoutConstraint!
    var minimizedTabBarAnchorConstraint: NSLayoutConstraint!
    var bottomAnchorConstraint: NSLayoutConstraint!
    
    fileprivate func setupPlayerDetailsView() {

        view.insertSubview(playerDetailsView, belowSubview: tabBar)
        
        playerDetailsView.translatesAutoresizingMaskIntoConstraints = false // ensbles autolayout
        
        maximizedTabBarAnchorConstraint = playerDetailsView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height)
        maximizedTabBarAnchorConstraint.isActive = true
        
        bottomAnchorConstraint = playerDetailsView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: view.frame.height)
        
        bottomAnchorConstraint.isActive = true
        
        minimizedTabBarAnchorConstraint = playerDetailsView.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -64)
//        minimizedTabBarAnchorConstraint.isActive = true
        
        playerDetailsView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        
        playerDetailsView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
 
    }
    
        
    func setupViewControllers() {
        let layout = UICollectionViewFlowLayout()
        let favoritesController = FavoritesController(collectionViewLayout: layout)
        
        viewControllers = [
            generateNavigationController(for: PodcastsSearchController(), title: "Search", image: #imageLiteral(resourceName: "search")),
            generateNavigationController(for: favoritesController, title: "Favorites", image: #imageLiteral(resourceName: "favorites")),
            generateNavigationController(for: ViewController(), title: "Downloads", image: #imageLiteral(resourceName: "downloads"))
        ]
    }
}
    
// MARK: - Helper Functions
    
    fileprivate func generateNavigationController (for rootViewController: UIViewController, title: String, image: UIImage) -> UIViewController {
        
        let navController = UINavigationController(rootViewController: rootViewController)
        rootViewController.navigationItem.title = title
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        return navController
    }
